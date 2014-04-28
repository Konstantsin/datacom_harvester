require "spec_helper"

describe ConfigLoader do
  let(:yaml_hash) { { "test" => { "key" => "value", "key2" => "value2" } } }
  subject { ConfigLoader.new("") }

  before { YAML.stub(load_file: yaml_hash) }

  describe "method_missing" do
    context "when called method name is in confing hash keys" do
      it "defines methods from keys from loaded hash" do
        expect(subject.key).to eq("value")
        expect(subject.key2).to eq("value2")
      end
    end

    context "when called method name is not in confing hash keys" do
      it "works like default method_missing, e.g. raises NoMethodError" do
        expect { subject.undefined_method }.to raise_error(NoMethodError, "undefined method `undefined_method' for #{subject}")
      end
    end
  end
end