class AddIdentityToCompositions < ActiveRecord::Migration[5.1]
  def change
    add_reference :compositions, :identity, foreign_key: true, null: false
  end
end
