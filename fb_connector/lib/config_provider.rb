# frozen_string_literal: true

require 'yaml'

class ConfigProvider < Facebook::Messenger::Configuration::Providers::Base
  CONFIG_FILE = File.absolute_path(File.join(File.dirname(__FILE__), '..', 'config', 'fb_credentials.yml')).freeze
  CONFIG = YAML.load_file(CONFIG_FILE).freeze

  def valid_verify_token?(verify_token)
    verify_token == CONFIG['VERIFY_TOKEN']
  end

  def app_secret_for(*)
    CONFIG['APP_SECRET']
  end

  def access_token_for(*)
    CONFIG['ACCESS_TOKEN']
  end
end
