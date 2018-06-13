begin
  require 'dotenv/load'
rescue LoadError
end

require 'feedjira'

module Feedigest
  class FeedFetcher
    ENTRY_WINDOW = ENV.fetch('FEEDIGEST_ENTRY_WINDOW', 60 * 60 * 24) # Seconds

    Feed = Struct.new(:url, :title, :entries, :error)

    attr_reader :feed_urls

    def initialize(feed_urls)
      @feed_urls = feed_urls
    end

    def feeds
      @feeds ||= all_feeds.select { |f| process_feed?(f) }
    end

    private

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
  end
end
