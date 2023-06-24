import { Controller } from "@hotwired/stimulus"
import Quill from 'quill';
export default class extends Controller {
  static targets = ["editor", "input"]
  connect() {
    this.quill = new Quill(this.editorTarget, {
      theme: 'snow',
      modules: {
        toolbar: [
          [{ header: [1, 2, false] }],
          ['bold', 'italic', 'underline'],
          ['image', 'code-block']
        ]
      }
    });
  }
  disconnect() {
    if (this.quill) {
      this.quill = null;
    }
  }
}