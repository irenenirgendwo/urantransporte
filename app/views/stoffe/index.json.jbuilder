json.array!(@stoffe) do |stoff|
  json.extract! stoff, :id, :bezeichnung, :beschreibung, :un_nummer, :gefahr_nummer
  json.url stoff_url(stoff, format: :json)
end
