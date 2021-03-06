class User
  include DataMapper::Resource
  extend ActiveModel::Translation

  ROLES = %w{super administrator user}

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable,:recoverable,
    :rememberable, :trackable, :validatable

  property :id, Serial
  property :email, String, :required => true, :unique => true, :format => :email_address
  property :firstname, String
  property :surname, String
  property :active, Boolean
  property :role, String, :required => true, :default => 'user'
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :account
  #has n, :assignments
  has n, :domains, :through => Resource

  # check for active account also
  # called by devise
  def active_for_authentication?
    self.account.active && self.active
  end

  def fullname
    "#{firstname} #{surname}"
  end

  def role?(r)
    role == r.to_s
  end

  def domain_ids=(ids)
    self.domains.clear
    ids.reject{|i| i.empty?}.each do |id|
      self.domains << Domain.get(id)
    end
  end

  def self.active
    all(:active => true)
  end

  def self.inactive
    all(:active => false)
  end

end
