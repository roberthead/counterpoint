# frozen_string_literal: true

class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.belongs_to :voice, foreign_key: true
      t.integer :bar
      t.string :pitch

      t.timestamps
    end
  end
end
