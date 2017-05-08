require 'rails_helper'

RSpec.describe SandboxesController, type: :controller do
  describe 'GET #show' do
    context 'when the user is not identified' do
      it 'redirects to sign in' do
        get :show
        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end

    context 'when an identity is signed in' do
      let(:identity) { FactoryGirl.create(:identity, name: "Sarah O'Reilly") }

      def make_request(identity_id)
        get :show, params: {}, session: {identity_id: identity_id}
      end

      it 'responds successfully' do
        make_request(identity.id)
        expect(response).to be_success
      end

      describe 'view object' do
        context 'and that identity does not have an existing composition' do
          it 'creates a new composition' do
            make_request(identity.id)
            expect(assigns(:sandbox).name).to eq "Sarah O'Reilly's Counterpoint"
          end
        end

        context 'and that identity has an existing composition' do
          let!(:composition) { FactoryGirl.create(:composition, identity: identity) }

          it 'assigns that composition' do
            make_request(identity.id)
            expect(assigns(:sandbox).composition).to eq composition
          end
        end
      end
    end
  end
end
