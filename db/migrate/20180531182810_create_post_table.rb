class CreatePostTable < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
          t.string :title
          t.integer :user_id
          t.string :date

      end
  end
end
