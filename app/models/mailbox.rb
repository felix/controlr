class Mailbox
  include DataMapper::Resource

  property :id, Serial
  property :email, String, :required => true
  property :maildir, String
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :domain

end
