class CreateGraphMapperRailsSettings < ActiveRecord::Migration
  def change
    create_table :graph_mapper_rails_settings do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
