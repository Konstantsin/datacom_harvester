module DataCom

  # The class contains results of parsing search results from data.com website
  #
  class SearchResult
    attr_reader :company
    attr_accessor :contacts

    # Max number of accounts from data.com results which will be parsed and saved
    #
    FETCHING_CONTACTS_COUNT = 10

    def initialize(html)
      @html = Nokogiri::HTML(html)
      @contacts = []
    end

    # Returns wrapped as CompanyResult instance company search result from data.com
    #
    # @return [CompanyResult] wrapped object, parsed search result page
    #
    def company
      CompanyResult.new(company_info)
    end

    def companies
      @html.css("div#findCompanies table.result tbody tr")[0..2].map do |company_info|
        CompanyResult.new(company_info) if company_info
      end.compact
    end

    # Parses specified html page, which must be a contacts search result page from data.com
    # Wrappes every found contact information as ContactResult instance and pushes it into contacts array
    #
    # @param [String] page with search results for contacts
    #
    def fetch_contacts_from(page)
      contacts_from(page).each do |contact|
        contacts << ContactResult.new(contact)
      end
    end

    private

    def company_info
      @html.css("div#findCompanies table.result tbody tr").first
    end

    def contacts_from(page)
      Nokogiri::HTML(page).css("div#findContacts table.result tbody tr")[0...FETCHING_CONTACTS_COUNT]
    end
  end
end
