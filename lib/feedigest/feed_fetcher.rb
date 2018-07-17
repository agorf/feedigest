require 'feedigest/config'
require 'feedjira'
require 'open-uri'

class Feedigest::FeedFetcher
  Feed = Struct.new(:url, :title, :entries, :error)

  USER_AGENT = "feedigest/#{Feedigest::VERSION}".freeze

  attr_reader :feed_urls, :filter_cmd

  def initialize(feed_urls, filter_cmd = nil)
    @feed_urls = feed_urls
    @filter_cmd = filter_cmd
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

  def fetch_feed(url)
    feed_fd = OpenURI.open_uri(url, 'User-Agent' => USER_AGENT)

    if filter_cmd
      filter_feed(feed_fd)
    else
      feed_fd.read
    end
  end

  def fetch_and_parse_feed(url)
    [Feedjira::Feed.parse(fetch_feed(url)), nil]
  rescue StandardError => e
    [nil, e.message]
  end

  def feed_entries(feed)
    feed.entries.select { |e| process_entry?(e) }.sort_by(&:published).reverse
  end

  def process_entry?(entry)
    !entry.published.nil? && entry.published >= window_start
  end

  def window_start
    @window_start ||= Time.now - Feedigest.config.fetch(:entry_window) * 3600
  end

  def filter_feed(feed_fd)
    IO.popen(filter_cmd, 'r+') do |io|
      IO.copy_stream(feed_fd, io)
      io.close_write
      io.read
    end
  end
end
