class AccountObserver
  include DataMapper::Observer

  observe Account

  after :create do
    self.create_default_name_records
    self.create_default_aliases
  end
end
