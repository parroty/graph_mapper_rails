require 'factory_girl'

FactoryGirl.define do | f |
  factory :sample do 
    sequence(:description) { |n| "Description#{n}" }
    sequence(:title)       { |n| "Title#{n}" }
  end
end

FactoryGirl.define do | f |
  factory :setting, class: GraphMapperRails::Setting do
    sequence(:key)   { |n| "key#{n}" }
    sequence(:value) { |n| "value#{n}" }
  end
end