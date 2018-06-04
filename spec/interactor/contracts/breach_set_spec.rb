require "spec_helper"

RSpec.describe Interactor::Contracts::BreachSet do
  describe "#to_hash" do
    it "combines and squashes repeat values in the result" do
      breach = lambda do |property, messages|
        Interactor::Contracts::Breach.new(property, messages)
      end

      breaches = [
        breach.call(:first_name, ["first"]),
        breach.call(:first_name, %w(second third)),
        breach.call(:last_name, ["last_name is missing"]),
        breach.call(:address, "line_1" => "line 1 is missing"),
      ]

      set = Interactor::Contracts::BreachSet.new(breaches)

      result = set.to_hash

      expect(result[:errors][:first_name]).to eq(%w(first second third))
      expect(result[:errors][:last_name]).to eq(["last_name is missing"])
      expect(result[:errors][:address]).to eq("line_1" => "line 1 is missing")
    end
  end
end
