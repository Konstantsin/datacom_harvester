module DataCom
  class ContactResult
    URL_STARTS_WITH = "https://connect.data.com"

    def initialize(contact_row)
      @contact_row = contact_row
    end

    def name
      @contact_row.css("td.name").text
    end

    def url
      URL_STARTS_WITH + @contact_row.css("td.name a").attr("href").value
    end

    def title
      @contact_row.css("td.title").text
    end

    def city
      @contact_row.css("td.city").text
    end

    def state
      @contact_row.css("td.state").text
    end

    def country
      @contact_row.css("td.country").text
    end

    def first_name
      name.split(", ").first
    end

    def last_name
      name.split(", ").last
    end

    def to_sugar_data
      {
        first_name: first_name,
        last_name: last_name,
        primary_address_city: city,
        primary_address_state: state,
        primary_address_country: country
      }
    end
  end
end