class InvoiceMailer < ActionMailer::Base
  default from: "\"Jonathan Ballard\" <donotreply@jonathanballard.com>"

  def send_invoice(options={})
    @invoice = options[:invoice]
    @contact = options[:contact]
    mail to: @contact.email, subject: "#{@contact.email}, your invoice is ready!"
  end
end
