require "spec_helper"
require "data_com/agent"


describe Api::CompaniesController do
  let(:queue) { RequestQueue.new }

  before do
    controller.stub(:request_queue).and_return(queue)
    queue.stub(:execute).and_return(result)
  end

  describe "index" do
    let(:result) do
      company = DataCom::CompanyResult.new("")
      company.stub(:company_name).and_return('altoros')
      company.stub(:city).and_return('Minsk')
      company.stub(:country).and_return('Belarus')
      company.stub(:state).and_return('')
      company.stub(:website).and_return('altoros.com')
      company.stub(:phone).and_return('123123123123')

      OpenStruct.new(companies: [company])
    end

    it "#index" do
      expect(SugarCrm::UpdaterDataCom).to receive(:update_account).with('altoros').and_return(result)

      get :index, company_name: 'altoros'

      expect(response).to be_success
      expect(response.code).to eq("200")
      expect(response.body).to eq controller.send(:build, result.companies.map(&:to_api_data)).to_xml
    end
  end
end
