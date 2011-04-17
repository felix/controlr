class NameRecord
  include DataMapper::Resource

  TYPES = %w{A MX CNAME NS PTR TXT}

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
  validates_format_of :value,
    :with => /\A([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\Z/,
    :if => lambda {|r| %w{NS MX CNAME}.include? r.type}
  validates_format_of :value,
    :with => /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/,
    :if => lambda {|r| r.type == 'A'}

  before :save do
    if !self.host.end_with? self.domain.name
      self.host = "#{self.host.chomp('.')}.#{self.domain.name}"
    end
  end

  def ttl=(new_ttl)
    return if new_ttl.blank?
    if new_ttl.to_i < CONFIG['dns_min_ttl']
      new_ttl = CONFIG['dns_min_ttl']
    end
    super(new_ttl)
  end

end
