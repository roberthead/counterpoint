class SandboxesController < ApplicationController
  before_action :ensure_authentication!

  class SandboxView
    include ActiveModel::Model

    attr_accessor :composition

    delegate :name, :voices, :cantus_firmus, :highest_bar, :key_signature, to: :composition
  end

  def show
    @sandbox ||= SandboxView.new(composition: ensure_composition)
  end

  private

  def ensure_composition
    @composition ||= current_identity.composition || Composition.create(identity: current_identity, name: t('compositions.default_name', user_name: current_identity.name))
  end
end
