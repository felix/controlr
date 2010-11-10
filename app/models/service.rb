class Service
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :active, Boolean
  property :type, Discriminator
  property :start_cmd, String, :required => true
  property :stop_cmd, String, :required => true
  property :restart_cmd, String
  property :reload_cmd, String
  property :config_file, String
  property :config_file_hash, String, :length => 32
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  belongs_to :server, :required => true

  # for STI and actionpack
  # http://code.alexreisner.com/articles/single-table-inheritance-in-rails.html
  def self.model_name
    name = 'service'
    name.instance_eval do
      def plural;   pluralize;   end
      def singular; singularize; end
      def human;    singularize; end # only for Rails 3
    end
    return name
  end
end
