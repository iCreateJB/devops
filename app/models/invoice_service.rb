class InvoiceService
  include ActiveModel::Validations
  include Savable
  
  attr_accessor :options, :client, :project, :items, :total, :tax

  validates :client, :project, :items, :presence => true

  def self.generate_invoice(options={})
    invoice = self.new(options)
    invoice.build_invoice if @items
    invoice
  end

  def initialize(options={})
    @options    = options    
    @client     = options[:client_id]
    @project    = options[:project_id]
    @items      = options[:items]
    @total      = 0.00
    @tax        = 0.00
  end

  def build_invoice
    calculate_total    
    calculate_tax
    @options[:total] = @tax + @total
    @options[:amount]= @total
    @options[:tax]   = @tax
  end

  def calculate_total
    @total = @items.map{ |i| i[:amount].to_f }.sum if @items
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