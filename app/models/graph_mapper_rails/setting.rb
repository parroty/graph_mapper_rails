module GraphMapperRails
  class Setting < ActiveRecord::Base
    attr_accessible :key, :value, :tags_attribute
  end
end
