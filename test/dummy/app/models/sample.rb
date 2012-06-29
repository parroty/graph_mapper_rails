class Sample < ActiveRecord::Base
  attr_accessible :description, :title

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

end
