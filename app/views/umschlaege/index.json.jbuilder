json.array!(@umschlaege) do |umschlag|
  json.extract! umschlag, :id
  json.url umschlag_url(umschlag, format: :json)
end
