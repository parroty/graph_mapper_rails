GraphMapperRails::Engine.routes.draw do
  root :to => "graph#index"

  controller :graph do
    list =  %w{ setting update_setting }
    for page in list
      match page, :action => page, :as => "graph_#{page}"
    end
  end
end
