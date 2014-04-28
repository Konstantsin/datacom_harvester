module DataCom
  class Agent < Watir::Browser
    include Singleton

    def initialize
      super(:phantomjs)
    end

    def search(query)
      login unless logged_in?
      search_for(query)
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
      result.fetch_contacts_from(contacts_page) if result.company.contacts_found?
      result
    end

    def contacts_page
      div(:id, "findCompanies").table(:class, "result").tbody.trs.first.td(:class, "activeContacts").a.click and sleep 2
      div(:class, "filter-levels").td(:class, "group-name").click
      %i(c vp).each { |level| check_checkbox(level) }
      html
    end

    def check_checkbox(level)
      levels = { c: /C-Level/, vp: /VP-Level/ }
      checkbox = div(:class, "filter-levels").div(:id, "levels").div(:class, "components").span(:text, levels[level])
      checkbox.click and sleep 1 if checkbox.present?
    end

    def search_for(query)
      if text_field(:id, "freeTextInput").present?
        text_field(:id, "freeTextInput").value = query
        button(:id, "sbsSearch").click
      else
        goto(config.search_url)
        text_field(:id, "homepageSBS").value = query
        div(:id, "homepageSearchIcon").click
      end
      div(:id, "tabs").ul.lis.last.double_click and sleep 2
    end

    def companies_found?
      div(:id, "findCompanies").present? && div(:id, "findCompanies").span(:class, "resultCount").text.to_i > 0
    end

    def config
      @config ||= ConfigLoader.new("datacom.yml")
    end
  end
end