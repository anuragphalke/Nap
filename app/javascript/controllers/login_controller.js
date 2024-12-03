import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login"
export default class extends Controller {
  static targets = ["email", "password", "button", "blob", "bulb1", "bulb2"];

  connect() {
    this.passwordTarget.addEventListener("keyup", () => this.#enableButton());
    this.emailTarget.addEventListener("keyup", () => this.#enableButton());
  }

  #enableButton() {
    // Check if both inputs have values
    const bothFilled = this.emailTarget.value !== "" && this.passwordTarget.value !== "";

    if (bothFilled) {
      // Activate the button and blob
      this.buttonTarget.classList.remove("btn-secondary");
      this.buttonTarget.classList.add("btn-active");

      this.blobTarget.classList.remove("blob-login");
      this.blobTarget.classList.add("blob-login-active");

      // Add the play animation classes
      this.bulb1Target.classList.add("path-animation-play");
      this.bulb2Target.classList.add("path-animation-play");

      // Remove the leave animation classes (if any)
      this.bulb1Target.classList.remove("path-animation-leave");
      this.bulb2Target.classList.remove("path-animation-leave");

      // Ensure the path-animation class is added
      this.bulb1Target.classList.add("path-animation");
      this.bulb2Target.classList.add("path-animation");

    } else {
      // Revert to original state
      this.buttonTarget.classList.remove("btn-active");
      this.buttonTarget.classList.add("btn-secondary");

      this.blobTarget.classList.remove("blob-login-active");
      this.blobTarget.classList.add("blob-login");

      // Remove the play animation classes
      this.bulb1Target.classList.remove("path-animation-play");
      this.bulb2Target.classList.remove("path-animation-play");

      // Ensure the path-animation class is removed and add the leave animation
      this.bulb1Target.classList.remove("path-animation");
      this.bulb2Target.classList.remove("path-animation");

      this.bulb1Target.classList.add("path-animation-leave");
      this.bulb2Target.classList.add("path-animation-leave");
    }
  }
}
