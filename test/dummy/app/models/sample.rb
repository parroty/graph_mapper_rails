class Sample < ActiveRecord::Base
  attr_accessible :description, :title, :value

  def self.from_graph_mapper_keywords
    ["aaa", "title", "hoge"]
  end

  def self.from_graph_mapper_series(keyword, length)
    {
      :name  => "estimate",
      :data  => [[0, 3],[length - 1, 3]],
      :color => "green"
    }
  end

  def self.mapper_hash(record)
    date    = record.created_at
    value   = record.value
    keyword = record.title
    {:date => date, :value => value || 0, :keyword => keyword }
  end
end
