class Ability
  include CanCan::Ability

  def initialize(user)

    # predefined
    # :index, :show, :new, :edit
    #alias_action :index, :show, :to => :read
    #alias_action :new, :to => :create
    #alias_action :edit, :to => :update
    alias_action :update, :destroy, :to => :modify

    user ||= User.new

    # super user can do everything
    if user.role? :super
      can :manage, :all
    else
      # edit update self
      can :modify, user, :active => true, :id => user.id

      user.roles.permissions.each do |permission|
        can permission.action.to_sym, permission.subject_class.constantize do |subject|
          permission.subject_id.nil? || permission.subject_id == subject.id
        end
      end
=begin
      can do |action, subject_class, subject|
        user.roles.permissions.all(:action => action).any? do |permission|
          permission.subject_class == subject_class.to_s &&
            (subject.nil? || permission.subject_id.nil? || permission.subject_id == subject.id)
        end
      end
=end
    end

  end
end
