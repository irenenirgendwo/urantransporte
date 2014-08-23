json.array!(@atomanlages) do |atomanlage|
  json.extract! atomanlage, :id, :name, :description, :ort
  json.url atomanlage_url(atomanlage, format: :json)
end
