class InvoiceService
  include ActiveModel::Validations
  include Savable
  
  attr_accessor :options, :client, :items, :total, :tax

  validates :client, :items, :presence => true

  def self.generate_invoice(options={})
    invoice = self.new(options)
    invoice.build_invoice if !invoice.items.blank?
    invoice
  end

  def initialize(options={})
    @options    = options    
    @client     = @options[:client_id]
    @items      = @options[:items]
    @total      = 0.00
    @tax        = 0.00
  end

  def build_invoice
    calculate_total    
    calculate_tax
    @options[:total] = @tax + @total
    @options[:amount]= @total
    @options[:tax]   = @tax
    @options[:customer_key] = Client.find(@options[:client_id]).customer_key
  end

  def calculate_total
    @total = @items.map{ |k,v| v[:amount].to_f }.sum if @items
  end

  def calculate_tax
    @tax = (@total * 0.0725)
  end

  def save
    if valid? 
      invoice = save_invoice(@options)
      save_invoice_items(invoice,@options)
    end
  end
end