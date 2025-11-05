import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["section", "input", "checkbox"];

  connect() {
    this.apply();
  }

  toggle() {
    this.apply();
  }

  apply() {
    const checked = this.checkboxTarget?.checked;
    this.sectionTarget.classList.toggle("d-none", !checked);

    this.inputTargets.forEach((el) => {
      el.disabled = !checked;
      if (!checked) el.value = "";
    });
  }
}
