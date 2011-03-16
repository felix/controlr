
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

permissions = YAML.load_file("#{::Rails.root.to_s}/config/permissions.yml")

# assign permissions
admin_role.permissions = permissions.collect{|n,p| n}
admin_role.save

# assign roles
super_user.roles << super_role
super_user.save
admin_user.roles << admin_role
admin_user.save
user.roles << user_role
user.save
