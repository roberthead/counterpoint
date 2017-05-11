class RenameKeyOnCompositions < ActiveRecord::Migration[5.1]
  def change
    rename_column :compositions, :key, :key_signature
  end
end
