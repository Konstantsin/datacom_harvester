module DataCom
  # The class wrapper for company search result table row
  #
  class CompanyResult

    def initialize(company_info)
      @company_info = company_info
    end

    def company_name
      @company_info.css('td.name a.companyName').children[0].to_s
    end

    # Fetches and returns company's website address
    #
    # @return [String] website of company, fetched from table row
    #
    def website
      @company_info.css('td.name div.website a').attr('href').value
    end

    # Fetches and returns company's phone
    #
    # @return [String] phone of company, fetched from table row
    #
    def phone
      @company_info.css('td.name div.phone').text.strip.delete('.')
    end

    # Fetches and returns company's city
    #
    # @return [String] city of company, fetched from table row
    #
    def city
      @company_info.css('td.city').text.strip
    end

    # Fetches and returns company's state
    #
    # @return [String] state of company, fetched from table row
    #
    def state
      @company_info.css('td.state').text.strip
    end

    # Fetches and returns company's country
    #
    # @return [String] country of company, fetched from table row
    #
    def country
      @company_info.css('td.country').text.strip
    end

    # Returns 'true' if company's row Active Accounts value more than 0
    #
    # @return [Boolean]
    #
    def contacts_found?
      @company_info.css('td.activeContacts').text.strip.to_i > 0
    end

    # Mapps current company result's data into corresponding SugarCRM account fields
    #
    # @return [Hash <Symbol: String>]
    #
    def to_sugar_data
      {
        website: website,
        phone_office: phone,
        shipping_address_city: city,
        shipping_address_state: state,
        shipping_address_country: country,
        data_com_checked_c: true
      }
    end

    def to_api_data
      {
        company_name: company_name,
        website: website,
        phone_number: phone,
        city: city,
        state: state,
        country: country
      }
    end
  end
end
