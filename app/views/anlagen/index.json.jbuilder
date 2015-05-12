json.array!(@anlagen) do |anlage|
  json.extract! anlage, :id, :datum
  json.url anlage_url(anlage, format: :json)
end
