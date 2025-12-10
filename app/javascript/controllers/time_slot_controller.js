import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dateField", "timeSlots", "nextBtn"];
  static values = { currentSlot: String };

  connect() {
    if (this.dateFieldTarget.value) {
      this.loadTimeSlots(new Date(this.dateFieldTarget.value));
    }
  }

  dateChanged() {
    console.log("Date changed:", this.dateFieldTarget.value);
    if (this.dateFieldTarget.value) {
      this.loadTimeSlots(new Date(this.dateFieldTarget.value));
      this.nextBtnTarget.disabled = true;
    }
  }

  loadTimeSlots(selectedDate) {
    console.log("Loading time slots for:", selectedDate);

    const dayOfWeek = selectedDate.getDay();
    const isWeekend = dayOfWeek === 0 || dayOfWeek === 6;

    const slots = isWeekend
      ? {
          "09:00-13:00": "9:00 AM - 1:00 PM",
          "17:00-19:00": "5:00 PM - 7:00 PM",
        }
      : {
          "07:00-11:00": "7:00 AM - 11:00 AM",
          "18:00-20:00": "6:00 PM - 8:00 PM",
        };

    const currentSlot = this.currentSlotValue;

    let html =
      '<label class="form-label">Select Time Slot</label><div class="list-group">';

    Object.entries(slots).forEach(([value, label]) => {
      const isChecked = currentSlot === value ? "checked" : "";
      html += `
        <label class="list-group-item">
          <input type="radio"
                 name="time_slot"
                 value="${value}"
                 required
                 ${isChecked}
                 class="me-2"
                 data-action="change->time-slot#slotSelected">
          ${label}
        </label>
      `;
    });

    html += "</div>";
    this.timeSlotsTarget.innerHTML = html;

    if (currentSlot) {
      this.nextBtnTarget.disabled = false;
    }
  }

  slotSelected() {
    console.log("Slot selected!");
    this.nextBtnTarget.disabled = false;
  }
}
