module GraphMapperRails
  class SettingLoader
    def initialize(klass)
      @klass = klass
      @record_hash = {}
      Setting.where(["key like ?", "#{klass}%"]).each do | record |
        @record_hash[record.key] = record
      end
    end

    def save
      @record_hash.each { | key, record | record.save if record.changed? }
    end

    def get_option(key)
      @record_hash[get_key(key)].try(:value)
    end

    def set_option(key, value)
      hash_key = get_key(key)

      @record_hash[hash_key] ||= Setting.new(:key => hash_key)
      @record_hash[hash_key].value = value
      @record_hash[hash_key].save
    end

    def remove_option(key)
      @record_hash[get_key(key)].delete
      @record_hash.delete(get_key(key))
    end

    def get_grouping_mapper_hash(record)
      h = get_hash(record)
      {:key => h[:keyword], :value => h[:value]}
    end

    def get_mapper_hash(record, filter_keyword)
      h = get_hash(record)
      value = h[:keyword].include?(filter_keyword) ? h[:value] : 0
      {:key => h[:date], :value => value }
    end


    def get_hash(record)
      case get_option("type").to_i
      when Setting::TYPE_SELECT_BY_FIELD
        get_hash_value_by_field(record)
      when Setting::TYPE_SELECT_BY_METHOD
        get_hash_value_by_method(record)
      else
        raise "invalid type"
      end
    end

  private
    def get_hash_value_by_field(record)
      date    = record.send(get_option("date"))
      value   = get_record_value(record, get_option("value"))
      keyword = get_record_keyword(record, get_option("keyword"))

      {:date => date, :value => value, :keyword => keyword }
    end

    def get_record_value(record, option)
      if option.empty?
        1
      else
        begin
          Integer(record.send(option))
        rescue
          1
        end
      end
    end

    def get_record_keyword(record, option)
      if option.empty?
        ""
      else
        record.send(option).to_s
      end
    end

    def get_hash_value_by_method(record)
      method_name = get_option("method")
      @klass.send(method_name, record)
    end

    def get_key(key)
      [@klass, key].join(".")
    end
  end
end
