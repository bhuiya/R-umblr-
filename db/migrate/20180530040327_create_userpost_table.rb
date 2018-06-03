class CreateUserpostTable < ActiveRecord::Migration[5.2]
  def change
    create_table :userposts do |t|
          t.string :title
          t.string :catagory
          t.string :description
          t.integer :user_id
      end
  end
end
