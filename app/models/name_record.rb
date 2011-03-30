class NameRecord
  include DataMapper::Resource

  TYPES = %w{A MX CNAME NS PTR TXT SOA AXFR}

  property :id, Serial
  property :host, String, :required => true
  property :description, String
  property :active, Boolean
  property :type, String, :required => true, :length => 4, :default => 'A'
  property :value, String
  property :ttl, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :domain, :required => true

end
