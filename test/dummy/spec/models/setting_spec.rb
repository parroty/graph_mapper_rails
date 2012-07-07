require 'spec_helper'

module GraphMapperRails

describe "Setting" do
  context "options" do
    it "gets key value (exists)" do
      FactoryGirl.create(:setting, :key => "Sample.key", :value => "title")
      Setting.get_option("Sample.key").should == "title"
    end

    it "gets key value (doesn't exist)" do
      Setting.get_option("Sample.key").should == nil
    end

    it "sets key value" do
      Setting.set_option("Sample.key", "value")
      Setting.get_option("Sample.key").should == "value"
    end

    it "updates key value" do
      FactoryGirl.create(:setting, :key => "Sample.key", :value => "title")
      Setting.set_option("Sample.key", "updated")
      Setting.get_option("Sample.key").should == "updated"
    end

    it "deletes key value" do
      FactoryGirl.create(:setting, :key => "Sample.key", :value => "title")
      Setting.remove_option("Sample.key")
      Setting.get_option("Sample.key").should == nil
    end
  end
end

end
