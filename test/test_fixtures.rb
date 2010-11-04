User.fixture {{
  :email => DataMapper::Sweatshop.unique(:email){/\w+@example\.com/.gen},
  :firstname => /\w+/.gen,
  :surname => /\w+/.gen,
  :active => true
}}

Client.fixture {{
  :name => /\w+/.gen,

  :accounts => 2.of {Account.make}
}}

Account.fixture {{
  :name => /\w+/.gen,
  :created_at => Time.now,

  :users => 2.of {User.make}
}}


IpAddress.fixture {{
  :address => DataMapper::Sweatshop.unique(:ip) {/192\.\d\.\d\.\d/.gen}.to_s,
  :active => true,
  :private => false,
  :created_at => Time.now
}}

Server.fixture {{
  :name       => 'Server1',
  :active     => true,
  :created_at => Time.now,

  :ip_addresses => 2.of {IpAddress.make},
  :services   => 3.of {Service.make}
}}

Service.fixture {{
  :name => 'Service',
  :active => false,
  :created_at => Time.now
}}


