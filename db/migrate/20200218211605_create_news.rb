# frozen_string_literal: true

class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.belongs_to :user
      t.text :header, null: false
      t.text :announcement, null: false
      t.text :text, null: false
      t.text :status, null: false, default: 'unpublished'

      t.timestamps null: false
    end
  end
end
