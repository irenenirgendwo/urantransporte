json.array!(@transporte) do |transport|
  json.extract! transport, :id, :menge, :stoff, :behaeltertyp, :start, :ziel
  json.url transport_url(transport, format: :json)
end
