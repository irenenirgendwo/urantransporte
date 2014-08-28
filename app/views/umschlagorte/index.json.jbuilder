json.array!(@umschlagorte) do |umschlagort|
  json.extract! umschlagort, :id, :ortsname
  json.url umschlagort_url(umschlagort, format: :json)
end
