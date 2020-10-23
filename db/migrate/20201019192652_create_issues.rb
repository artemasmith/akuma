class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string :title
      t.string :description
      t.string :issue_type
      t.integer :assignee_id
      t.string :creator
      t.string :aasm_state
      t.string :resolution
      t.integer :category_id

      t.timestamps
    end
  end
end
