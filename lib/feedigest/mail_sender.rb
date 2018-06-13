begin
  require 'dotenv/load'
rescue LoadError
end

module Feedigest
  class MailSender
    attr_reader :mail

    def initialize(mail)
      @mail = mail

      setup_delivery_method!
    end

    def deliver
      mail&.deliver
    end

    private

    def setup_delivery_method!
      mail&.delivery_method(
        :smtp,
        address: ENV.fetch('FEEDIGEST_SMTP_ADDRESS'),
        port: ENV.fetch('FEEDIGEST_SMTP_PORT', '587').to_i,
        user_name: ENV.fetch('FEEDIGEST_SMTP_USERNAME'),
        password: ENV.fetch('FEEDIGEST_SMTP_PASSWORD'),
        authentication: ENV.fetch('FEEDIGEST_SMTP_AUTH', 'plain'),
        enable_starttls: ENV.fetch('FEEDIGEST_SMTP_STARTTLS', 'true') == 'true'
      )
    end
  end
end
