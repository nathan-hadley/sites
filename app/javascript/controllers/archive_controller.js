import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  scroll(event) {
    event.preventDefault()
    window.scrollTo({
      top: document.body.scrollHeight,
      behavior: "smooth"
    });
  }
}