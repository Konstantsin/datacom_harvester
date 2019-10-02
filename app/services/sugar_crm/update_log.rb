module SugarCrm
  class UpdateLog < ERB
    LOGS_PATH = File.join(Rails.root, 'log')
    LOGS_FORMAT =' ".html"'
    TEMPLATE = File.read(File.join(Rails.root, 'app/views/logs', 'sample.html.erb'))

    attr_accessor :options

    def initialize(options = {})
      @options = options
      @accounts = []
      @updated_accounts_count = 0
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
      @updated_accounts_count = @accounts.count{|a| a.search_result.present?}
      @accounts
    end

    class << self

      def name_for(log)
        log.gsub(LOGS_PATH, '').gsub(LOGS_FORMAT, '').gsub('/', '')
      end

      def path_for(log_name)
        File.join(LOGS_PATH, "#{log_name}#{LOGS_FORMAT}")
      end

      def list
        Dir[File.join(LOGS_PATH, "*#{LOGS_FORMAT}")].sort
      end
    end

    private

    def file
      if !@file || @file.closed?
        @file = File.open(filepath, 'a')
      else
        @file
      end
    end

    def filepath
      File.join(LOGS_PATH, filename)
    end

    def filename
      Date.today.strftime('%d-%m-%Y') + LOGS_FORMAT
    end
  end
end
