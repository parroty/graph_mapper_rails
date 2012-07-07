GraphMapperRails::Initializer.setup do |config|
  config.mapper_klass = Sample

  # config.date.set_mapper do | mapper, record |
  #  mapper.key = record.created_at
  #  mapper.num = 1 if record.title.include?(mapper.keyword)
  # end

  # config.grouping.set_mapper do | mapper, record |
  #   mapper.key = record.title
  #  mapper.num = 1
  #end

  config.set_options do | options |
    options.span_type   = GraphMapper::SPAN_WEEKLY
    options.date_format = "%-m/%-d"
    options.moving_average_length = 2
  end

  config.use_average = true
  config.duration = 3.months

  config.colors = {
    :line => 'red',
    :average => 'blue',
    :moving_average => 'orange'
  }

end
