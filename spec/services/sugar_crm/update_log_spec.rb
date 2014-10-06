require "spec_helper"

describe SugarCrm::UpdateLog do
  let(:options) { { key: "value", key2: "value2" } }
  let(:template) { "Render <%= @options[:key] %> and <%= @options[:key2] %>" }
  subject { SugarCrm::UpdateLog.new(options) }

  before { stub_const("SugarCrm::UpdateLog::TEMPLATE", template) }

  describe "#result" do
    it "returns string with rendered variables" do
      expect(subject.result).to eq("Render value and value2")
    end
  end

  describe "#close" do
    let(:file) { double(:file) }
    before { File.stub(open: file) }

    it "renders result into a file and closes file stream" do
      expect(file).to receive(:puts).with(subject.result)
      expect(file).to receive(:closed?)
      expect(file).to receive(:close)
      subject.close
    end
  end

  describe "#log" do
    let(:sugar_account) { double(:sugar_account) }
    let(:search_result) { double(:search_result) }
    let(:result_open_struct) { OpenStruct.new(sugar_account: sugar_account, search_result: search_result) }

    it "adds specified sugar_account and search_result into subject's accounts array as OpenStruct" do
      result = subject.log(sugar_account, search_result)
      expect(result).to be_a(Array)
      expect(result.count).to eq(1)
      expect(result.first).to eq(result_open_struct)
    end
  end

  context "class methods" do
    let(:log_name) { "log_name" }
    let(:log) { File.join(SugarCrm::UpdateLog::LOGS_PATH, "#{log_name}#{SugarCrm::UpdateLog::LOGS_FORMAT}") }

    describe ".name_for" do
      it "fetches name from specified log as string" do
        expect(SugarCrm::UpdateLog.name_for(log)).to eq(log_name)
      end
    end

    describe ".path_for" do
      it "returns log's path for specified log name" do
        expect(SugarCrm::UpdateLog.path_for(log_name)).to eq(log)
      end
    end

    describe ".list" do
      let(:logs) { double(:logs) }

      it "returns array of logs with 'SugarCrm::UpdateLog::LOGS_FORMAT' format in 'SugarCrm::UpdateLog::LOGS_PATH' directory" do
        expect(File).to receive(:join).with(SugarCrm::UpdateLog::LOGS_PATH, "*#{SugarCrm::UpdateLog::LOGS_FORMAT}")
        expect(Dir).to receive(:[]).and_return(logs)
        expect(logs).to receive(:sort).and_return(logs)
        expect(SugarCrm::UpdateLog.list).to eq(logs)
      end
    end
  end
end
