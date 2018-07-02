require 'feedigest/options'
require 'forwardable'
require 'mail'

class Feedigest::MailSender
  extend Forwardable

  attr_reader :mail_data

  delegate %i[to_s] => :mail

  def initialize(mail_data)
    @mail_data = mail_data
  end

  def deliver
    setup_delivery_method!(mail)
    mail.deliver
  end

  private

  def mail
    return @mail if @mail

    @mail = Mail.new
    @mail.from = mail_data.from
    @mail.to = mail_data.to
    @mail.subject = mail_data.subject
    @mail.html_part = html_part
    @mail.text_part = text_part
    @mail
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
    mail.delivery_method(:smtp, Feedigest.smtp_options)
  end
end
