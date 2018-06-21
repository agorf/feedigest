require 'feedigest/options'
require 'forwardable'
require 'mail'

class Feedigest::MailSender
  extend Forwardable

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
    mail.delivery_method(:smtp, Feedigest.options[:smtp])
  end
end
