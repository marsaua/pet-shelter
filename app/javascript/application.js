// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import * as bootstrap from "bootstrap";
// import { Calendar } from "@fullcalendar/core";
// import dayGridPlugin from "@fullcalendar/daygrid";
import "./maps/show_map.js";

// Initialize Bootstrap and other components on turbo:load
document.addEventListener("turbo:load", () => {
  console.log("Turbo:load event fired, initializing Bootstrap components...");

  // Initialize all Bootstrap dropdowns
  const dropdownElementList = document.querySelectorAll(".dropdown-toggle");
  console.log("Found", dropdownElementList.length, "dropdown elements");
  const dropdownList = [...dropdownElementList].map((dropdownToggleEl) => {
    console.log("Initializing dropdown for element:", dropdownToggleEl);
    return new bootstrap.Dropdown(dropdownToggleEl);
  });

  // Initialize all Bootstrap tooltips
  const tooltipTriggerList = document.querySelectorAll(
    '[data-bs-toggle="tooltip"]'
  );
  const tooltipList = [...tooltipTriggerList].map(
    (tooltipTriggerEl) => new bootstrap.Tooltip(tooltipTriggerEl)
  );

  // Initialize all Bootstrap popovers
  const popoverTriggerList = document.querySelectorAll(
    '[data-bs-toggle="popover"]'
  );
  const popoverList = [...popoverTriggerList].map(
    (popoverTriggerEl) => new bootstrap.Popover(popoverTriggerEl)
  );

  // TODO: Re-enable FullCalendar after fixing Bootstrap dropdown
  // Initialize FullCalendar if present
  // const calendarEl = document.getElementById("calendar");
  // if (calendarEl) {
  //   const events = JSON.parse(calendarEl.dataset.events || "[]");

  //   const calendar = new Calendar(calendarEl, {
  //     plugins: [dayGridPlugin],
  //     initialView: "dayGridMonth",
  //     locale: "uk",
  //     events: events.map((e) => ({
  //       title: e.summary,
  //       start: e.start.dateTime || e.start.date,
  //       end: e.end?.dateTime || e.end?.date,
  //     })),
  //   });

  //   calendar.render();
  // }
});
