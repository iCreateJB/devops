class InvoiceService
  include Savable
  
  attr_accessor :client, :project_id, :items, :total, :tax, :options, :errors

  def self.generate_invoice(options={})
    invoice = self.new(options)
    invoice.build_invoice if @items
    invoice
  end

  def initialize(options={})
    @client     = options[:client_id]
    @project_id = options[:project_id]
    @items      = options[:items]
    @options    = options
    @total      = 0.00
    @tax        = 0.00
    @errors     = {}
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

  def valid? 
    validate_items
    validate_client
    validate_project
    @errors.empty?
  end

  def save
    if valid? 
      invoice = save_invoice(@options)
      save_invoice_items(invoice,@options)
    end
  end

private 

  def validate_client
    @errors[:client] = "Client can't be blank" if @client.blank?
  end

  def validate_project
    @errors[:project] = "Project ID can't be blank" if @project_id.blank?
  end

  def validate_items
    @errors[:items] = "Item is missing." if @items.blank?
  end
end