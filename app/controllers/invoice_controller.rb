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
