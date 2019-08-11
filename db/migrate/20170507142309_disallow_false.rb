# frozen_string_literal: true

class DisallowFalse < ActiveRecord::Migration[5.1]
  class Composition < ApplicationRecord; end
  class Note < ApplicationRecord; end

  def change
    Note.destroy_all
    Voice.destroy_all
    Composition.destroy_all

    change_compositions
    change_notes
    change_voices
  end

  private

  def change_compositions
    change_column :compositions, :name, :string, null: false
    change_column :compositions, :key, :string, null: false, default: 'C major'
    change_column :compositions, :meter, :string, null: false, default: '4/4'
  end

  def change_notes
    change_column :notes, :voice_id, :bigint, null: false
    change_column :notes, :bar, :integer, null: false, default: 1
  end

  def change_voices
    change_column :voices, :composition_id, :bigint, null: false
    change_column :voices, :vertical_position, :integer, null: false, default: 1
    change_column :voices, :cantus_firmus, :boolean, null: false, default: false
    change_column :voices, :clef, :string, null: false, default: 'treble'
  end
end
