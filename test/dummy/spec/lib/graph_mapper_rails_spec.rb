require 'spec_helper'

describe GraphMapperRails::Initializer do
  it "should setup" do
    GraphMapperRails::Initializer.setup do | config |
      config.class.should == GraphMapperRails::Config
    end
  end
end