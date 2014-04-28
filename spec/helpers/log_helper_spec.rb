require "spec_helper"

describe LogHelper do
  describe "name_for" do
    let(:log_name) { "some_log_name" }
    let(:log) { File.join(LogWriter::LOGS_PATH, "#{log_name}#{LogWriter::LOGS_FORMAT}") }

    it "returns log name fetched from log path" do
      expect(name_for(log)).to eq(log_name)
    end
  end

  describe "current_log_file_path" do
    let(:log_id) { "log_id" }
    let(:params) { { id: log_id } }
    before { helper.stub(params: params) }

    it "returns log file path for specified id" do
      expected = File.join(LogWriter::LOGS_PATH, "#{log_id}#{LogWriter::LOGS_FORMAT}")
      expect(current_log_file_path).to eq(expected)
    end
  end
end