class Service
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :active, Boolean
  property :type, Discriminator
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  has n, :service_instances
  has n, :servers, :through => :service_instances
end
