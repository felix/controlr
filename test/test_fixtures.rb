User.fixture {{
  :email => DataMapper::Sweatshop.unique(:email){/\w+@example\.com/.gen},
  :firstname => /\w+/.gen,
  :surname => /\w+/.gen,
  :active => true,
  :created_at => Time.now
}}

Client.fixture {{
  :name => /\w+/.gen,
  :created_at => Time.now
}}

Account.fixture {{
  :name => DataMapper::Sweatshop.unique(:name) {/\w+/.gen},
  :created_at => Time.now
}}


IpAddress.fixture {{
  :address => DataMapper::Sweatshop.unique(:ip) {/192\.\d\.\d\.\d/.gen}.to_s,
  :active => true,
  :private => false,
  :created_at => Time.now
}}

Server.fixture {{
  :name => DataMapper::Sweatshop.unique(:name) {/\w+/.gen},
  :active     => true,
  :created_at => Time.now
}}

Postfix.fixture {{
  :name => 'Postfix',
  :active => false,
  :start_cmd => '/etc/init.d/postfix start',
  :stop_cmd => '/etc/init.d/postfix reload',
  :created_at => Time.now
}}


