module Savable
  def save_client(options)
    begin 
      stripe_client = Stripe::Customer.create( email: options[:email], description: options[:client_name], 
                                               metadata: { first_name: options[:first_name], last_name: options[:last_name], phone: options[:phone]})
      client       = Client.create(client_name: options[:client_name], enabled: true, 
                                    user_id: options[:user_id], customer_key: stripe_client.id)      
      return client
    rescue
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
    @invoice = Invoice.create(:project_id   => options[:project_id], 
                              :amount       => options[:amount], 
                              :tax          => options[:tax], 
                              :total        => options[:total])
  end

  def save_invoice_items(invoice,options)
    options[:items].each do |item|
      InvoiceItems.create(:invoice_id       => invoice.invoice_id, 
                          :amount           => item[:amount],
                          :title            => item[:title],
                          :description      => item[:description])
    end
  end
end