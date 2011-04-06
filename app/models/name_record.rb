class NameRecord
  include DataMapper::Resource

  TYPES = %w{A MX CNAME NS PTR TXT SOA AXFR}

  property :id, Serial
  property :host, String, :required => true
  property :description, String
  property :active, Boolean
  property :type, String, :required => true, :length => 5, :default => 'A'
  property :value, String, :required => true
  property :distance, Integer, :default => 0
  property :ttl, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :domain, :required => true

  validates_presence_of :distance, :if => lambda {|r| r.type == 'MX'}
  #validates_with_method :value, :check_value

  before :save do
    if !self.host.end_with? @domain.name
      self.host = "#{self.host.chomp('.')}.#{@domain.name}"
    end

    if self.ttl.blank? || (self.ttl == 0) || (self.ttl < @domain.dns_min_ttl)
      self.ttl = @domain.dns_min_ttl
    end
  end

  def check_value
    # can be an IP or FQDN
    ip = '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'
    fqdn = '(([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6})'
  end

end
