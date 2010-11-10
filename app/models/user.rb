class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, :required => true, :unique => true
  property :firstname, String, :required => true
  property :surname, String
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :account

end
