class Domain
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :name, String, :unique => true, :required => true
  property :active, Boolean
  property :email_active, Boolean
  property :email_quota, Integer, :default => 0
  property :ftp_active, Boolean
  property :ftp_quota, Integer, :default => 0
  property :passhash, String, :length => 32
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  has n, :mailboxes, :constraint => :destroy
  has n, :aliases, :constraint => :destroy
  belongs_to :account
  #has n, :domain_records

  validates_format_of :name, :with => %r{^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$}

  def passhash=(plain)
    super(Digest::MD5.hexdigest(plain)) unless plain.nil?
  end

end
