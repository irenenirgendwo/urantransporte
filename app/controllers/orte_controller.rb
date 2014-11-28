class OrteController < ApplicationController
  def show
    @ort = Ort.find(params[:id])
  end
end
