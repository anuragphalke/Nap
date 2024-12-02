import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button-active"
export default class extends Controller {
  static targets = ["brand", "model", "button"];
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
