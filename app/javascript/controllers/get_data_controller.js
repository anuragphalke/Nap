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
const numbers = [...match.match(/[\d./]+/g)].map((number) => {
  const numerical = parseFloat(number)
  return numerical
})

console.log(numbers)

const today = new Date()
let hour = 0

const formattedDate = today.toISOString().split('T')[0];

console.log(formattedDate);

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

numbers.forEach((num) => {
  fetch('/prices',
    {
      method: "POST",
      headers: {"Content-Type": "application/json", "X-CSRF-Token": csrfToken},
      body: JSON.stringify({"datetime": `${formattedDate} ${hour}:00:00`, "price": num})
    }
  )
  .then((response) => response.json())
  .then(data => console.log(data))
  hour++
})




// 1. loop through 'numbers'
// 2. for each number in numbers, make a fetch request (POST) to the /prices route
// 3. go into prices_controller#create and define how to handle the data that will be sent
