# The class to interact with SugarCRM accounts
#
# @see https://github.com/chicks/sugarcrm for more information
#
class Account < SugarCRM::Account

  # Default values for SugarCRM contacts
  # Needed to pass SugarCRM validation for contacts
  #
  DEFAULT_SUGAR_CRM_VALUES = {
    lead_source: "databases/lists",
    lead_source_description_c: "Data.com grabber"
  }

  # class_eval construction is used to add custom instance methods to Account
  #
  SugarCRM::Account.class_eval do

    # Updates Account record with specified attributes
    # Anyway updates account's website
    # Updates other account's fields if they are empty
    #
    # @example Update a Account record
    #   Account.first.update_from_data_com!(website: "test.com", name: "Test name") #=> true
    #
    # @param [Hash] attrs the attributes to update account with.
    # @option opts [String] :website
    # @option opts [String] :phone_office
    # @option opts [String] :shipping_address_city
    # @option opts [String] :shipping_address_state
    # @option opts [String] :shipping_address_country
    # @option opts [Boolean] :data_com_checked_c true if account was checked on data.com website
    #
    # @return [Boolean] is update for record was successfull
    #
    def update_from_data_com!(attrs = {})
      self.website = attrs.delete(:website)
      attrs.keep_if { |k, _| read_attribute(k).blank? }
      update_attributes(attrs)
    end

    # Adds specified contacts which was found on data.com website to account's assosiated contacts
    # Merges to contact's data default `contacts_defaults` to pass contact's save validation
    #
    # @example Add contacts results to Account record
    #   contacts = [DataCom::ContactResult.new(""), DataCom::ContactResult.new("")]
    #   account.add_data_com_contacts(contacts)
    #
    # @param [Array <DataCom::ContactResult>] datacom_contacts array of contacts found on data.com for account
    #
    def add_data_com_contacts(datacom_contacts)
      datacom_contacts.each do |contact|
        contacts << Contact.new(contact.to_sugar_data.merge(contacts_defaults))
      end
    end

    # Sets account record's field `data_com_checked_c` to true
    # Uses when searching for account name on data.com was performed
    #
    # @example Updates data_com_checked_c to true for account
    #   account.data_com_checked! #=> true
    #
    # @return [Boolean] is update for record was successfull
    #
    def data_com_checked!
      update_attributes(data_com_checked_c: true)
    end

    private

    def contacts_defaults
      DEFAULT_SUGAR_CRM_VALUES.merge({
        account_id: id,
        account_name: name,
        assigned_user_id: assigned_user_id
      })
    end
  end
end
