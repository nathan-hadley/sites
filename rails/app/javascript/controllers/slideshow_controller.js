import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "photo", "prev", "next" ]

  connect() {
    this.index = 0
    this.photos = this.photoTargets
    this.showCurrentPhoto()
  }

  prev(event) {
    event.preventDefault()
    this.index = (this.index > 0) ? --this.index : this.photos.length - 1
    this.showCurrentPhoto()
  }

  next(event) {
    event.preventDefault()
    this.index = (this.index < this.photos.length - 1) ? ++this.index : 0
    this.showCurrentPhoto()
  }

  showCurrentPhoto() {
    this.photos.forEach((e, i) => e.classList.toggle("d-none", this.index !== i))
  }
}
