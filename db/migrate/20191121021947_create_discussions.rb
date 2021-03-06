class CreateDiscussions < ActiveRecord::Migration[6.0]
  def change
    create_table :discussions do |t|
      t.references :course
      t.string :discussion_id
      t.string :discussion_name
      t.string :discussion_administrator
      t.string :initial_post
      t.integer :creater_id, null:false
      t.timestamps
    end
  end
end
