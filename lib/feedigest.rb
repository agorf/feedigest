begin
  require 'dotenv/load'
rescue LoadError
end

require 'feedjira'
require 'mail'
require 'nokogiri'
require 'reverse_markdown'

class Feedigest
  ENTRY_WINDOW = ENV.fetch('FEEDIGEST_ENTRY_WINDOW', 60 * 60 * 24) # Seconds
  EMAIL_SENDER = ENV.fetch(
    'FEEDIGEST_EMAIL_SENDER',
    "feedigest@#{`hostname`.strip}"
  )
  EMAIL_RECIPIENT = ENV.fetch('FEEDIGEST_EMAIL_RECIPIENT')
  DELIVERY_METHOD = ENV.fetch('FEEDIGEST_DELIVERY_METHOD', 'sendmail').to_sym

  Feed = Struct.new(:url, :title, :entries, :error)

  attr_reader :feed_urls

  def initialize(feed_urls)
    @feed_urls = feed_urls
  end

  def send_email
    email.deliver if send_email?
  end

  def to_s
    email.to_s
  end

  private

  def send_email?
    feeds.any?
  end

  def email
    return @email if @email

    mail = Mail.new
    mail.from = EMAIL_SENDER
    mail.to = EMAIL_RECIPIENT
    mail.subject = email_subject
    mail.text_part = email_text_part
    mail.html_part = email_html_part

    setup_delivery_method(mail)

    @email = mail
  end

  def setup_delivery_method(mail)
    mail.delivery_method(DELIVERY_METHOD, delivery_method_options)
  end

  def delivery_method_options
    case DELIVERY_METHOD
    when :smtp
      {
        address: ENV.fetch('FEEDIGEST_SMTP_HOST'),
        port: ENV.fetch('FEEDIGEST_SMTP_PORT', '587').to_i,
        user_name: ENV.fetch('FEEDIGEST_SMTP_USERNAME'),
        password: ENV.fetch('FEEDIGEST_SMTP_PASSWORD'),
        authentication: ENV.fetch('FEEDIGEST_SMTP_AUTH', 'plain'),
        enable_starttls: ENV.fetch('FEEDIGEST_SMTP_STARTTLS', 'true') == 'true'
      }
    else
      {}
    end
  end

  def email_subject
    sprintf(
      'Digest for %s in %s',
      pluralize(entries_count, 'entry', 'entries'),
      pluralize(feeds_without_error.size, 'feed')
    )
  end

  def email_text_part
    Mail::Part.new.tap do |p|
      p.content_type 'text/plain; charset=utf-8'
      p.body email_body_text
    end
  end

  def email_html_part
    Mail::Part.new.tap do |p|
      p.content_type 'text/html; charset=utf-8'
      p.body email_body_html
    end
  end

  def email_body_html
    @email_body_html ||=
      Nokogiri::HTML::Builder.new(encoding: 'utf-8') { |builder|
        builder.div do
          feeds.each do |feed|
            feed_html(builder, feed)
          end
        end
      }.to_html
  end

  def email_body_text
    ReverseMarkdown.convert(email_body_html)
  end

  def feed_html(builder, feed)
    builder.div do
      if feed.error
        builder.h2 feed.url
        builder.p "Error: #{feed.error}"
      else
        builder.h2 feed.title
        entries_html(builder, feed.entries)
      end
    end
  end

  def entries_html(builder, entries)
    entries.group_by { |e| e.published.to_date }.each do |date, date_entries|
      builder.h3 date

      date_entries.each do |entry|
        entry_html(builder, entry)
      end
    end
  end

  def entry_html(builder, entry)
    builder.p do
      builder.a(entry.title, href: entry.url)
    end
  end

  def feeds
    @feeds ||= all_feeds.select { |f| process_feed?(f) }
  end

  def feeds_without_error
    feeds.select { |feed| feed[:error].nil? }
  end

  def process_feed?(feed)
    feed[:error] || feed[:entries].any?
  end

  def all_feeds
    feed_urls.map { |url| feed_from_url(url) }
  end

  def feed_from_url(url)
    feed, error = fetch_and_parse_feed(url)
    Feed.new(
      url,
      feed&.title,
      error ? [] : feed_entries(feed),
      error
    )
  end

  def fetch_and_parse_feed(url)
    feed = Feedjira::Feed.fetch_and_parse(url)
    [feed, nil]
  rescue StandardError => e
    [nil, e.message]
  end

  def feed_entries(feed)
    feed.entries.
      select { |e| process_entry?(e) }.
      sort_by { |e| e.published }.
      reverse
  end

  def process_entry?(entry)
    !entry.published.nil? && entry.published >= window_start
  end

  def window_start
    @window_start ||= Time.now - ENTRY_WINDOW
  end

  def entries_count
    feeds.reduce(0) { |count, feed| count + feed.entries.size }
  end

  def pluralize(count, singular, plural = singular + 's')
    [count, count == 1 ? singular : plural].join(' ')
  end
end
