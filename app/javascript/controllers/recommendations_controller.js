import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["option", "container"];

  connect() {
    this.containerTarget.addEventListener("scroll", () => this.updateNumbers());
    this.optionTargets.forEach((option) => {
      option.addEventListener("click", (e) => {
        const index = parseInt(e.target.dataset.option) - 1;
        this.scrollTo(index);
      });
    });
  }

  updateNumbers() {
    const index = Math.round(
      this.containerTarget.scrollLeft / this.containerTarget.offsetWidth
    );
    this.optionTargets.forEach((option, i) => {
      option.classList.toggle("active", i === index);
    });
  }

  scrollTo(index) {
    this.containerTarget.scrollTo({
      left: index * this.containerTarget.offsetWidth,
      behavior: "smooth",
    });
  }
}
