require 'digest/md5'

class Mailbox
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :email, String, :required => true
  property :active, Boolean
  property :maildir, String
  property :password, String, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :domain, :required => true

  #validates_format_of :email, :as => :email_address

  before :save do |mb|
    self.email = email.slice(/[^@]+/) << '@' << @domain.name
    a = @domain.aliases.first_or_create({:source => self.email},
                                        {:active => self.active} )
    a.destination = a.destination_array << self.email
    a.save
  end

end
