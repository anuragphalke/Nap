import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button"
export default class extends Controller {

  connect() {
    console.log("Scroll to center controller connected");
    this.centerMiddlePanel();
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
