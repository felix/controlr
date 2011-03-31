require 'digest/md5'

class Mailbox
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :email, String, :unique => true, :required => true
  property :active, Boolean
  property :passhash, String, :length => 32, :required => true
  property :quota, Integer    # used by dovecot
  property :bytes, Integer    # used by dovecot
  property :messages, Integer # used by dovecot
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :domain, :required => true

  #validates_format_of :email, :as => :email_address

  before :save do |mb|
    self.email = email.slice(/[^@]+/) << '@' << @domain.name
    a = @domain.aliases.first_or_create({:source => self.email},
                                        {:active => self.active})
    a.destination = a.destination_array << self.email
    a.save

    # set default quota if nec
    if self.quota.blank? || (self.quota == 0) || (self.quota > @domain.email_max_quota)
      self.quota = @domain.email_max_quota
    end
  end

  def passhash=(plain)
    super(Digest::MD5.hexdigest(plain)) unless plain.blank?
  end

end
