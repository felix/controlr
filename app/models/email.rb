class Email
  include DataMapper::Resource
  extend ActiveModel::Translation

  property :id, Serial
  property :address, String, :required => true
  property :active, Boolean
  property :destination, Text
  property :maildir, String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :domain

  #validates_format_of :address, :as => :email_address, :unless => lambda {|ea| ea.address[0] == '@'}

  def destination
    destination_array.reject{|e| e == @address}.join(',')
  end

  def destination=(emails)
    debugger
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

  def store=(store)
    if store
      self.destination = destination_array.unshift(@address)
    else
      self.destination = destination_array.reject{|e| e == @address}
    end
    raise self.destination.inspect
  end

  def store
    self.store?
  end

  def store?
    destination_array.include? @address
  end


  def destination_array
    return [] if @destination.nil?
    @destination.split(%r{,\n+}).uniq.compact
  end
end
