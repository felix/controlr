
default_account = Account.create(
  :name => 'default',
  :active => true
)
# create user
super_user = default_account.users.create(
  :email => 'super@example.com',
  :firstname => 'Super',
  :surname => 'User',
  :password => 'password',
  :password_confirmation => 'password',
  :active => true
)
admin_user = default_account.users.create(
  :email => 'admin@example.com',
  :firstname => 'Admin',
  :surname => 'User',
  :password => 'password',
  :password_confirmation => 'password',
  :active => true
)
user = default_account.users.create(
  :email => 'user@example.com',
  :firstname => 'User',
  :surname => 'User',
  :password => 'password',
  :password_confirmation => 'password',
  :active => true
)

# create roles
super_role = Role.create(:name => 'super', :description => 'Super user')
admin_role = Role.create(:name => 'admin', :description => 'Admin user')
user_role  = Role.create(:name => 'user', :description => 'Normal user')

# create permissions
role_perms = Hash.new
%w{manage}.each do |action|
  role_perms[action] = Permission.create(
    :action => action,
    :subject_class => 'Role',
    :description => "#{action.capitalize} role"
  )
end

user_perms = Hash.new
%w{manage}.each do |action|
  user_perms[action] = Permission.create(
    :action => action,
    :subject_class => 'User',
    :description => "#{action.capitalize} user"
  )
end

email_perms = Hash.new
%w{manage}.each do |action|
  email_perms[action] = Permission.create(
    :action => action,
    :subject_class => 'Email',
    :description => "#{action.capitalize} email"
  )
end
domain_perms = Hash.new
%w{manage}.each do |action|
  domain_perms[action] = Permission.create(
    :action => action,
    :subject_class => 'Domain',
    :description => "#{action.capitalize} domain"
  )
end

# assign permissions
[user_perms, role_perms, email_perms, domain_perms].each do |perms|
  perms.each do |action, perm|
    admin_role.permissions << perm
  end
end
admin_role.save

# assign roles
super_user.roles << super_role
super_user.save
admin_user.roles << admin_role
admin_user.save
user.roles << user_role
user.save
