json.array!(@durchfahrtsorte) do |durchfahrtsort|
  json.extract! durchfahrtsort, :id, :index
  json.url durchfahrtsort_url(durchfahrtsort, format: :json)
end
