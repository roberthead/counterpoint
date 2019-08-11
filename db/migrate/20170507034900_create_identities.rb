# frozen_string_literal: true

class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :name, default: ''
      t.string :oauth_token, null: false
      t.datetime :oauth_expires_at, null: false

      t.timestamps
    end
  end
end
