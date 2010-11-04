class Server
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  has n, :service_instances
  has n, :services, :through => :service_instances

  has n, :ip_addresses

end
