          
function geomap(typ, map_id='map'){
    var lat, lon, lat_name, lon_name;
    if (typ == "ort") {
      lat_name = 'lat'
      lon_name = 'lon'
    }
    else  {
      if (typ == "ort_direkt"){
        lat_name = 'ort_lat';
        lon_name = 'ort_lon';
      } else {
        lat_name = typ + '_lat'
        lon_name = typ + '_lon'
      }
    }
    
    if(document.getElementById(lat_name).value) {
      lat = document.getElementById(lat_name).value;
      lon = document.getElementById(lon_name).value;
    }
    else {
      lat = 52.2152;
      lon = 7.0793
    }

    var map = L.map(map_id, {attributionControl: false}).setView([lat, lon], 7);
    var marker = L.marker([lat, lon]).addTo(map);
    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
    map.on('click', function(e) {
      marker.setLatLng(e.latlng);
      map.panTo(e.latlng);
      
      document.getElementById(lat_name).value = e.latlng.lat.toFixed(6);
      document.getElementById(lon_name).value = e.latlng.lng.toFixed(6);
    });
}

function schiffMap(lat, lon, rot){
  var map = L.map('map', {attributionControl: false}).setView([lat, lon], 6);
  L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
  var marker = new L.marker([lat, lon]);
  marker.addTo(map);

};

function allOrteMap(typ) {
  $.getJSON("/"+typ+".json", function(data) {
    var geojson = L.geoJson(data, {
      onEachFeature: function (feature, layer) {
        if (feature.geometry.type == 'Point') {
          layer.bindPopup('<strong>' + feature.properties.typ +'</strong><br />' + feature.properties.name);
        }
      }
      //hat keinen Effekt 
      /*style: function(feature) {
        if (feature.geometry.type == 'Point') {
        //switch (feature.properties.typ) {
        //    case 'Start-Anlage': return {color: "#ff0000", weight: 5};
        //    case 'Ziel-Anlage':  return {color: "#0000ff"};
        //}
          return {color: "#0000ff"};
        }
      }
      //style: myStyle*/
    });
    
    var map = L.map('map', {attributionControl: false}).fitBounds(geojson.getBounds());
    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
    geojson.addTo(map);
  });
}
