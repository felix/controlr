class Permission
  include DataMapper::Resource

  property :id, Serial
  property :action, String, :required => true
  property :description, String, :required => true
  property :subject_class, String, :required => true
  property :subject_id, Integer

  has n, :roles, :through => Resource, :constraint => :skip

end
