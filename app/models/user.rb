class User
  include DataMapper::Resource
  extend ActiveModel::Translation

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable,:recoverable,
    :rememberable, :trackable, :validatable

  property :id, Serial
  property :email, String, :required => true, :unique => true, :format => :email_address
  property :firstname, String
  property :surname, String
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :account
  has n, :assignments, :constraint => :destroy
  has n, :roles, :through => :assignments

  # for assignment of roles
  def role_ids=(role_ids)
    self.assignments.destroy unless self.new?
    self.reload
    role_ids.reject{|i| i.empty?}.each do |id|
      role = Role.get(id)
      self.roles << role
    end
  end

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def role?(role)
    return !!self.roles.first(:name => role.to_s)
  end

end
