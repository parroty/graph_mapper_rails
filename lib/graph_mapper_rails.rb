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
      option_mapper = OptionMapper.new
      yield option_mapper
      @options = option_mapper.hash
    end

    def set_mapper(&block)
      @block = block
    end

    def mapper(keyword = nil)
      manager = @klass.all

      GraphMapper::Mapper.new(manager, DateTime.now - @duration, DateTime.now, @options) do | record |
        record_mapper = RecordMapper.new
        record_mapper.keyword = keyword
        @block.call(record_mapper, record)
        record_mapper.hash
      end
    end

    def moving_average_length
      @options[:moving_average_length]
    end
  end

  class OptionMapper
    def initialize
      @hash = Hash.new
    end

    def span_type=(span_type)
      @hash[:span_type] = span_type
    end

    def date_format=(date_format)
      @hash[:date_format] = date_format
    end

    def moving_average_length=(length)
      @hash[:moving_average_length] = length
    end

    def hash
      @hash
    end
  end

  class RecordMapper
    attr_accessor :keyword, :key, :num

    def hash
      @hash = Hash.new
      @hash[:key]   = @key
      @hash[:value] = @num || 0
      @hash
    end
  end
end
