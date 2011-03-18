class Alias
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :source, String, :required => true
  property :destination, Text
  property :active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :domain, :required => true

  #validates_format_of :source, :as => :email_address

  before :save do |a|
    self.source = source.slice(/[^@]+/) << '@' << domain.name
  end

  def destination=(emails)
    emails ||= ''
    if emails.class == Array
      new_dest = emails.uniq.compact.join(',')
    else
      new_dest = emails.split(%r{,\n+}).uniq.compact.join(',')
    end
    super(new_dest)
  end

  def destination_array
    return [] if destination.nil?
    destination.split(%r{,\n+}).uniq.compact
  end

end
