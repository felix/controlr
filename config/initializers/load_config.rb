CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

# required defaults
CONFIG['config_file_base'] ||= File.join(Rails.root,'generated_configs')
CONFIG['template_base'] ||= File.join(Rails.root,'app','views','templates')
