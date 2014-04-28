module DataCom
  class SearchResult
    attr_reader :company
    attr_accessor :contacts

    FETCHING_CONTACTS_COUNT = 10

    def initialize(html)
      @html = Nokogiri::HTML(html)
      @contacts = []
    end

    def company
      CompanyResult.new(company_info)
    end

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