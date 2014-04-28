class Account < SugarCRM::Account
  DEFAULT_SUGAR_CRM_VALUES = {
    lead_source: "databases/lists",
    lead_source_description_c: "Data.com grabber"
  }

  SugarCRM::Account.class_eval do
    def update_from_data_com!(attrs)
      binding.pry
      self.website = attrs.delete(:website)
      attrs.keep_if { |k, _| read_attribute(k).empty? }
      update_attributes(attrs)
    end

    def contacts_defaults
      {
        account_id: id,
        account_name: name,
        assigned_user_id: assigned_user_id
      }.merge(DEFAULT_SUGAR_CRM_VALUES)
    end

    def add_data_com_contacts(datacom_contacts)
      datacom_contacts.each do |contact|
        contacts << Contact.new(contact.to_sugar_data.merge(contacts_defaults))
      end
    end
  end
end