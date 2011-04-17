class DefaultAlias
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :source, String
  property :destination, Text
  property :active, Boolean
  property :system, Boolean, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :account, :required => true

  #validates_format_of :source, :as => :email_address

  def destination=(emails)
    emails ||= ''
    if emails.class == Array
      new_dest = emails.collect{|a| a.strip}.uniq.compact.join(',')
    else
      new_dest = emails.split(%r{[\s,\n]+}).collect{|a| a.strip}.uniq.compact.join(',')
    end
    super(new_dest)
  end

  def destination_array
    return [] if destination.blank?
    destination.split(',')
  end
end
