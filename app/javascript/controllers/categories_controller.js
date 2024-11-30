import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const urlParams = new URLSearchParams(window.location.search);
    const currentCategory = urlParams.get("category") || "all";

    this.setInitialActive(currentCategory);
    this.scrollToActive();
  }

  setInitialActive(currentCategory) {
    this.element
      .querySelectorAll(".category, .category-active")
      .forEach((link) => {
        const linkCategory = link.textContent.trim().toLowerCase();
        if (linkCategory === currentCategory) {
          link.classList.add("category-active");
          link.classList.remove("category");
        } else {
          link.classList.add("category");
          link.classList.remove("category-active");
        }
      });
  }

  scrollToActive() {
    const activeCategory = this.element.querySelector(".category-active");
    if (activeCategory) {
      activeCategory.scrollIntoView({
        behavior: "smooth",
        block: "nearest",
        inline: "center",
      });
    }
  }

  setActiveCategory(event) {
    event.preventDefault();

    this.element
      .querySelectorAll(".category, .category-active")
      .forEach((link) => {
        link.classList.remove("category-active");
        link.classList.add("category");
      });

    event.currentTarget.classList.remove("category");
    event.currentTarget.classList.add("category-active");

    event.currentTarget.scrollIntoView({
      behavior: "smooth",
      block: "nearest",
      inline: "center",
    });

    const newUrl = event.currentTarget.href;
    window.history.pushState({}, "", newUrl);

    fetch(newUrl)
      .then((response) => response.text())
      .then((html) => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, "text/html");

        const newGrid = doc.querySelector(".grid-2");
        const currentGrid = document.querySelector(".grid-2");
        if (newGrid && currentGrid) {
          currentGrid.innerHTML = newGrid.innerHTML;
        }
      });
  }
}
