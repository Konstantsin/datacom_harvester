module SugarCrm
  class UpdateLog < ERB
    LOGS_PATH = File.join(Rails.root, "log")
    LOGS_FORMAT = ".html"
    TEMPLATE = File.read(File.join(Rails.root, "app/views/logs", "sample.html.erb"))

    attr_accessor :options

    def initialize(options = {})
      @options = options
      @accounts = []
      super(TEMPLATE)
    end

    def result
      super(binding)
    end

    def close
      file.puts result
      file.close
    end

    def log(sugar_account, search_result)
      @accounts << OpenStruct.new(sugar_account: sugar_account, search_result: search_result)
    end

    private

    def file
      @file ||= File.open(filepath, "a")
    end

    def filepath
      File.join(LOGS_PATH, filename)
    end

    def filename
      Date.today.strftime("%d-%m-%Y") + LOGS_FORMAT
    end
  end
end