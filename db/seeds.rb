
# create user
super_user = User.create(:email => 'super@example.com',
                         :firstname => 'Super',
                         :surname => 'User',
                         :password => 'password',
                         :password_confirmation => 'password',
                         :active => true,
                         :created_at => Time.now)
admin_user = User.create(:email => 'admin@example.com',
                         :firstname => 'Admin',
                         :surname => 'User',
                         :password => 'password',
                         :password_confirmation => 'password',
                         :active => true,
                         :created_at => Time.now)
user = User.create(:email => 'user@example.com',
                   :firstname => 'User',
                   :surname => 'User',
                   :password => 'password',
                   :password_confirmation => 'password',
                   :active => true,
                   :created_at => Time.now)

# create roles
super_role = Role.create(:name => 'super', :description => 'Super user')
admin_role = Role.create(:name => 'admin', :description => 'Admin user')
user_role  = Role.create(:name => 'user', :description => 'Normal user')

# create permissions
user_perms = Hash.new
%w{read create update modify}.each do |action|
  user_perms[action] = Permission.create(
    :action => action,
    :subject_class => 'User',
    :description => "#{action.capitalize} user"
  )
end

# assign permissions
user_perms.each do |action, perm|
  admin_role.permissions << perm
end
admin_role.save

user_role.permissions << user_perms['read']
user_role.save

# assign roles
super_user.roles << super_role
super_user.save
admin_user.roles << admin_role
admin_user.save
user.roles << user_role
user.save
