
# every fixture should be valid!

Account.fixture {{
  :name => DataMapper::Sweatshop.unique(:account) {/\w+/.gen},
  :active => true,
}}
User.fixture {{
  :email => DataMapper::Sweatshop.unique(:email) {/\w{2,10}@\w{2,16}\.com/.gen},
  :firstname => /\w+/.gen,
  :surname => /\w+/.gen,
  :active => true,
  :password => (password = /\w{6,20}/.gen),
  :password_confirmation => password,
  :account => Account.gen
}}
Domain.fixture {{
  :name => DataMapper::Sweatshop.unique(:domain) {/\w{2,16}\.com/.gen},
  :active => true,
  :account => Account.gen,
}}

Alias.fixture {{
  :source => DataMapper::Sweatshop.unique(:email) {/\w+@\w+\.com/.gen},
  :destination => 'test@example.com',
  :active => true,
  :domain => Domain.gen
}}
Mailbox.fixture {{
  :email => DataMapper::Sweatshop.unique(:email) {/\w+@\w+\.com/.gen},
  :active => true,
  :passhash => /[0-9a-z]{32}/.gen,
  :domain => Domain.gen
}}
