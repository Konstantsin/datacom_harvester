module SugarCrm
  module UpdaterDataCom
    extend self

    ACCOUNTS_LIMIT = 10

    def update
      accounts.each { |account| logger.log(account, search_for(account)) }
    rescue Exception => e
      logger.options[:error] = e
    ensure
      logger.close
    end

    private

    def search_for(account)
      search_result = DataCom::Agent.instance.search(account.name)
      account.data_com_checked! and return nil unless search_result

      account.update_from_data_com!(search_result.company.to_sugar_data)
      account.add_data_com_contacts(search_result.contacts)

      search_result
    end

    def accounts
      Account.all(query)
    end

    def query
      { conditions: { email: nil, phone_office: [nil], data_com_checked_c: nil }, limit: ACCOUNTS_LIMIT }
    end

    def logger
      @logger ||= UpdateLog.new(sugar_accounts: accounts.map(&:name))
    end
  end
end
