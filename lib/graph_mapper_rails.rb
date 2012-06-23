require "graph_mapper_rails/engine"

module GraphMapperRails
  class Initializer
    def self.setup
      yield self
    end

    def self.set_class(klass)
      @@klass ||= klass
    end
    
    def self.set_options(&block)
      option_mapper = OptionMapper.new
      yield option_mapper
      @@options = option_mapper.hash
    end
    
    def self.set_duration(duration)
      @@duration = duration
    end
    
    def self.set_mapper(&block)
      @@block = block
    end

    def self.mapper
      manager = @@klass.all

      record_mapper = RecordMapper.new
      GraphMapper::Mapper.new(manager, DateTime.now - @@duration, DateTime.now, @@options) do | record |
        @@block.call(record_mapper, record)
        record_mapper.hash
      end
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
    
    def hash
      @hash
    end
  end
  
  class RecordMapper
    def initialize
      @hash = Hash.new
    end

    def key=(key)
      @hash[:key] = key
    end
    
    def num=(num)
      @hash[:value] = num
    end

    def hash
      @hash
    end
  end
end
