class CompositionsController < ApplicationController
  def index
    @compositions = Composition.order('updated_at DESC')
  end

  def new
    @composition = Composition.new(name: 'Counterpoint', key: 'C major', meter: '4/4')
  end

  def create
    @composition = Composition.new(composition_params)
    if @composition.save
      redirect_to @composition
    else
      render :new
    end
  end

  def show
    @composition = Composition.find(params[:id])
  end

  def edit
    @composition = Composition.find(params[:id])
  end

  def update
    @composition = Composition.find(params[:id])
    @composition.update_attributes(composition_params)
    redirect_to @composition
  end

  def destroy
    @composition = Composition.find(params[:id])
    @composition.destroy
    redirect_to compositions_path
  end

  private

  def composition_params
    params.require(:composition).permit(:name, :key, :meter)
  end
end
