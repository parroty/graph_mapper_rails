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
      @record_hash.each { | key, record | record.save }
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
      type = get_option("type").to_i
      if type == 0
        date = record.send(get_option("date"))
        if get_option("value").empty?
          value = 1
        else
          value = record.send(get_option("value"))
        end
        if get_option("keyword").empty?
          keyword = ""
        else
          keyword = record.send(get_option("keyword"))
        end

        {:date => date, :value => value || 0, :keyword => keyword }
      elsif type == 1
        @klass.send(get_option("method"), record)
      else
        raise "invalid type"
      end
    end

  private
    def get_key(key)
      [@klass, key].join(".")
    end
  end
end
