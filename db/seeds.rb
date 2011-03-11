
# create user
admin = User.create(:email => 'root@example.com',
                    :firstname => 'Admin',
                    :surname => 'Istrator',
                    :password => 'password',
                    :password_confirmation => 'password',
                    :active => true,
                    :created_at => Time.now)

# create permissions
user_perm = Permission.create(:action => 'manage', :subject_class => 'User')

# create roles
super_role = Role.create(:name => 'super', :description => 'Super user')
admin_role = Role.create(:name => 'admin', :description => 'Admin user')

# assign permissions
super_role.permissions << user_perm
admin_role.permissions << user_perm
super_role.save
admin_role.save

# assign roles
admin.roles << super_role
admin.save
