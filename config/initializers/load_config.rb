CONFIG = YAML.load_file(File.join(Rails.root,'config','config.yml'))[Rails.env]

# required defaults
CONFIG['dns_service_type'] ||= 'tinydns'
CONFIG['config_file_base'] ||= File.join(Rails.root,'generated_configs')
CONFIG['template_base'] ||= File.join(Rails.root,'app','views','templates')
CONFIG['dns_min_ttl'] ||= 3600
