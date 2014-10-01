class AbfragenController < ApplicationController
  def index
    @stoff_auswahl = Stoff.get_stoffe_for_selection_field
    @start_anlagen = Anlage.get_anlagen_for_selection_field
    @ziel_anlagen = @start_anlagen
  end

  def show
  end

  def calendar
  end
end
