# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  context 'when identity is known' do
    describe '#create' do
      let(:identity) { FactoryGirl.create(:identity) }
      let!(:composition) { FactoryGirl.create(:composition, identity: identity) }

      it 'creates a note' do
        expect do
          post :create, params: { note: { voice_id: composition.cantus_firmus.id, bar: 4, pitch: 90 } }, session: { identity_id: identity.id }
        end.to change {
          composition.reload.notes.count
        }.by(1)
      end
    end
  end
end
