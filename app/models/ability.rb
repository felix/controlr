class Ability
  include CanCan::Ability

  def initialize(user)
    self.clear_aliased_actions

    alias_action :index, :show, :to => :read
    alias_action :new,          :to => :create
    alias_action :edit,         :to => :update
    alias_action :destroy,      :to => :delete

    user ||= User.new

    # super user can do everything
    if user.role? :super
      can :manage, :all

    elsif user.role? :administrator
      # can manage all domains in account
      can :manage, [Domain, User] do |resource|
        resource.account == user.account
      end

      # can manage all email in account
      can :manage, [Email] do |resource|
        resource.domain.account == user.account
      end

    else
      # edit update self
      can :read, User do |resource|
        resource == user
      end
      can :update, User do |resource|
        resource == user
      end

      can :read, Domain do |resource|
        user.domains.include?(resource)
      end

      can :manage, [Email] do |resource|
        user.domains.collect{|d| d.id}.include? resource.domain.id
      end

    end
  end

end
