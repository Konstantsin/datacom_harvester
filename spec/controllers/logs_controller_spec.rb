require "spec_helper"

describe LogsController do
  before { controller.stub(:render) }

  describe "index" do
    let(:logs) { [] }

    it "responds successfully with an 200 HTTP status code for GET request" do
      expect(Dir).to receive(:[]).and_return(logs)
      expect(response).to be_success
      expect(response.code).to eq("200")
      get :index
    end
  end

  describe "show" do
    let(:id) { "some_id" }

    it "responds successfully with an 200 HTTP status code for GET request" do
      expect(response).to be_success
      expect(response.code).to eq("200")
      get :show, id: id
    end
  end
end
