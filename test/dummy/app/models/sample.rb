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

  def self.mapper_hash(record, keyword)
    key   = record.created_at
    value = record.value if record.title.include?(keyword)
    {:key => key, :value => value || 0 }
  end

  def self.grouping_mapper_hash(record, keyword)
    key   = record.created_at
    value = 1 if record.title.include?(mapper.keyword)
    {:key => key, :value => value || 0 }
  end

end
