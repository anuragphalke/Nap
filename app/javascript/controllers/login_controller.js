import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login"
export default class extends Controller {
  static targets = ["email", "password", "button", "blob"];

  connect() {
    this.passwordTarget.addEventListener("keyup", () => this.#enableButton());
    this.emailTarget.addEventListener("keyup", () => this.#enableButton());
  }

  #enableButton() {
    if (this.emailTarget.value !== "" && this.passwordTarget.value !== "") {
      // Activate the button and blob
      this.buttonTarget.classList.remove("btn-secondary");
      this.buttonTarget.classList.add("btn-active");

      this.blobTarget.classList.remove("blob-login");
      this.blobTarget.classList.add("blob-login-active");
    } else {
      // Revert to original state
      this.buttonTarget.classList.remove("btn-active");
      this.buttonTarget.classList.add("btn-secondary");

      this.blobTarget.classList.remove("blob-login-active");
      this.blobTarget.classList.add("blob-login");
    }
  }
}
