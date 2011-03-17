class User
  include DataMapper::Resource
  extend ActiveModel::Translation

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable


  property :id, Serial
  property :email, String, :required => true, :unique => true, :format => :email_address
  property :firstname, String
  property :surname, String
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :account
  has n, :roles, :through => Resource, :constraint => :skip

  # for assignment of roles
  def role_ids=(ids)
    self.roles.clear
    ids.delete_if{|i| i.empty?}.each do |id|
      self.roles << Role.get(id)
    end
  end

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def role?(role)
    return !!self.roles.first(:name => role.to_s)
  end

end
