# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

admin = User.create(:email => 'root@example.com',
                    :firstname => 'Admin',
                    :surname => 'Istrator',
                    :password => 'password',
                    :password_confirmation => 'password',
                    :active => true,
                    :created_at => Time.now)

user_perm = Permission.create(
  :action => 'manage',
  :subject_class => 'User'
)

super_role = Role.create(
  :name => 'super',
  :description => 'Super user'
)
admin_role = Role.create(
  :name => 'admin',
  :description => 'Admin user'
)
super_role.permissions << user_perm
admin_role.permissions << user_perm
super_role.save
admin_role.save

admin.roles << super_role
admin.save

