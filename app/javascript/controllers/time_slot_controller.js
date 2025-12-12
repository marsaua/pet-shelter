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
    const isWeekend = [0, 6].includes(dayOfWeek);

    const slots = isWeekend ? window.WEEKEND_SLOT : window.WEEKDAY_SLOT;

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
