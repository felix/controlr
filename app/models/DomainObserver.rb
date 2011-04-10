class DomainObserver
  include DataMapper::Observer

  observe Domain

  after :create do
    hostmaster = self.aliases.new(
      :source => "hostmaster@#{self.name}",
      :destination => CONFIG['hostmaster'],
      :active => true,
      :system => true
    )
    postmaster = self.aliases.new(
      :source => "postmaster@#{self.name}",
      :destination => CONFIG['postmaster'],
      :active => true,
      :system => true
    )
    catchall = self.aliases.new(
      :source => "@#{self.name}",
      :destination => '',
      :active => false,
      :system => true
    )
    ns1 = self.name_records.new(
      :type => 'NS',
      :host => self.name,
      :value => CONFIG['nameserver1'],
      :active => true,
      :description => 'Automatically generated entry'
    )
    ns2 = self.name_records.new(
      :type => 'NS',
      :host => self.name,
      :value => CONFIG['nameserver2'],
      :active => true,
      :description => 'Automatically generated entry'
    )
    mx1 = self.name_records.new(
      :type => 'MX',
      :host => self.name,
      :value => CONFIG['mx1'],
      :active => false,
      :distance => 10,
      :description => 'Automatically generated entry'
    )
    mx2 = self.name_records.new(
      :type => 'MX',
      :host => self.name,
      :value => CONFIG['mx2'],
      :active => false,
      :distance => 20,
      :description => 'Automatically generated entry'
    )
  end
end
