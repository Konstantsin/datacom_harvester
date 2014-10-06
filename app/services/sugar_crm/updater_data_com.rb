require 'data_com/agent'

module SugarCrm
  module UpdaterDataCom
    extend self

    ACCOUNTS_LIMIT = 10

    def update
      accounts.each do |account|
        logger.log(account, search_for(account))
        sleep(30.seconds)
      end
    rescue DataCom::SecurityCaptchaError => e
      logger.options[:error] = e
      ErrorsMailer.captcha.deliver
    rescue Exception => e
      logger.options[:error] = e
    ensure
      logger.close
    end

    def update_account(account_name)
      result = DataCom::Agent.instance.search(account_name)
      logger.log(SugarCRM::Account.new(name: account_name), result)

      result
    rescue DataCom::SecurityCaptchaError  => e
      logger.options[:error] = e
      ErrorsMailer.captcha.deliver
    rescue Exception => e
      logger.options[:error] = e
    ensure
      logger.close
    end

    private

    def search_for(account)
      search_result = DataCom::Agent.instance.search(account.name)
      account.data_com_checked!

      return nil unless search_result

      account.update_from_data_com!(search_result.company.to_sugar_data)
      account.add_data_com_contacts(search_result.contacts)

      search_result
    end

    def accounts
      Account.all(query)
    end

    def query
      { conditions: { email: nil, phone_office: [nil] }, limit: ACCOUNTS_LIMIT }
    end

    def logger
      @logger ||= UpdateLog.new(sugar_accounts: accounts.map(&:name))
    end
  end
end
