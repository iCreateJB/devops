class InvoiceController < ApplicationController
  before_filter :authenticate_user!, :except => [:show,:send_invoice]

  def new
  end

  def create
    @invoice = InvoiceService.generate_invoice(params)
    if @invoice.valid?
      @invoice.save
      redirect_to :dashboard
    else
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
