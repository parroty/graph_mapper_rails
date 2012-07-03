class AddNumberToSample < ActiveRecord::Migration
  def change
    add_column :samples, :value, :integer
  end
end
