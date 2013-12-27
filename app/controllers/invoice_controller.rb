class InvoiceController < ApplicationController
  before_filter :authenticate_user!, :except => [:show,:send_invoice]

  def new
    @invoice = Invoice.new(client_id: session[:client_id])
    @invoice.invoice_items.build
  end

  def create
    params[:invoice].merge!(client_id: session[:client_id])
    params[:invoice][:items] = params[:invoice].delete(:invoice_items_attributes)
    @invoice = InvoiceService.generate_invoice(params[:invoice])
    if @invoice.valid?
      @invoice.save
      redirect_to :dashboard
    else
      flash[:error] = @invoice.errors.full_messages
      redirect_to :dashboard
    end
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end

  def show 
    @invoice = Invoice.find_by_invoice_key(params[:invoice_key])
  end

  def list
    @invoices = Invoice.where(client_id: params[:client_id])
    session[:client_id] = params[:client_id]
    respond_to do |format|
      format.js   { render :list }
    end
  end

  def update
    params[:invoice][:items] = params[:invoice].delete(:invoice_items_attributes)
    invoice = Invoice.find(params[:id])
    begin 
      params[:invoice][:items].each do |k,v|
        if v.has_key?(:id)
          item   = InvoiceItems.find(v[:id])
          x_item = Stripe::InvoiceItem.retrieve(item.item_key)
          x_item.amount = (v[:amount].to_f*100).to_i
          x_item.description = v[:description]
          x_item.save
          item.update_attributes(v.except(:_destroy, :id))
        else
          item = Stripe::InvoiceItem.create(:customer  => invoice.client.customer_key, :amount    => (v[:amount].to_f*100).to_i, 
            :currency  => 'usd', :description=>v[:description])
          InvoiceItems.create(:invoice_id => params[:id], :amount => v[:amount],:title => v[:title], :description => v[:description], :item_key => item.id)      
        end
      end
      invoice.recalculate      
    rescue
      flash[:error] = 'There was an error updating your request.'
    end
    redirect_to :dashboard
  end

  def destroy 
    begin 
      @invoicesItems = InvoiceItems.where(invoice_id: params[:id])  
      @invoicesItems.each do |i|
        item = Stripe::InvoiceItem.retrieve(i.item_key)
        item.delete
        i.delete
      end
      redirect_to :dashboard
    rescue
      flash[:error] = 'There was an error processing your request.'
    end
  end

  def send_invoice
    begin
      @invoice    = Invoice.find_by_invoice_key(params[:invoice_key])
      @contact    = Contact.find(params[:contact_id])
      invoice_key = Stripe::Invoice.create(customer: @contact.client.customer_key)
      # Send Invoice out.      
    rescue

    end
    redirect_to :dashboard
  end

end
