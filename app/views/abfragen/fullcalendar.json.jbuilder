json.array!(@transporte) do |transport|
  json.extract! transport, :id, :name, :adresse, :plz, :ort, :beschreibung
  json.url transport_url(transport, format: :json)
end
