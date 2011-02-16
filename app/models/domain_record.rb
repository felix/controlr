class DomainRecord
  include DataMapper::Resource

  property :id, Serial
  property :host, String, :required => true
  property :type, Enum[:a, :cname, :txt, :ns, :ptr, :mx, :cname]
  property :ttl, Integer
  property :value, String

  belongs_to :domain

end
