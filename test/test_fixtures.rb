
# every fixture should be valid!

User.fixture {{
  :email => DataMapper::Sweatshop.unique {/\w+@\w+\.com/.gen},
  :firstname => /\w+/.gen,
  :surname => /\w+/.gen,
  :active => true,
  :created_at => Time.now,
  :account => Account.make
}}

Client.fixture {{
  :name => DataMapper::Sweatshop.unique {/\w+/.gen},
  :created_at => Time.now
}}
Client.fixture(:accounts) {{
  :name => DataMapper::Sweatshop.unique {/\w+/.gen},
  :created_at => Time.now,
  :accounts => 2.of {Account.make}
}}

Account.fixture {{
  :name => DataMapper::Sweatshop.unique {/\w+/.gen},
  :created_at => Time.now,
  :client => Client.make
}}
Account.fixture(:users) {{
  :name => DataMapper::Sweatshop.unique {/\w+/.gen},
  :created_at => Time.now,
  :client => Client.make,
  :users => 2.of {User.make}
}}

Server.fixture {{
  :name => DataMapper::Sweatshop.unique {/\w+/.gen},
  :active     => true,
  :created_at => Time.now
}}

IpAddress.fixture {{
  :address => DataMapper::Sweatshop.unique(:ip) {/100\.\d\.\d\.\d/.gen}.to_s,
  :active => true,
  :created_at => Time.now,
  :account => Account.make
}}
IpAddress.fixture(:private) {{
  :address => DataMapper::Sweatshop.unique(:ip) {/192\.168\.\d\.\d/.gen}.to_s,
  :active => true,
  :created_at => Time.now,
  :account => Account.make
}}
IpAddress.fixture(:server) {{
  :address => DataMapper::Sweatshop.unique(:ip) {/100\.\d\.\d\.\d/.gen}.to_s,
  :active => true,
  :created_at => Time.now,
  :account => Account.make,
  :server => Server.make
}}

Service.fixture {{
  :name => 'Foo',
  :type => nil,
  :active => false,
  :start_cmd => '/etc/init.d/foo start',
  :stop_cmd => '/etc/init.d/foo reload',
  :created_at => Time.now,
  :server => Server.make
}}
Service.fixture(:postfix) {{
  :name => 'Postfix',
  :type => 'Postfix',
  :active => false,
  :start_cmd => '/etc/init.d/postfix start',
  :stop_cmd => '/etc/init.d/postfix reload',
  :created_at => Time.now,
  :server => Server.make
}}


