require 'rails_helper'

RSpec.describe CompositionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    it "returns http success" do
      post :create, params: {composition: {name: 'Foo', key_signature: 'Eb Major', meter: '7/8'}}
      expect(response).to have_http_status(:redirect)
    end

    it "creates a record" do
      expect {
        post :create, params: {composition: {name: 'Foo', key_signature: 'Eb Major', meter: '7/8'}}
      }.to change {
        Composition.count
      }.by(1)
    end
  end

  describe "GET #edit" do
    subject(:composition) { Composition.create(name: 'Foo', key_signature: 'Eb Major', meter: '7/8') }

    it "returns http success" do
      get :edit, params: {id: composition.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    subject(:composition) { Composition.create(name: 'Foo', key_signature: 'Eb Major', meter: '7/8') }

    it "returns http success" do
      patch :update, params: {id: composition.id, composition: {name: 'Foo Fighter', key_signature: 'E Major', meter: '4/4'}}
      expect(response).to have_http_status(:redirect)
    end

    it "changes the values" do
      expect {
        patch :update, params: {id: composition.id, composition: {name: 'Foo Fighter', key_signature: 'E Major', meter: '4/4'}}
      }.to change {
        composition.reload.name
      }.from('Foo').to('Foo Fighter')
    end
  end

  describe "GET #destroy" do
    subject(:composition) { Composition.create(name: 'Foo', key_signature: 'Eb Major', meter: '7/8') }

    it "returns http success" do
      get :destroy, params: {id: composition.id}
      expect(response).to redirect_to(compositions_url)
    end
  end
end
