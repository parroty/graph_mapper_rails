module GraphMapperRails
  class Setting < ActiveRecord::Base
    attr_accessible :key, :value, :tags_attribute

    def self.get_option(klass, key)
      find_by_key(klass, key).try(:value)
    end

    def self.set_option(klass, key, value)
      record = Setting.find_or_create_by_key(get_key(klass, key))
      record.value = value
      record.save
    end

    def self.remove_option(klass, key)
      find_by_key(klass, key).try(:destroy)
    end

    def self.get_mapper_hash(klass, record, filter_keyword)
      type = get_option(klass, "type").to_i
      if type == 0
        date    = record.send(get_option(klass, "key"))
        keyword = record.send(get_option(klass, "keyword"))
        if keyword.include?(filter_keyword)
          value = record.send(get_option(klass, "value"))
        else
          value = 0
        end
        {:key => date, :value => value || 0 }
      elsif type == 1
        klass.send(get_option(klass, "method"), record, filter_keyword)
      else
        raise "invalid type"
      end
    end

  private
    def self.find_by_key(klass, key)
      Setting.where(["key = ?", get_key(klass, key)]).first
    end

    def self.get_key(klass, key)
      [klass, key].join(".")
    end
  end
end
