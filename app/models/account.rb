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
    records = []
    CONFIG['nameservers'].each do |ns|
      records << self.default_name_records.first_or_create(
        {:type => 'NS',
          :value => ns},
          {:active => true,
            :description => 'Automatically generated entry'}
      )
    end
    CONFIG['mx'].each_index do |idx|
      records << self.default_name_records.first_or_create(
        {:type => 'MX',
          :value => CONFIG['mx'][idx]},
          {:active => false,
            :distance => (idx+1)*5,
            :description => 'Automatically generated entry'}
      )
    end
    # return true only if all created successfully
    return records.inject(true){|memo,r| memo && !r.nil?}
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
    abuse = self.default_aliases.first_or_create(
      {:source => 'abuse'},
      {:destination => CONFIG['abuse'],
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
