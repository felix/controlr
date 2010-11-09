class Account
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :client
  has n, :users, :constraint => :protect

end
