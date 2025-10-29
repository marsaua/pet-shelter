import * as L from "leaflet";

document.addEventListener("turbo:load", () => {
  const el = document.getElementById("map");
  if (!el) return;

  const lat = parseFloat(el.dataset.lat) || 49.430895;
  const lng = parseFloat(el.dataset.lng) || 32.067994;
  const zoom = parseInt(el.dataset.zoom) || 13;

  const map = L.map(el, {
    scrollWheelZoom: true,
    dragging: true,
    zoomControl: true,
  }).setView([lat, lng], zoom);

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
  }).addTo(map);

  L.marker([lat, lng]).addTo(map).bindPopup("Here 🗺️");

  // map.setMinZoom(5);
  // map.setMaxZoom(18);
});
