class ConfigLoader

  def initialize(config_name, config_path = 'config')
    @config = YAML::load_file(File.join(Rails.root, config_path, config_name))[Rails.env].symbolize_keys
  end

  def method_missing(method_name, *args, &block)
    if method_name.in?(@config.keys)
      @config[method_name]
    else
      super
    end
  end
end