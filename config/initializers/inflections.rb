# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'anlage', 'anlagen'
  inflect.irregular 'anlagen_kategorie', 'anlagen_kategorien'
  inflect.irregular 'beobachtung', 'beobachtungen'
  inflect.irregular 'firma', 'firmen'
  inflect.irregular 'genehmigung', 'genehmigungen'
  inflect.irregular 'kategorie', 'kategorien'
  inflect.irregular 'ort', 'orte'
  inflect.irregular 'schiff', 'schiffe'
  inflect.irregular 'stoff', 'stoffe'
  inflect.irregular 'transport', 'transporte'
  inflect.irregular 'transportabschnitt', 'transportabschnitte'
  inflect.irregular 'umschlag', 'umschlaege'
  inflect.irregular 'umschlagort', 'umschlagorte'
  inflect.irregular 'versandstueck', 'versandstuecke' 
  inflect.irregular 'route', 'routen'
end
