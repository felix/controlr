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
    :with => /^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$/,
    :if => lambda {|r| %w{NS MX CNAME}.include? r.type}

  validates_format_of :value,
    :with => /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/,
    :if => lambda {|r| r.type == 'A'}

  validates_format_of :value,
    :with => /^.*\.in-addr.arpa\.*$/,
    :if => lambda {|r| r.type == 'PTR'}

  # unique CNAME, A, PTR records
  validates_uniqueness_of :host,
    :scope => [:domain_id, :active, :type],
    :if => lambda {|r| %w{CNAME A PTR}.include? r.type}

  before :save do
    if !self.host.end_with? self.domain.name
      self.host = "#{self.host.chomp('.')}.#{self.domain.name}"
    end
  end

  def host=(str)
    super(str.downcase) unless str.nil?
  end

  def value=(str)
    super(str.downcase) unless str.nil?
  end

  def ttl=(new_ttl)
    return if new_ttl.blank?
    if new_ttl.to_i < CONFIG['dns_min_ttl']
      new_ttl = CONFIG['dns_min_ttl']
    end
    super(new_ttl)
  end

  def self.active
    all(:active => true)
  end

  def self.inactive
    all(:active => false)
  end

end
