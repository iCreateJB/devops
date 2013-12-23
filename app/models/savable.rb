module Savable
  def save_client(options)
    begin 
      stripe_client = Stripe::Customer.create( email: options[:email], description: options[:client_name], 
                                               metadata: { first_name: options[:first_name], last_name: options[:last_name], phone: options[:phone]})
      client       = Client.create(client_name: options[:client_name], enabled: true, user_id: options[:user_id], customer_key: stripe_client.id)      
      return client
    rescue Stripe::StripeError => e
      Rails.logger.error "[ERROR] #{Time.now} : #{e}"
    end
  end

  def save_project(client,options)
    Project.create(:client_id    => client.id, 
                   :project_name => options[:project_name],
                   :due_date     => options[:due_date])
  end

  def save_contact(client,options)
    Contact.create(:client_id    => client.id, 
                   :first_name   => options[:first_name],
                   :last_name    => options[:last_name],
                   :email        => options[:email],
                   :phone        => options[:phone])
  end

  def save_invoice(options)
    @invoice = Invoice.new(:client_id   => options[:client_id], 
                              :amount      => options[:amount], 
                              :tax         => options[:tax], 
                              :total       => options[:total])
    @invoice.save
    return @invoice
  end

  def save_invoice_items(invoice,options)
    options[:items].each do |k,v|
      item = Stripe::InvoiceItem.create(:customer  => options[:customer_key],
                                        :amount    => (v[:amount].to_f*100).to_i,
                                        :currency  => 'usd',
                                        :description=>v[:description])

      InvoiceItems.create(:invoice_id       => invoice.invoice_id, 
                          :amount           => v[:amount],
                          :title            => v[:title],
                          :description      => v[:description],
                          :item_key         => item.id)
    end
  end

  def update_stripe_customer
    begin
      stripe_client = Stripe::Customer.retrieve(options[:customer_key])
      stripe_client.email       = options[:email]
      stripe_client.description = options[:client_name]
      stripe_client.metadata    = { first_name: options[:first_name], last_name: options[:last_name], phone: options[:phone] }
      stripe_client.save
    rescue Stripe::StripeError => e
      Rails.logger.error "[ERROR] #{Time.now} : #{e}"
    end
  end

  def update_client(options)
    client = Client.find(options[:client_id])
    client.update_attributes(client_name: options[:client_name])      
  end

  def update_contact(options)
    client = Client.find(options[:client_id])
    if !client.contact.blank?
      client.contact.update_attributes(first_name: options[:first_name], last_name: options[:last_name], email: options[:email], phone: options[:phone].gsub(/\D/,''))
    end
  end
end