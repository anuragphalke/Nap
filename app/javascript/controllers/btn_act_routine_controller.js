import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="btn-act-routine"
export default class extends Controller {
  static targets = ["name", "day", "button"];
  connect() {
    console.log('connected new routine');

    this.dayTarget.addEventListener("change", () => this.#enableButton());

  }

  #enableButton() {
    if (this.nameTarget.value !== "") {
      this.buttonTarget.classList.remove("btn-secondary")
      this.buttonTarget.classList.add("btn-active")
      console.log('working');

    }
  }
}
