import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'flashText',
  ]

  connect() {
    this.element[this.identifier] = this
  }

  showAlert(text) {
    this.element.classList.remove('hidden')
    this.flashTextTarget.innerHTML = text

    setTimeout(
      () => {
        this.element.classList.add('hidden')
        this.flashTextTarget.innerHTML = ''
      },
      1500
    )
  }
}
