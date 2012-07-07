module GraphMapperRails
  class Setting < ActiveRecord::Base
    attr_accessible :key, :value, :tags_attribute

    def self.get_option(key)
      find_by_key(key).try(:value)
    end

    def self.set_option(key, value)
      record = Setting.find_or_create_by_key(key)
      record.value = value
      record.save
    end

    def self.remove_option(key)
      find_by_key(key).try(:destroy)
    end

  private
    def self.find_by_key(key)
      Setting.where(["key = ?", key]).first
    end
  end
end
