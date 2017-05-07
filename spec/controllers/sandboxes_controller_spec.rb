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
      let(:identity) { FactoryGirl.create(:identity) }

      it 'responds successfully' do
        get :show, params: {}, session: {identity_id: identity.id}
        expect(response).to be_success
      end
    end
  end
end
