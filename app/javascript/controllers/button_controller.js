import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button"
export default class extends Controller {

  // Initialize event listener for turbo:load
  connect() {
    this._onTurboLoad();
    this._bindTurboLoadEvent();
  }

  // Custom method to handle both manual refresh and turbo navigation
  _onTurboLoad() {
    console.log("Scroll to center controller connected");

    // Ensure you center the panel when the page is fully loaded
    this.centerMiddlePanel();
  }

  // Bind the turbo:load event to re-trigger the method when navigating via Turbo
  _bindTurboLoadEvent() {
    document.addEventListener("turbo:load", () => {
      this._onTurboLoad();  // Re-run the method when a Turbo page load happens
    });
  }

  scrollToCenter(event) {
    const panel = event.currentTarget;
    this.centerPanel(panel);
  }

  centerMiddlePanel() {
    const panels = this.element.querySelectorAll(".panel");
    const middlePanelIndex = Math.floor(panels.length / 2);
    const middlePanel = panels[middlePanelIndex];
    this.centerPanel(middlePanel);
  }

  centerPanel(panel) {
    const container = this.element;
    const containerWidth = container.offsetWidth;
    const panelWidth = panel.offsetWidth;
    const scrollLeft =
      panel.offsetLeft - (containerWidth / 2) + (panelWidth / 2);

    container.scrollTo({
      left: scrollLeft,
      behavior: "smooth",
    });
  }
}
