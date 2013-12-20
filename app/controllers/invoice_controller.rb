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
    @invoice = Invoice.find_by_invoice_key(params[:invoice_key])
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

  def send_invoice
    @invoice  = Invoice.find_by_invoice_key(params[:invoice_key])
    @contact  = Contact.find(params[:contact_id])
    # Send Invoice out.
    redirect_to :dashboard
  end
end
