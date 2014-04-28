module SugarCrm
  class UpdaterDataCom
    ACCOUNTS_LIMIT = 10

    def initialize(offset)
      @offset = offset
    end

    def update
      accounts.each do |account|
        if search_result = DataCom::Agent.instance.search(account.name)
          account.update_from_data_com!(search_result.company.to_sugar_data)
          account.add_data_com_contacts(search_result.contacts)
        end
        logger.log(account, search_result)
      end
    rescue Exception => e
      logger.options[:error] = e
    ensure
      logger.close
    end

    def accounts
      Account.all(query.merge(query_options))
    end

    private

    def query_options
      return {} if @offset.nil?
      { limit: ACCOUNTS_LIMIT, offset: @offset }
    end

    def query
      { conditions: { email: nil, phone_office: [nil] } }
    end

    def logger
      @logger ||= UpdateLog.new(limit: ACCOUNTS_LIMIT, offset: @offset)
    end
  end
end