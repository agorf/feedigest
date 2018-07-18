module Feedigest; end

require 'feedigest/config'

module Feedigest
  class << self
    attr_accessor :config_path
  end

  def self.config
    @config ||= Feedigest::Config.new(config_path)
  end
end

require 'feedigest/option_parser'
require 'feedigest/feed_fetcher'
require 'feedigest/mail_composer'
require 'feedigest/mail_sender'
