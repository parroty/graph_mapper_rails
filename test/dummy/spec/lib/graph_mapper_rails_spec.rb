require 'spec_helper'

module GraphMapperRails
  describe GraphMapperRails do
    context "Initializer" do
      it "invokes setup" do
        Initializer.setup do | config |
          config.class.should == Config
        end
      end

      it "invokes config" do
        Initializer.config.should_not be_nil
      end
    end

    context "Config" do
      it "invoke initialize" do
        Config.new.highcharts_js_path.should == "graph_mapper_rails/highcharts.js"
      end

      # TODO : fix spec file
      it "invoke get_mapper" do
        3.times { FactoryGirl.create(:sample) }

        Initializer.setup do |config|
          config.mapper_klass = Sample
          config.date.set_mapper do | mapper, record |
            mapper.key = record.created_at
            mapper.num = 1
          end

          config.set_options do | options |
            options.span_type   = GraphMapper::SPAN_WEEKLY
            options.date_format = "%-m/%-d"
            options.moving_average_length = 2
          end

          config.use_average = true
          config.duration = 3.months
        end

        # Initializer.config.date.get_mapper("test").should_not be_nil
      end
    end
  end
end
