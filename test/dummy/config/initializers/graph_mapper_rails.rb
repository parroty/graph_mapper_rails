GraphMapperRails::Initializer.setup do |config|
  config.mapper_klass = Sample

  config.use_average = true

  config.colors = {
    :line => 'red',
    :average => 'blue',
    :moving_average => 'orange'
  }

end
