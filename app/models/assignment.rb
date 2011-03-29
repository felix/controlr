class Assignment
  include DataMapper::Resource
  property :id, Serial

  belongs_to :user, :key => true
  belongs_to :domain, :key => true
end
