class ConfigObserver
  include DataMapper::Observer

  observe Domain,NameRecord #,et al

  after :save do
    if self.is_a? Domain
      sync_config_files
    elsif domain
      domain.sync_config_files
    end
  end

end
