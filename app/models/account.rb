class Account
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :active, Boolean, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :domains, :order => [:name.asc]
  has n, :users

end
