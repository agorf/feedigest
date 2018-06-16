require 'feedigest/version'
require 'nokogiri'
require 'reverse_markdown'

module Feedigest
  class MailComposer
    EMAIL_SENDER = ENV.fetch(
      'FEEDIGEST_EMAIL_SENDER',
      "feedigest@#{`hostname`.strip}"
    )
    EMAIL_RECIPIENT = ENV.fetch('FEEDIGEST_EMAIL_RECIPIENT')

    Mail = Struct.new(:from, :to, :subject, :html_body, :text_body)

    attr_reader :feeds

    def initialize(feeds)
      @feeds = feeds
    end

    def mail
      @mail ||= Mail.new(
        EMAIL_SENDER,
        EMAIL_RECIPIENT,
        subject,
        html_body,
        text_body
      )
    end

    private

    def subject
      sprintf(
        'Digest for %s in %s',
        pluralize(entries_count, 'entry', 'entries'),
        pluralize(feeds_without_error.size, 'feed')
      )
    end

    def html_body
      @html_body ||=
        Nokogiri::HTML::Builder.new(encoding: 'utf-8') { |builder|
          builder.div do
            feeds.each do |feed|
              feed_html(builder, feed)
            end

            signature_html(builder)
          end
        }.to_html
    end

    def text_body
      ReverseMarkdown.convert(html_body)
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

    def signature_html(builder)
      builder.p do
        builder.text '--'
        builder.br
        builder.text 'Sent by '
        builder.a(
          "feedigest #{Feedigest::VERSION}",
          href: 'https://github.com/agorf/feedigest'
        )
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
