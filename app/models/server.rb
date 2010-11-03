class Server
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime


end
