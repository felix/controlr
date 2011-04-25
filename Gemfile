source 'http://rubygems.org'

RAILS_VERSION = '~> 3.0.7'
DM_VERSION    = '~> 1.1.0'

gem 'activesupport',      RAILS_VERSION, :require => 'active_support'
gem 'actionpack',         RAILS_VERSION, :require => 'action_pack'
gem 'actionmailer',       RAILS_VERSION, :require => 'action_mailer'
gem 'activeresource',     RAILS_VERSION, :require => 'active_resource'
gem 'railties',           RAILS_VERSION

gem 'dm-rails',             DM_VERSION
gem 'dm-mysql-adapter',     DM_VERSION
gem 'dm-migrations',        DM_VERSION
gem 'dm-validations',       DM_VERSION
gem 'dm-types',             DM_VERSION
gem 'dm-constraints',       DM_VERSION
gem 'dm-transactions',      DM_VERSION
gem 'dm-aggregates',        DM_VERSION
gem 'dm-timestamps',        DM_VERSION
gem 'dm-observer',          DM_VERSION

gem 'devise', '= 1.3.0'
gem 'dm-devise'
gem 'cancan'

gem 'rails3-generators'
gem 'exception_notification', :require => 'exception_notifier'
gem 'haml'
gem 'haml-rails'

group(:development, :test) do
  # needed for test/unit/ui/console/testrunner
  gem 'test-unit'
  gem 'shoulda'
  #gem 'shoulda-datamapper', :path => '/home/felix/Source/shoulda-datamapper'
  gem 'shoulda-datamapper', :git => 'git://github.com/felix/shoulda-datamapper.git'
  #gem 'minitest' #, '2.0.0.beta', :git => 'git://github.com/seattlerb/minitest.git'
  gem 'dm-sqlite-adapter',    DM_VERSION
  gem 'autotest'
  gem 'autotest-rails-pure'
  gem 'test_notifier'

  # for some generators
  gem 'hpricot'
  gem 'ruby_parser'

  #gem 'dm-sweatshop',         DM_VERSION
  gem 'dm-sweatshop', :git => 'git://github.com/felix/dm-sweatshop.git', :branch => 'noparsetree'

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
