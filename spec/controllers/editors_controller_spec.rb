require 'rails_helper'

RSpec.describe EditorsController, type: :controller do
  describe "GET #show" do
    context 'when composition id is valid' do
      let(:composition) { FactoryGirl.create(:composition) }

      it "returns http success" do
        get :show, params: { composition_id: composition.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when composition id is not valid' do
      it "returns http success" do
        expect {
          get :show, params: { composition_id: -1 }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
