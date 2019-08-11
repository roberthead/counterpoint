# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompositionsController, type: :controller do
  describe 'PATCH #update' do
    context 'when the user is not identified' do
      it 'redirects to sign in' do
        patch(:update, params: {})
        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end

    context 'when an identity is signed in' do
      let(:identity) { FactoryGirl.create(:identity) }
      let(:session) { { identity_id: identity.id } }

      context 'when the composition exists' do
        let(:params) { { id: composition.id, composition: { key_signature: 'D dorian' } } }

        context 'when the composition belongs to the current identity' do
          let(:composition) { FactoryGirl.create(:composition, identity: identity) }

          it 'updates the record' do
            expect do
              patch(:update, params: params, session: session)
            end.to change {
              composition.reload.key_signature
            }.from('C major').to('D dorian')
          end
        end

        context 'when the composition does not belong to the current identity' do
          let(:composition) { FactoryGirl.create(:composition) }

          it 'blows up' do
            expect do
              patch(:update, params: params, session: session)
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end

      context 'when the composition does not exist' do
        let(:params) { { id: -1, composition: { key_signature: 'D dorian' } } }

        it 'blows up' do
          expect do
            patch(:update, params: params, session: session)
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
