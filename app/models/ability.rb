class Ability
  include CanCan::Ability

  @@permissions = nil

  def initialize(user)
    self.clear_aliased_actions

    alias_action :update, :destroy, :to => :modify

    user ||= User.new

    # super user can do everything
    if user.role? :super
      can :manage, :all
    else
      # edit update self
      can :modify, User do |resource|
        resource == user
      end

      user.roles.each do |role|
        if role.permissions
          role.permissions.each do |perm_name|
            can(Ability.permissions[perm_name]['action'].to_sym, Ability.permissions[perm_name]['subject_class'].constantize) do |subject|
              Ability.permissions[perm_name]['subject_id'].nil? || Ability.permissions[perm_name]['subject_id'] == subject.id
            end
          end
        end
      end
    end
  end

  def self.permissions
    @@permissions ||= Ability.load_permissions
  end

  def self.load_permissions(file='permissions.yml')
    YAML.load_file("#{::Rails.root.to_s}/config/#{file}")
  end
end
