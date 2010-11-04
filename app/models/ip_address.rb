class IpAddress
  include DataMapper::Resource

  property :id, Serial
  property :address, String, :required => true, :unique => true
  property :active, Boolean
  property :private, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :server, :required => false

end
