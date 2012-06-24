require "graph_mapper_rails/engine"

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

  class Config
    attr_accessor :klass, :conditions, :duration, :use_average, :colors, :highcharts_js_path

    def initialize
      @highcharts_js_path = "graph_mapper_rails/highcharts.js"
    end

    def set_options(&block)
      @option_mapper = OptionMapper.new
      yield @option_mapper
    end

    def get_options
      @option_mapper.to_hash
    end

    def set_mapper(&block)
      @block = block
    end

    def get_mapper(keyword = nil)
      manager = @klass.find(:all, @conditions)

      GraphMapper::Mapper.new(manager, DateTime.now - @duration, DateTime.now, @option_mapper.to_hash) do | record |
        rm = RecordMapper.new
        rm.keyword = keyword
        @block.call(rm, record)
        rm.to_hash
      end
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
