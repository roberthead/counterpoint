# frozen_string_literal: true

class CreateVoices < ActiveRecord::Migration[5.1]
  def change
    create_table :voices do |t|
      t.belongs_to :composition, foreign_key: true
      t.integer :vertical_position, default: 1, null: false
      t.boolean :cantus_firmus, default: false, null: false
      t.string :clef, default: 'treble', null: false

      t.timestamps
    end
  end
end
