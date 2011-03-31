class Domain
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :name, String, :unique => true, :required => true
  property :active, Boolean
  property :email_active, Boolean
  property :email_alias, String
#  property :backup_mx, Boolean, :default => 0
  property :email_default_quota, String, :default => '200M'
  property :ftp_active, Boolean
  property :ftp_quota, Integer, :default => 0
  property :passhash, String, :length => 32
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :mailboxes, :constraint => :destroy
  has n, :aliases, :constraint => :destroy
  belongs_to :account
  has n, :assignments
  has n, :users, :through => :assignments

  validates_format_of :name, :with => %r{^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$}
  validates_format_of :email_default_quota, :with => %r{^[0-9]+[bkMG]?$}

  def passhash=(plain)
    super(Digest::MD5.hexdigest(plain)) unless plain.nil?
  end

end
