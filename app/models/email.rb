class Email
  include DataMapper::Resource

  property :id, Serial
  property :address, String
  property :destination, Text
  property :active, Boolean
  property :created_at, DateTime
  property :modified_at, DateTime
  property :deleted_at, ParanoidDateTime


end
