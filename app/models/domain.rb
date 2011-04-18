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

  def copy_default_name_records
    self.account.default_name_records.each do |dnr|
      self.name_records.first_or_create(
        {:type => dnr.type,
          :value => dnr.value,
          :host => dnr.host.blank? ? self.name : "#{dnr.host}.#{self.name}"},
          {:active => dnr.active,
            :distance => dnr.distance,
            :description => dnr.description}
      )
    end
  end

  def copy_default_aliases
    self.account.default_aliases.each do |da|
      self.aliases.first_or_create(
        {:source => "#{da.source}@#{self.name}"},
        {:destination => da.destination,
          :active => da.active,
          :system => da.system}
      )
    end
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
