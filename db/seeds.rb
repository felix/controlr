
default_account = Account.create(
  :name => 'default',
  :active => true
)
# create user
super_user = default_account.users.create(
  :email => 'super@example.com',
  :firstname => 'Super',
  :surname => 'User',
  :password => 'testtest',
  :password_confirmation => 'testtest',
  :active => true,
  :role => 'super'
)
admin_user = default_account.users.create(
  :email => 'admin@example.com',
  :firstname => 'Admin',
  :surname => 'User',
  :password => 'testtest',
  :password_confirmation => 'testtest',
  :active => true,
  :role => 'administrator'
)
user = default_account.users.create(
  :email => 'user@example.com',
  :firstname => 'User',
  :surname => 'User',
  :password => 'testtest',
  :password_confirmation => 'testtest',
  :active => true,
  :role => 'user'
)
