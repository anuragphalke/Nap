import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login"
export default class extends Controller {
  static targets = ["email", "password", "button"];
  connect() {

    this.modelTarget.addEventListener("change", () => this.#enableButton());

  }

  #enableButton() {
    if (this.brandTarget.value !== "") {
      this.buttonTarget.classList.remove("btn-secondary")
      this.buttonTarget.classList.add("btn-active")
      console.log('working');

    }
  }
}
