class SandboxesController < ApplicationController
  before_action :ensure_authentication!
  before_action :ensure_composition

  def show
  end

  private

  def ensure_composition
    @composition ||= current_identity.composition || Composition.create(identity: current_identity, name: t('compositions.default_name', user_name: current_identity.name))
  end
end
