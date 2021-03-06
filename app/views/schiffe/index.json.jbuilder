json.type "FeatureCollection"
json.features do
  json.array!(@schiffe) do |schiff|
    if schiff.current_lon 
      json.type "Feature"
      json.geometry do
        json.type "Point"
        json.coordinates do
          json.array! [schiff.current_lon, schiff.current_lat]
        end
      end
      json.properties do
        json.typ schiff.name
        json.name "Reederei #{schiff.firma.name}"
      end
    end
  end
end
