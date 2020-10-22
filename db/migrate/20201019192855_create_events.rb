class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :source_cls
      t.integer :source_id
      t.string :action
      t.json :options
      t.string :type

      t.timestamps
    end
  end
end
