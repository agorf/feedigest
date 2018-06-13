begin
  require 'dotenv/load'
rescue LoadError
end

require 'mail'
require 'reverse_markdown'

module Feedigest
  class MailComposer
    EMAIL_SENDER = ENV.fetch(
      'FEEDIGEST_EMAIL_SENDER',
      "feedigest@#{`hostname`.strip}"
    )
    EMAIL_RECIPIENT = ENV.fetch('FEEDIGEST_EMAIL_RECIPIENT')

    attr_reader :feeds

    def initialize(feeds)
      @feeds = feeds
    end

    def mail
      return @mail if @mail

      mail = Mail.new
      mail.from = EMAIL_SENDER
      mail.to = EMAIL_RECIPIENT
      mail.subject = subject
      mail.text_part = text_part
      mail.html_part = html_part

      @mail = mail
    end

    private

    def subject
      sprintf(
        'Digest for %s in %s',
        pluralize(entries_count, 'entry', 'entries'),
        pluralize(feeds_without_error.size, 'feed')
      )
    end

    def text_part
      Mail::Part.new.tap do |p|
        p.content_type 'text/plain; charset=utf-8'
        p.body body_text
      end
    end

    def html_part
      Mail::Part.new.tap do |p|
        p.content_type 'text/html; charset=utf-8'
        p.body body_html
      end
    end

    def body_html
      @body_html ||=
        Nokogiri::HTML::Builder.new(encoding: 'utf-8') { |builder|
          builder.div do
            feeds.each do |feed|
              feed_html(builder, feed)
            end
          end
        }.to_html
    end

    def body_text
      ReverseMarkdown.convert(body_html)
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

    def feeds_without_error
      feeds.select { |feed| feed[:error].nil? }
    end

    def entries_count
      feeds.reduce(0) { |count, feed| count + feed.entries.size }
    end

    def pluralize(count, singular, plural = singular + 's')
      [count, count == 1 ? singular : plural].join(' ')
    end
  end
end
