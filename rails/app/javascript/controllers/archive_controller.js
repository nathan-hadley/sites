import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  scroll(event) {
    event.preventDefault()
    const archiveSection = document.getElementById("archive");
    window.scrollTo({
      top: archiveSection.offsetTop - 40,
      behavior: "smooth"
    });
  }
}