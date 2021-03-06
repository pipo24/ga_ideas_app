class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :dob, :date
    add_column :users, :role, :string
    add_column :users, :gender, :string
    add_column :users, :image, :text
    add_column :users, :nationality, :string
    add_column :users, :location, :string
  end
end
