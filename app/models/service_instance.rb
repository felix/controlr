class ServiceInstance
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime

  belongs_to :service, :key => true
  belongs_to :server, :key => true

end
