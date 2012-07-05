module GraphMapperRails
  class Setting < ActiveRecord::Base
    attr_accessible :key, :value, :tags_attribute

    def self.get_option(klass, key)
      Setting.find(:first, :conditions => ["key = ?", [klass.to_s, key].join(".")]).try(:value)
    end

    def self.set_option(klass, key, value)
      record = Setting.find_or_create_by_key([klass.to_s, key].join("."))
      record.value = value
      record.save
    end
  end
end
