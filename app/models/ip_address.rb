class IpAddress
  include DataMapper::Resource

  property :id, Serial
  property :address, String, :required => true
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :server, :required => false
  belongs_to :account, :required => false

  validates_uniqueness_of :address, :if => lambda {|ip| !ip.private?}

  def private?
    address =~ /^(10\.|^172\.([12][6-9]|3[01])\.|^192\.168\.)/
  end

end
