class CreateCompositions < ActiveRecord::Migration[5.1]
  def change
    create_table :compositions do |t|
      t.string :name
      t.string :key_signature
      t.string :meter

      t.timestamps
    end
  end
end
