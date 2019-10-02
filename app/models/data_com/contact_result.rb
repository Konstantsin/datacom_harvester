module DataCom

  # The class wrapper for contact search result table row
  # Each contact from results table can be wrapped as ContactResult instance
  #
  class ContactResult

    # Contacts personal url starts with current string
    #
    URL_STARTS_WITH = 'https://connect.data.com'

    def initialize(contact_row)
      @contact_row = contact_row
    end

    # Fetches and returns contact's name from td.name table element
    #
    # @return [String] name of contact, fetched from table row
    #
    def name
      @contact_row.css('td.name').text
    end

    # Fetches and returns contact's personal url from td.name a table element
    #
    # @return [String] url of contact, fetched from table row
    #
    def url
      URL_STARTS_WITH + @contact_row.css('td.name a').attr('href').value
    end

    # Fetches and returns contact's title from td.title table element
    #
    # @return [String] title of contact, fetched from table row
    #
    def title
      @contact_row.css('td.title').text
    end

    # Fetches and returns contact's address city from td.city table element
    #
    # @return [String] city of contact, fetched from table row
    #
    def city
      @contact_row.css('td.city').text
    end

    # Fetches and returns contact's address state from td.state table element
    #
    # @return [String] state of contact, fetched from table row
    #
    def state
      @contact_row.css('td.state').text
    end

    # Fetches and returns contact's address country from td.country table element
    #
    # @return [String] country of contact, fetched from table row
    #
    def country
      @contact_row.css('td.country').text
    end

    # Returns contact's first name
    #
    # @return [String] first_name of contact
    #
    def first_name
      name.split(', ').first
    end

    # Returns contact's last name
    #
    # @return [String] last_name of contact
    #
    def last_name
      name.split(', ').last
    end

    # Mapps current contact result's data into corresponding SugarCRM contact fields
    #
    # @return [Hash <Symbol: String>]
    #
    def to_sugar_data
      {
        first_name: first_name,
        last_name: last_name,
        contact_description_c: url,
        primary_address_city: city,
        primary_address_state: state,
        primary_address_country: country
      }
    end
  end
end