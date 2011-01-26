class Domain
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :account
  has n, :domain_records

end
