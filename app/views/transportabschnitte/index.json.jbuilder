json.array!(@transportabschnitte) do |transportabschnitt|
  json.extract! transportabschnitt, :id
  json.url transportabschnitt_url(transportabschnitt, format: :json)
end
