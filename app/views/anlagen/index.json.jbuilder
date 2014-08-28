json.array!(@anlagen) do |anlage|
  json.extract! anlage, :id, :name, :adresse, :plz, :ort, :beschreibung
  json.url anlage_url(anlage, format: :json)
end
