class Account
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :active, Boolean, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :domains, :order => [:name.asc], :constraint => :destroy
  has n, :users, :constraint => :destroy
  has n, :default_name_records, :constraint => :destroy
  has n, :default_aliases, :constraint => :destroy

  # default default_name_records for a new account
  def create_default_name_records
    ns1 = self.default_name_records.first_or_create(
      {:type => 'NS',
      :value => CONFIG['nameserver1']},
      {:active => true,
      :description => 'Automatically generated entry'}
    )
    ns2 = self.default_name_records.first_or_create(
      {:type => 'NS',
      :value => CONFIG['nameserver2']},
      {:active => true,
      :description => 'Automatically generated entry'}
    )
    mx1 = self.default_name_records.first_or_create(
      {:type => 'MX',
      :value => CONFIG['mx1']},
      {:active => false,
      :distance => 10,
      :description => 'Automatically generated entry'}
    )
    mx2 = self.default_name_records.first_or_create(
      {:type => 'MX',
      :value => CONFIG['mx2']},
      {:active => false,
      :distance => 20,
      :description => 'Automatically generated entry'}
    )
    return ns1 && ns2 && mx1 && mx2
  end

  def create_default_aliases
    hostmaster = self.default_aliases.first_or_create(
      {:source => 'hostmaster'},
      {:destination => CONFIG['hostmaster'],
      :active => true,
      :system => true}
    )
    postmaster = self.default_aliases.first_or_create(
      {:source => 'postmaster'},
      {:destination => CONFIG['postmaster'],
      :active => true,
      :system => true}
    )
    catchall = self.default_aliases.first_or_create(
      {:source => ''},
      {:destination => '',
      :active => false,
      :system => true}
    )
    return hostmaster && postmaster && catchall
  end

end
