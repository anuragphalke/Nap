import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.add("alert-active")
    }, 10)

    setTimeout(() => {
      this.element.classList.remove("alert-active")
    }, 2000)
  }
}
