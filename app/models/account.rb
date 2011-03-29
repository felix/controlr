class Account
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :domains
  has n, :users
  #belongs_to :client, :required => true
#  has n, :ip_addresses

end
