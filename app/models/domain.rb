class Domain
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :name, String, :unique => true, :required => true
  property :active, Boolean, :default => false
  property :email_active, Boolean, :default => false
  property :email_alias, String
#  property :backup_mx, Boolean, :default => 0
#  property :mailboxes_max, Integer, :default => 0, :required => false
  property :email_max_quota, Integer, :default => '200000'
  property :ftp_active, Boolean, :default => false
  property :ftp_quota, Integer, :default => 0
  property :dns_active, Boolean, :default => 0
  property :dns_min_ttl, Integer, :default => '43200'
  property :passhash, String, :length => 32
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :mailboxes, :constraint => :destroy, :order => [:email.asc]
  has n, :aliases, :constraint => :destroy, :order => [:source.asc]
  belongs_to :account
  has n, :users, :through => Resource
  has n, :name_records, :constraint => :destroy, :order => [:type.asc, :host.asc, :distance.asc]

  validates_format_of :name, :with => %r{^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$}

  def passhash=(plain)
    super(Digest::MD5.hexdigest(plain)) unless plain.blank?
  end

  def sync_config_files
    if self.active && self.dns_active
      dns_max = self.name_records.max(:updated_at)
      generate_config(CONFIG['dns_service_type'], dns_max)
    else
      remove_config(CONFIG['dns_service_type'])
    end
  end

  def create_default_aliases
    hostmaster = self.aliases.first_or_create(
      {:source => "hostmaster@#{self.name}"},
      {:destination => CONFIG['hostmaster'],
      :active => true,
      :system => true}
    )
    postmaster = self.aliases.first_or_create(
      {:source => "postmaster@#{self.name}"},
      {:destination => CONFIG['postmaster'],
      :active => true,
      :system => true}
    )
    catchall = self.aliases.first_or_create(
      {:source => "@#{self.name}"},
      {:destination => '',
      :active => false,
      :system => true}
    )
    return hostmaster && postmaster && catchall
  end

  def create_default_name_records
    ns1 = self.name_records.first_or_create(
      {:type => 'NS',
      :host => self.name,
      :value => CONFIG['nameserver1']},
      {:active => true,
      :description => 'Automatically generated entry'}
    )
    ns2 = self.name_records.first_or_create(
      {:type => 'NS',
      :host => self.name,
      :value => CONFIG['nameserver2']},
      {:active => true,
      :description => 'Automatically generated entry'}
    )
    mx1 = self.name_records.first_or_create(
      {:type => 'MX',
      :host => self.name,
      :value => CONFIG['mx1']},
      {:active => false,
      :distance => 10,
      :description => 'Automatically generated entry'}
    )
    mx2 = self.name_records.first_or_create(
      {:type => 'MX',
      :host => self.name,
      :value => CONFIG['mx2']},
      {:active => false,
      :distance => 20,
      :description => 'Automatically generated entry'}
    )
    return ns1 && ns2 && mx1 && mx2
  end

  def create_gmail_name_records
    mx1 = self.name_records.first_or_create(
      {:type => 'MX',
      :host => self.name,
      :value => 'aspmx.l.google.com'},
      {:active => false,
      :distance => 1,
      :description => 'Gmail MX record'}
    )
    mx2 = self.name_records.first_or_create(
      {:type => 'MX',
      :host => self.name,
      :value => 'alt1.aspmx.l.google.com'},
      {:active => false,
      :distance => 5,
      :description => 'Gmail MX record'}
    )
    mx3 = self.name_records.first_or_create(
      {:type => 'MX',
      :host => self.name,
      :value => 'alt2.aspmx.l.google.com'},
      {:active => false,
      :distance => 5,
      :description => 'Gmail MX record'}
    )
    mx4 = self.name_records.first_or_create(
      {:type => 'MX',
      :host => self.name,
      :value => 'aspmx2.googlemail.com'},
      {:active => false,
      :distance => 10,
      :description => 'Gmail MX record'}
    )
    mx5 = self.name_records.first_or_create(
      {:type => 'MX',
      :host => self.name,
      :value => 'aspmx3.googlemail.com'},
      {:active => false,
      :distance => 10,
      :description => 'Gmail MX record'}
    )
    spf = self.name_records.first_or_create(
      {:type => 'TXT',
      :host => self.name,
      :value => 'v=spf1 include:aspmx.googlemail.com ~all'},
      {:active => false,
      :description => 'Gmail SPF record'}
    )
    return mx1 && mx2 && mx3 && mx4 && mx5 && spf
  end

  def create_gapps_name_records
    docs = self.name_records.first_or_create(
      {:type => 'CNAME',
      :host => "docs.#{self.name}",
      :value => 'ghs.google.com'},
      {:active => false,
      :description => 'Google Apps record'}
    )
    calendar = self.name_records.first_or_create(
      {:type => 'CNAME',
      :host => "calendar.#{self.name}",
      :value => 'ghs.google.com'},
      {:active => false,
      :description => 'Google Apps record'}
    )
    webmail = self.name_records.first_or_create(
      {:type => 'CNAME',
      :host => "webmail.#{self.name}",
      :value => 'ghs.google.com'},
      {:active => false,
      :description => 'Google Apps record'}
    )
    return docs && calendar && webmail
  end

  private

  def generate_config(type, updated=Time.now)
    path = config_path(type)
    if !File.exists?(path) || updated >= File.stat(path).mtime
      FileUtils.mkdir_p(File.dirname(path)) if !File.exists?(path)

      template = File.open(File.join(CONFIG['template_base'],"#{type}.erb")).read

      erb = Erubis::Eruby.new(template)
      context = Erubis::Context.new()
      # use @domain in template to access domain
      context['domain'] = self
      data = erb.evaluate(context)

      File.open(path, 'w') do |file|
        file.write(data)
      end
    end
  end

  def remove_config(type)
    return nil unless type
    File.unlink(config_path(type)) if File.exists?(config_path(type))
  end

  def config_path(type)
    File.join(CONFIG['config_file_base'], type, self.name)
  end
end
