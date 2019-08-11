# frozen_string_literal: true

class AddIdentityToCompositions < ActiveRecord::Migration[5.1]
  def change
    add_reference :compositions, :identity, foreign_key: true
  end
end
