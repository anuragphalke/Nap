import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="get-data"
export default class extends Controller {
  connect() {
  }
}


async function fetchViaProxy(targetUrl) {
  const response = await fetch(`/proxy?url=${encodeURIComponent(targetUrl)}`);
  if (response.ok) {
    const data = await response.text(); // HTML or other content
    return data;
  } else {
    console.error("Error fetching data via proxy");
  }
}

// Usage
const pageHTML = await fetchViaProxy("https://www.energyprices.eu/electricity/netherlands");

const regex = /data:\s\[([\d.,\s]+)]/;
const match = [...pageHTML.match(regex)][0]

console.log(match)
