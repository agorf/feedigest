require 'forwardable'
require 'mail'

module Feedigest
  class MailSender
    extend Forwardable

    EMAIL_SENDER = ENV.fetch(
      'FEEDIGEST_EMAIL_SENDER',
      "feedigest@#{`hostname`.strip}"
    )
    EMAIL_RECIPIENT = ENV.fetch('FEEDIGEST_EMAIL_RECIPIENT')

    attr_reader :mail_data

    delegate %i[deliver to_s] => :mail

    def initialize(mail_data)
      @mail_data = mail_data
    end

    private

    def mail
      return @mail if @mail

      m = Mail.new
      m.from = mail_data.from
      m.to = mail_data.to
      m.subject = mail_data.subject
      m.html_part = html_part
      m.text_part = text_part
      setup_delivery_method!(m)

      @mail = m
    end

    def html_part
      Mail::Part.new.tap do |p|
        p.content_type 'text/html; charset=utf-8'
        p.body mail_data.html_body
      end
    end

    def text_part
      Mail::Part.new.tap do |p|
        p.content_type 'text/plain; charset=utf-8'
        p.body mail_data.text_body
      end
    end

    def setup_delivery_method!(mail)
      mail.delivery_method(
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
