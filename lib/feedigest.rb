module Feedigest; end

require 'feedigest/config'

module Feedigest
  def self.config
    @config ||= Feedigest::Config.new(config_path)
  end

  def self.config_path
    File.expand_path('~/.feedigest/config.yaml')
  end
end

require 'feedigest/option_parser'
require 'feedigest/feed_fetcher'
require 'feedigest/mail_composer'
require 'feedigest/mail_sender'
