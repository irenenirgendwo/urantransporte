          
function geomap(typ){          
          var lat, lon;
          if(document.getElementById(typ+'_lat').value) {
            lat = document.getElementById(typ+'_lat').value;
            lon = document.getElementById(typ+'_lon').value;
          }
          else {
            lat = 52.2152;
            lon = 7.0793
          }
          var map = L.map('map', {attributionControl: false}).setView([lat, lon], 7);
          var marker = L.marker([lat, lon]).addTo(map);
          L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
          map.on('click', function(e) {
            marker.setLatLng(e.latlng);
            map.panTo(e.latlng);
            
            document.getElementById(typ+'_lat').value = e.latlng.lat.toFixed(6);
            document.getElementById(typ+'_lon').value = e.latlng.lng.toFixed(6);
          });
}

function schiffMap(lat, lon, rot){
  var map = L.map('map', {attributionControl: false}).setView([lat, lon], 6);
  L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
  var marker = new L.marker([lat, lon]);
  marker.addTo(map);

};

function allSchiffMap() {
  $.getJSON("/schiffe.json", function(data) {
    var geojson = L.geoJson(data, {
      onEachFeature: function (feature, layer) {
        layer.bindPopup(feature.properties.name);
      }
    });
    var map = L.map('map', {attributionControl: false}).fitBounds(geojson.getBounds());
    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
    geojson.addTo(map);
  });
}