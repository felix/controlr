class EmailAddress
  include DataMapper::Resource

  attr_accessor :store, :destinations

  property :id, Serial
  property :address, String, :required => true
  property :active, Boolean
  property :destination, Text
  property :created_at, DateTime
  property :modified_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :domain

  def destinations
    @destination.split(%r{,\n+}).uniq.compact
  end

  def destination=(emails)
    if emails.nil? || emails.empty?
      @destination = ''
    else
      if emails.class == Array
        @destination = emails.uniq.compact.join(',')
      else
        @destination = emails.split(%r{,\n+}).uniq.compact.join(',')
      end
    end
  end

  def store=(store)
    if store
      self.destination = self.destinations.unshift(@address)
    else
      self.destination = self.destinations.delete(@address)
    end
  end

  def store
    self.destinations.include? @address
  end

end
