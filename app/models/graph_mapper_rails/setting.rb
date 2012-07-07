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

  private
    def self.find_by_key(klass, key)
      Setting.where(["key = ?", get_key(klass, key)]).first
    end

    def self.get_key(klass, key)
      [klass, key].join(".")
    end
  end
end
