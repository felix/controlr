class DomainObserver
  include DataMapper::Observer

  observe Domain

  after :create do
    self.create_default_aliases
    self.create_default_name_records
  end
end
