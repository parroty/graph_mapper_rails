require 'spec_helper'

module GraphMapperRails

describe "Setting" do
  context "options" do
    it "gets key value" do
      FactoryGirl.create(:setting, :key => "Sample.key", :value => "title")
      Setting.get_option(Sample, :key).should == "title"
    end

    it "sets key value" do
      Setting.set_option(Sample, :key, "value")
      Setting.get_option(Sample, :key).should == "value"
    end

    it "update key value" do
      FactoryGirl.create(:setting, :key => "Sample.key", :value => "title")
      Setting.set_option(Sample, :key, "updated")
      Setting.get_option(Sample, :key).should == "updated"
    end
  end
end

end
