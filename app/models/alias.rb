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

  before :save, :set_source

  def destination
    destination_array.reject{|e| e == @address}.join(',')
  end

  def destination=(emails)
    if emails.nil? || emails.empty?
      @destination = destination_array.delete_if{|e| e != @address}.uniq.compact.join(',')
    else
      if emails.class == Array
        @destination = emails.uniq.compact.join(',')
      else
        @destination = emails.split(%r{,\n+}).uniq.compact.join(',')
      end
    end
  end

  def destination_array
    return [] if @destination.nil?
    @destination.split(%r{,\n+}).uniq.compact
  end

  private

  def set_source(context = :default)
    self.source = source.slice(/[^@]+/) << '@' << domain.name
  end
end
