class Assignment
  include DataMapper::Resource
  property :id, Serial

  belongs_to :user, :key => true
  belongs_to :role, :key => true
end
