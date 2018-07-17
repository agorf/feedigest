require 'yaml'

class Feedigest::Config
  attr_reader :path

  SECOND = 1
  MINUTE = 60 * SECOND
  HOUR = 60 * MINUTE

  def initialize(path)
    @path = path
  end

  def fetch(key)
    options.fetch(key) # Delegate
  end

  def options
    return @options if @options

    @options = default_options.merge(user_options)
    @options[:smtp_starttls] = @options[:smtp_starttls] == 'true'

    @options
  end

  # Translate SMTP options of feedigest for Mail gem
  def mail_gem_smtp_options
    {
      address: options.fetch(:smtp_address),
      port: options.fetch(:smtp_port),
      user_name: options.fetch(:smtp_username),
      password: options.fetch(:smtp_password),
      authentication: options.fetch(:smtp_auth),
      enable_starttls: options.fetch(:smtp_starttls)
    }
  end

  private

  def user_options
    YAML.safe_load(File.read(path)).
      map { |k, v| [k.to_sym, v] }.to_h # Symbolize keys
  end

  def default_options
    {
      entry_window: 24 * HOUR,
      email_sender: "feedigest@#{`hostname`.strip}",
      smtp_port: 587,
      smtp_auth: 'plain',
      smtp_starttls: 'true' # Gets converted to boolean
    }
  end
end
