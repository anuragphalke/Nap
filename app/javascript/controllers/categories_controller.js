import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="categories"
export default class extends Controller {
  static targets = ["category"]; 

  connect() {
  }

  setActiveCategory(event) {
    // Prevent default link behavior if necessary
    event.preventDefault();

    // Remove the active class from all categories
    this.categoryTargets.forEach((category) => {
      category.classList.remove("category-active");
    });

    // Add the "category-active" class to the clicked category
    event.currentTarget.classList.add("category-active");

    // Scroll the clicked category into view
    event.currentTarget.scrollIntoView({
      behavior: "smooth",   // Smooth scrolling
      block: "center",      // Align vertically to the center
      inline: "center"      // Align horizontally to the center
    });

    // Optionally, navigate to the link's href if required
    // window.location.href = event.currentTarget.href;
  }
}
