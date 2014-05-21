module DataCom
  class SecurityCaptchaError < StandardError ; end

  class Agent < Watir::Browser
    include Singleton

    def initialize(driver = :phantomjs)
      super(driver)
    end

    def search(query)
      login unless logged_in?
      search_for(query)
      sleep(30.seconds)
      search_result if companies_found?
    end

    private

    def logged_in?
      div(:id, "loggedInHeader").exists?
    end

    def login
      goto(config.login_url)
      text_field(:id, "j_username").value = config.username
      text_field(:id, "j_password").value = config.password
      form(:name, "LoginForm").submit
    end

    def search_result
      result = SearchResult.new(html)
      result.fetch_contacts_from(contacts_page) if result.company.contacts_found? && contacts_levels_present?
      result
    end

    def contacts_levels_present?
      div(:id, "findCompanies").table(:class, "result").tbody.trs.first.td(:class, "activeContacts").a.click and sleep 2
      div(:class, "filter-levels").td(:class, "group-name").click
      contacts_checkbox_for(:c).exists? || contacts_checkbox_for(:vp).exists?
    end

    def contacts_page
      contacts_levels.keys.each do |level|
        checkbox = contacts_checkbox_for(level)
        checkbox.click and sleep 1 if checkbox.exists?
      end
      html
    end

    def contacts_checkbox_for(level)
      div(:class, "filter-levels").div(:id, "levels").div(:class, "components").span(:text, contacts_levels[level])
    end

    def contacts_levels
      { c: /C-Level/, vp: /VP-Level/ }
    end

    def search_for(query)
      raise SecurityCaptchaError if security_check?

      if text_field(:id, "freeTextInput").present?
        text_field(:id, "freeTextInput").value = query
        div(:id, "sbsSearch").click
      else
        goto(config.search_url)
        text_field(:id, "homepageSBS").value = query
        div(:id, "homepageSearchIcon").click
      end
      div(:id, "tabs").ul.lis.last.double_click and sleep 2
    end

    def security_check?
      table(:class, "hover-table").div(:class, "hover-header").div(:text, /Security Check/).exists?
    end

    def companies_found?
      div(:id, "findCompanies").present? && div(:id, "findCompanies").span(:class, "resultCount").text.to_i > 0
    end

    def config
      @config ||= ConfigLoader.new("datacom.yml")
    end
  end
end
