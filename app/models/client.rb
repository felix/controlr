class Client
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  #has n, :accounts

end
