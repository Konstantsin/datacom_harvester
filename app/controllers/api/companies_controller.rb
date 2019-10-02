module Api
  class CompaniesController < ApplicationController
    respond_to :xml
    layout false

    after_action :log_queue_state

    def index
      if request_queue << params[:company_name]
        result = SugarCrm::UpdaterDataCom.update_account(request_queue.shift)
        render xml: build(result.companies.map(&:to_api_data))
      else
        render xml: { message: 'Request limit has been exceeded!'.freeze }
      end
    rescue => e
      logger.error e.inspect
      render xml: { message: 'Server error!'.freeze }
    end

    private

    def build(results)
      Nokogiri::XML::Builder.new do |xml|
        xml.CompaniesSearchResult do
          xml.SearchResults do
            results.map do |result|
              xml.SearchResult do
                xml.company_name result[:company_name]
                xml.website      result[:website]
                xml.phone_number result[:phone_number]
                xml.city         result[:city]
                xml.state        result[:state]
              end
            end
          end
        end
      end
    end

    def log_queue_state
      logger.info "day_counter: #{request_queue.items_per_today}"
      logger.info "minute_counter: #{request_queue.items_per_minut}"
    end
  end
end
