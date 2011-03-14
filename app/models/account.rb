class Account
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :client, :required => true
#  has n, :users, :constraint => :protect
#  has n, :ip_addresses

end
