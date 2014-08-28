json.array!(@beobachtungen) do |beobachtung|
  json.extract! beobachtung, :id, :beschreibung
  json.url beobachtung_url(beobachtung, format: :json)
end
