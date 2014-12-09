json.type "FeatureCollection"
json.features do
  json.array!(@orte) do |ort|
    if ort.lon
      json.type "Feature"
      json.geometry do
        json.type "Point"
        json.coordinates do
          json.array! [ort.lon, ort.lat]
        end
      end
      json.properties do
        json.name ort.name
      end
    end
  end
end
