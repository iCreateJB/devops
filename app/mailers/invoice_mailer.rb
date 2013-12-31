class InvoiceMailer < ActionMailer::Base
  default from: "\"Jonathan Ballard\" <donotreply@jonathanballard.com>"

  def send_invoice(options={})
    @invoice = options[:invoice]
    @contact = options[:contact]
    @user    = options[:issuer]
    mail to: @contact.email, subject: "#{@user.email} has sent you an invoice."
  end
end
