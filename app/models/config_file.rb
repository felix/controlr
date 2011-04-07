class ConfigFile
  include DataMapper::Resource

  TYPES = %w{tinydns bind}

  property :id, Serial
  property :active, Boolean, :default => false
  property :type, String, :required => true, :default => 'TINYDNS'
  property :checksum, String, :length => 32
  property :updated_at, DateTime

  belongs_to :domain

  def path
    File.join(config_file_base,self.type,self.domain.name)
  end

  def write(data)
    return if data.nil?
    File.open(self.path, 'w') do |file|
      file.write(data)
    end
    self.updated_at = File.stat(self.path).mtime
  end

  def current?
    File.exists?(self.path) && self.get_latest_model <= File.stat(self.path).mtime
    #self.checksum == Digest::MD5.hexdigest(self.data)
  end

  def data
    @data ||= File.open(self.path).read
  end

  def get_latest_model
    case self.type
    when 'tinydns','bind'
      self.domain.name_records.max(:updated_at)
    end
  end

  def generate
    return nil unless self.active
    FileUtils.mkdir_p(File.dirname(self.path)) if !File.exists?(self.path)

    template = File.open(File.join(template_path,"#{self.type}.erb")).read

    erb = Erubis::Eruby.new(template)
    context = Erubis::Context.new()
    # use @template with template to access config_file
    context[self.type] = self
    data = erb.evaluate(context)

    File.open(self.path, 'w') do |file|
      file.write(data)
    end
    self.updated_at = File.stat(self.path).mtime
    self.checksum = Digest::MD5.hexdigest(data)
    self.save
  end

  private

  def config_file_base
    CONFIG['config_file_base'] ||= File.join(Rails.root,'generated_configs')
  end

  def template_path
    CONFIG['template_base'] ||= File.join(Rails.root,'app','views','config_files')
  end
end
