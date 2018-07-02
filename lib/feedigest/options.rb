module Feedigest
  def self.options
    @options ||= {
      entry_window: ENV.fetch('FEEDIGEST_ENTRY_WINDOW', 60 * 60 * 24), # Seconds
      email_sender: ENV.fetch(
        'FEEDIGEST_EMAIL_SENDER',
        "feedigest@#{`hostname`.strip}"
      ),
      email_recipient: ENV.fetch('FEEDIGEST_EMAIL_RECIPIENT')
    }
  end

  def self.smtp_options
    @smtp_options ||= {
      address: ENV.fetch('FEEDIGEST_SMTP_ADDRESS'),
      port: ENV.fetch('FEEDIGEST_SMTP_PORT', '587').to_i,
      user_name: ENV.fetch('FEEDIGEST_SMTP_USERNAME'),
      password: ENV.fetch('FEEDIGEST_SMTP_PASSWORD'),
      authentication: ENV.fetch('FEEDIGEST_SMTP_AUTH', 'plain'),
      enable_starttls: ENV.fetch('FEEDIGEST_SMTP_STARTTLS', 'true') == 'true'
    }
  end
end
