class Role
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :name, String, :required => true
  property :description, Text
  property :permissions, Yaml, :lazy => false
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :assignments, :constraint => :destroy
  has n, :users, :through => :assignments

  def raise_on_save_failure
    true
  end

  def permissions
    super || []
  end

  def permissions=(perms)
    perms ||= []
    perms = [perms].flatten.uniq.compact
    super(perms)
  end

end
