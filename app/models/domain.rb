class Domain
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :name, String, :unique => true, :required => true
  property :active, Boolean
  property :email_active, Boolean
  property :email_alias, String
#  property :backup_mx, Boolean, :default => 0
#  property :mailboxes_max, Integer, :default => 0, :required => false
  property :email_max_quota, Integer, :default => '200000'
  property :ftp_active, Boolean
  property :ftp_quota, Integer, :default => 0
  property :dns_active, Boolean, :default => 0
  property :dns_min_ttl, Integer, :default => '43200'
  property :passhash, String, :length => 32
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :mailboxes, :constraint => :destroy
  has n, :aliases, :constraint => :destroy
  belongs_to :account
  has n, :users, :through => Resource
  has n, :name_records

  validates_format_of :name, :with => %r{^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$}

  def passhash=(plain)
    super(Digest::MD5.hexdigest(plain)) unless plain.blank?
  end

  def update_config_files
    if self.dns_active
      dns_max = self.name_records.max(:updated_at)
      generate_config(CONFIG['dns_service_type'], dns_max)
    else
      remove_config(CONFIG['dns_service_type'])
    end
  end

  private

  def generate_config(type, updated=Time.now)
    path = File.join(CONFIG['config_file_base'], type, self.name)

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
    path = File.join(CONFIG['config_file_base'], type, self.name)
    File.unlink(path) if File.exists?(path)
  end
end
