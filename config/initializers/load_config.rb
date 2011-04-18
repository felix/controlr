custom_config = YAML.load_file(File.join(Rails.root,'config','config.yml'))[Rails.env]

# defaults
CONFIG = {
  'dns_service_type' => 'tinydns',
  'config_file_base' => File.join(Rails.root,'generated_configs'),
  'template_base'    => File.join(Rails.root,'app','views','templates'),
  'dns_min_ttl'      => 3600
}.merge(custom_config)
