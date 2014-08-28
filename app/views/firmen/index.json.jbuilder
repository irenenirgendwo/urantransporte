json.array!(@firmen) do |firma|
  json.extract! firma, :id, :name, :adresse, :plz, :ort, :beschreibung
  json.url firma_url(firma, format: :json)
end
