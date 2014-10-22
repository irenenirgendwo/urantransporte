json.type "FeatureCollection"
json.features do
  json.array!(@schiffe) do |schiff|
    json.type "Feature"
    json.geometry do
      json.type "Point"
      json.coordinates do
        json.array! [schiff.current_lon, schiff.current_lat]
      end
    end
    json.properties do
      json.name schiff.name
    end
  end
end