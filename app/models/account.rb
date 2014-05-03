class Account < SugarCRM::Account

  DEFAULT_SUGAR_CRM_VALUES = {
    lead_source: "databases/lists",
    lead_source_description_c: "Data.com grabber"
  }

  SugarCRM::Account.class_eval do

    def update_from_data_com!(attrs)
      self.website = attrs.delete(:website)
      attrs.keep_if { |k, _| read_attribute(k).empty? }
      update_attributes(attrs)
    end

    def add_data_com_contacts(datacom_contacts)
      datacom_contacts.each do |contact|
        contacts << Contact.new(contact.to_sugar_data.merge(contacts_defaults))
      end
    end

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