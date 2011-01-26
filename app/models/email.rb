class Email
  include DataMapper::Resource

  attr_accessor :store

  property :id, Serial
  property :address, String, :required => true
  property :active, Boolean
  property :destination, Text, :required => true
  property :created_at, DateTime
  property :modified_at, DateTime
  property :deleted_at, ParanoidDateTime

  def destination
    @destination.split(%r{,\n+}).uniq.compact
  end

  def destination=(emails)
    emails = [] if emails.nil?
    if emails.class == Array
      @destination = emails.uniq.compact.join(',')
    else
      @destination = emails.split(%r{,\n+}).uniq.compact.join(',')
    end
  end

  def store=(store)
    if store
      self.destination.unshift(@address)
    else
      self.destination.delete(@address)
    end
  end

  def store
    self.destination.include? @address
  end

end
