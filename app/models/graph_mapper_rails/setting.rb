module GraphMapperRails
  class Setting < ActiveRecord::Base
    attr_accessible :key, :value, :tags_attribute

    TYPE_SELECT_BY_FIELD  = 0
    TYPE_SELECT_BY_METHOD = 1
  end
end
