require "graph_mapper_rails/engine"
require 'setting_loader'

module GraphMapperRails
  class Initializer
    def self.setup
      @@config = Config.new
      yield @@config
    end

    def self.config
      @@config
    end
  end

  class GroupingMapper
    def initialize(config)
      @config = config
    end

    def set_mapper(&block)
      @block = block
    end

    def get_mapper
      loader  = SettingLoader.new(@config.mapper_klass)
      manager = @config.mapper_klass.find(:all, @conditions)

      GraphMapper::GroupingMapper.new(manager) do | record |
        loader.get_grouping_mapper_hash(record)
      end
    end
  end

  class DateMapper
    def initialize(config)
      @config = config
    end

    def set_mapper(&block)
      @block = block
    end

    def get_mapper(keyword = nil)
      loader  = SettingLoader.new(@config.mapper_klass)
      manager = @config.mapper_klass.find(:all, @conditions)

      GraphMapper::Mapper.new(manager, Date.today - @config.duration, Date.today, @config.option_mapper.to_hash) do | record |
        loader.get_mapper_hash(record, keyword)
      end
    end
  end

  class Config
    attr_accessor :mapper_klass, :conditions, :duration, :use_average, :colors, :highcharts_js_path, :option_mapper
    attr_accessor :grouping, :date

    def initialize
      @highcharts_js_path = "graph_mapper_rails/highcharts.js"
      @duration           = 1.month
      @grouping           = GroupingMapper.new(self)
      @date               = DateMapper.new(self)
    end

    def set_options(&block)
      @option_mapper = OptionMapper.new
      yield @option_mapper
    end

    def get_options
      @option_mapper.to_hash
    end
  end

  class OptionMapper
    attr_accessor :span_type, :date_format, :moving_average_length

    def to_hash
      { :span_type => @span_type, :date_format => @date_format,
        :moving_average_length => @moving_average_length }
    end
  end

  class RecordMapper
    attr_accessor :keyword, :key, :num

    def to_hash
      { :key => @key, :value => @num || 0 }
    end
  end
end
