# encoding: utf-8
class SchiffeController < ApplicationController
  before_action :set_schiff, only: [:show, :edit, :update, :destroy]
  before_action :get_reedereien, only: [:index, :edit, :update, :new]
  before_action :editor_user
  
  def index
    @schiffe = Schiff.order(:name)
    @firma_unbekannt = Firma.find_by(name: "Unbekannt")
    @ohne_reederei = Schiff.where(firma_id: [nil, (@firma_unbekannt.nil? ? nil: @firma_unbekannt.id)])
    @schiffe.each do |schiff|
      schiff.storePosition
    end
  end
  
  def show
    @schiff.storePosition
  end
  
  # GET /anlagen/new
  def new
    @schiff= Schiff.new
  end
  
  def edit
  end
  
  # POST /anlagen
  def create
    @schiff = Schiff.new(schiff_params)
    
    if @schiff.save
      @schiff.storePosition
      redirect_to @schiff
    else
      render :new
    end
  end
  
  def update
    if @schiff.update(schiff_params)
      @schiff.storePosition
      redirect_to @schiff
    else
      render :edit
    end
  end
  
  def destroy
    @schiff.destroy
    redirect_to schiffe_url
  end
  
  def read_schedules
  end
  
  def readMacs
    Schiff.getMacsSchedule
    redirect_to schiffe_url, flash: { success: 'Fahrplandaten erfolgreich eingelesen.' }
  end
  
  private
  
    def schiff_params
      params.require(:schiff).permit(:name, :imo, :vesselfinder_url, :bild_url, :bild_urheber, :firma, :firma_id)
    end
    
    def set_schiff
      @schiff = Schiff.find(params[:id])
    end
    
    def get_reedereien
      @reedereien = Firma.where(:reederei =>  true)
    end
end
