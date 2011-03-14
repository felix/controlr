class Role
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :description, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :users, :through => Resource, :constraint => :skip
  has n, :permissions, :through => Resource, :constraint => :skip

  # for assignment of permissions
  def permission_ids=(ids)
    self.permissions.clear
    ids.delete_if{|i| i.empty?}.each do |id|
      self.permissions << Permission.get(id)
    end
  end
end
