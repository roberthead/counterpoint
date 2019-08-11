# frozen_string_literal: true

class CreateCompositions < ActiveRecord::Migration[5.1]
  def change
    create_table :compositions do |t|
      t.string :name
      t.string :key, default: 'C major', null: false
      t.string :meter, default: '4/4', null: false

      t.timestamps
    end
  end
end
