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
        json.typ "Durchfahrtsort"
        json.newcolor '#ffffff'
      end
    end
  end
  json.array!(@strecken) do |strecke|
    ort1 = strecke[0]
    ort2= strecke[1]
    if ort1.lon && ort2.lon
      json.type "Feature"
      json.geometry do
        json.type "LineString"
        json.coordinates do
          json.array! [[ort1.lon, ort1.lat], [ort2.lon, ort2.lat]]
        end
      end
    end
  end
end
