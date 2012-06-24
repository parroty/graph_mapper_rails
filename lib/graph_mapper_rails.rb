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
    attr_accessor :klass, :duration, :use_average, :colors

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
      manager = @klass.all

      GraphMapper::Mapper.new(manager, DateTime.now - @duration, DateTime.now, @option_mapper.to_hash) do | record |
        record_mapper = RecordMapper.new
        record_mapper.keyword = keyword
        @block.call(record_mapper, record)
        record_mapper.to_hash
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
