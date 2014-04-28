module DataCom
  class CompanyResult

    def initialize(company_info)
      @company_info = company_info
    end

    def website
      @company_info.css("td.name div.website a").attr("href").value
    end

    def phone
      @company_info.css("td.name div.phone").text.strip.delete(".")
    end

    def city
      @company_info.css("td.city").text.strip
    end

    def state
      @company_info.css("td.state").text.strip
    end

    def country
      @company_info.css("td.country").text.strip
    end

    def contacts_found?
      @company_info.css("td.activeContacts").text.strip.to_i > 0
    end

    def to_sugar_data
      {
        website: website,
        phone_office: phone,
        shipping_address_city: city,
        shipping_address_state: state,
        shipping_address_country: country
      }
    end
  end
end