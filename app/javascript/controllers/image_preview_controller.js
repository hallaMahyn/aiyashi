import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  preview() {
    const file = this.inputTarget.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewTarget.innerHTML = `<img src="${e.target.result}" class="w-full h-full object-cover" alt="Preview">`
    }
    reader.readAsDataURL(file)
  }
}
