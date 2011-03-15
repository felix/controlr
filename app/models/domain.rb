class Domain
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :name, String, :required => true
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  has n, :mailboxes, :constraint => :destroy
  has n, :aliases, :constraint => :destroy
  #belongs_to :account
  #has n, :domain_records

  after :create do
    # TODO get default from settings
    hostmaster = self.aliases.create(
      :source => 'hostmaster',
      :destination => 'hostmaster@seconddrawer.com.au',
      :active => true
    )
    postmaster = self.aliases.create(
      :source => 'postmaster',
      :destination => 'postmaster@seconddrawer.com.au',
      :active => true
    )
  end

end
