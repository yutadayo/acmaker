$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'acmaker'
require 'yaml'

aws_config_path = Pathname.new(File.expand_path('../', __FILE__)).join('aws_config.yml')
AWS_CONFIG = YAML.load_file(aws_config_path)
