# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :signature, null: false
      t.text :full_name, null: false
      t.string :password_digest, null: false
      t.text :selected_news, array: true, default: []
      t.text :readed_news, array: true, default: []

      t.timestamps null: false
    end
  end
end
