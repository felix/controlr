source 'http://rubygems.org'

RAILS_VERSION = '~> 3.0.4'
DM_VERSION    = '~> 1.0.2'

gem 'activesupport',      RAILS_VERSION, :require => 'active_support'
gem 'actionpack',         RAILS_VERSION, :require => 'action_pack'
gem 'actionmailer',       RAILS_VERSION, :require => 'action_mailer'
#gem 'railties',           RAILS_VERSION, :require => 'rails'
gem 'rails',              RAILS_VERSION
gem 'i18n'

gem 'dm-rails',          '~> 1.0.4'
gem 'dm-mysql-adapter',     DM_VERSION

# You can use any of the other available database adapters.
# This is only a small excerpt of the list of all available adapters
# Have a look at
#
#  http://wiki.github.com/datamapper/dm-core/adapters
#  http://wiki.github.com/datamapper/dm-core/community-plugins
#
# for a rather complete list of available datamapper adapters and plugins

# gem 'dm-sqlite-adapter',    DM_VERSION
# gem 'dm-mysql-adapter',     DM_VERSION
# gem 'dm-postgres-adapter',  DM_VERSION
# gem 'dm-oracle-adapter',    DM_VERSION
# gem 'dm-sqlserver-adapter', DM_VERSION

gem 'dm-migrations',        DM_VERSION
gem 'dm-types',             DM_VERSION
gem 'dm-validations',       DM_VERSION
gem 'dm-constraints',       DM_VERSION
gem 'dm-transactions',      DM_VERSION
gem 'dm-aggregates',        DM_VERSION
gem 'dm-timestamps',        DM_VERSION
gem 'dm-observer',          DM_VERSION

gem 'rails3-generators'

gem 'haml'
gem 'haml-rails'

group(:development, :test) do

  # needed for test/unit/ui/console/testrunner
  gem 'test-unit'
  gem 'shoulda' #, :git => '/home/felix/Source/shoulda', :branch => 'datamapper'
  #gem 'minitest' #, '2.0.0.beta', :git => 'git://github.com/seattlerb/minitest.git'
  gem 'dm-sqlite-adapter',    DM_VERSION
  gem 'autotest'
  gem 'autotest-rails-pure'
#  gem 'redgreen'
  gem 'test_notifier'

  #gem 'dm-sweatshop',         DM_VERSION
  gem 'dm-sweatshop', :git => 'git@github.com:felix/dm-sweatshop.git', :branch => 'noparsetree'

  # gem 'rspec-rails', '~> 2.0.1'

  # To get a detailed overview about what queries get issued and how long they take
  # have a look at rails_metrics. Once you bundled it, you can run
  #
  #   rails g rails_metrics Metric
  #   rake db:automigrate
  #
  # to generate a model that stores the metrics. You can access them by visiting
  #
  #   /rails_metrics
  #
  # in your rails application.

  # gem 'rails_metrics', '~> 0.1', :git => 'git://github.com/engineyard/rails_metrics'

end

#  vim: set ts=2 sw=2 tw=80 ft=ruby fdm=syntax et fen :
