class DefaultNameRecord
  include DataMapper::Resource

  TYPES = %w{A MX CNAME NS PTR TXT}

  property :id, Serial
  property :host, String
  property :description, String
  property :active, Boolean
  property :type, String, :required => true, :length => 5, :default => 'A'
  property :value, String, :required => true
  property :distance, Integer, :default => 0
  property :ttl, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :account, :required => true

  validates_presence_of :distance, :if => lambda {|r| r.type == 'MX'}
  validates_format_of :value,
    :with => /(([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6})/,
    :if => lambda {|r| %w{MX CNAME NS}.include? r.type}
  validates_format_of :value,
    :with => /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/,
    :if => lambda {|r| r.type == 'A'}

  def ttl=(new_ttl)
    return if new_ttl.blank?
    if new_ttl.to_i < CONFIG['dns_min_ttl']
      new_ttl = CONFIG['dns_min_ttl']
    end
    super(new_ttl)
  end

end
