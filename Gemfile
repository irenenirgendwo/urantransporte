source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# Rails Version
gem 'rails', '4.2.7'
# Use sqlite3 as the database for Active Record for test mode
#gem 'sqlite3'
# Use mysql as the database for Active Record for production mode
gem 'mysql2', '~> 0.3.18'

# Use SCSS for stylesheets (macht das verschachtelte Stylesheets moeglich sind)
gem 'sass-rails', '~> 5.0.3'
# Use Uglifier as compressor for JavaScript assets 
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views (fuer Coffeeskript schreiben koennen)
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library 
#(jquery macht das javascript abfragen von elementen ueber klassen und ids moeglich sind mit 
# z.B. $('.text') fuer alle Elemente mit Klasse 'text'
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. 
# Read more: https://github.com/rails/turbolinks 
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

#Leaflet zur Kartendarstellung
gem 'leaflet-rails',                    '~> 0.7.4'

#Bootstrap fürs Layout, verschiedene Bootstrap-Backete
gem 'bootstrap-sass',                   '~> 3.3.6'
# k.A.
gem 'momentjs-rails',                   '>= 2.8.1'
# fuer datetimepicker
gem 'bootstrap3-datetimepicker-rails',  '~> 3.1.3'
# zum Aufteilen auf mehrere Seiten (wenn z.B. Transportlisten zu lang sind)
gem 'will_paginate',                    '~> 3.0.7'
gem 'bootstrap-will_paginate',          '~> 0.0.10'

#Passwoerter verschluesseln koennen
gem 'bcrypt',                           '~> 3.1.10'

#Screen Scraping (kann html Seiten parsen und durchforsten)
gem 'nokogiri',                         '~> 1.6.3.1'

#PDF (kann pdfs lesen)
gem 'pdf-reader',                       '~> 1.3.3'

#Geokit für Ortssuche
gem 'geokit-rails',                     '~> 2.1.0'


group :development do
  gem "rails-erd"
  gem 'web-console',                    '~> 2.1.3'
end


group :test do
  # capybara ermoeglicht anwendungsbezogene tests zu schreiben, siehe integrations-tests
  gem "capybara"
  gem "launchy"
end
