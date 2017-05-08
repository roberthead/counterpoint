require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  context 'when identity is known' do
    describe '#create' do
      let(:identity) { FactoryGirl.create(:identity) }
      let!(:composition) { FactoryGirl.create(:composition, identity: identity) }

      it 'creates a note' do
        expect {
          post :create, params: {note: {bar: 4, pitch: 90}}, session: {identity_id: identity.id}
        }.to change {
          composition.reload.notes.count
        }.by(1)
      end
    end
  end
end
