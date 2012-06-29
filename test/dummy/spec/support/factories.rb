require 'factory_girl'

# Train Logs
FactoryGirl.define do | f |
  factory :sample do 
    sequence(:description) { |n| "Description#{n}" }
    sequence(:title)       { |n| "Title#{n}" }
  end
end
