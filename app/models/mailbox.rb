class Mailbox
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :email, String, :required => true
  property :active, Boolean
  property :maildir, String
  property :password, String, :length => 32
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :domain, :required => true

  #validates_format_of :email, :as => :email_address

  before :save do |mb|
    self.email = @email.slice(/[^@]+/) << '@' << @domain.name
    a = @domain.aliases.create(
      :source => self.email,
      :destination => self.email,
      :active => self.active
    )
  end

end
