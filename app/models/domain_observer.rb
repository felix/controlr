class DomainObserver
  include DataMapper::Observer

  observe Domain

  after :create do
    self.copy_default_aliases
    self.copy_default_name_records
  end
end
