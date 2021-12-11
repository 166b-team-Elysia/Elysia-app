import { Loader } from '@googlemaps/js-api-loader';
// import MarkerClusterer from '@googlemaps/markerclustererplus';

const loader = new Loader({
  apiKey: "AIzaSyAvwMrjYJ-pgIW-gEaxSQFkIqEPvwnNyQI",
  version: "weekly",
  libraries: ["places"]
});

const mapOptions = {
  center: {
    lat:  42.376,
    lng:  -71.235
  },
  zoom: 15
};
let map 

loader.load().then(() => {
  if($("#map").length) {
    return;
  }
  map = new google.maps.Map(document.getElementById("map"), mapOptions);
  let infoWindow = new google.maps.InfoWindow();

  let datas = JSON.parse($('.store-locations').attr('data'))
  $.each(datas, function(i, val) {
    const marker = new google.maps.Marker({
      position: val,
      map: map,
    });
  });

  // new MarkerClusterer({ markers, map });

  const locationButton = document.createElement("button");
  const script = document.createElement("script");

  locationButton.textContent = "Pan to Current Location";
  locationButton.classList.add("custom-map-control-button");
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(locationButton);
  locationButton.addEventListener("click", () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };

          infoWindow.setPosition(pos);
          infoWindow.setContent("Location found.");
          infoWindow.open(map);
          map.setCenter(pos);
        },
        () => {
          handleLocationError(true, infoWindow, map.getCenter());
        }
      );
    } else {
      // Browser doesn't support Geolocation
      handleLocationError(false, infoWindow, map.getCenter());
    }
  });
});
function handleLocationError(browserHasGeolocation, infoWindow, pos) {
  infoWindow.setPosition(pos);
  infoWindow.setContent(
    browserHasGeolocation
      ? "Error: The Geolocation service failed."
      : "Error: Your browser doesn't support geolocation."
  );
  infoWindow.open(map);
}