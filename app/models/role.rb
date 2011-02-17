class Role
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :description, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :assignments
  has n, :users, :through => :assignments

end
