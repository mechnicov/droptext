import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'flashText',
  ]

  connect() {
    this.element[this.identifier] = this
    this.resultColors = {
      failure: 'red',
      success: 'emerald',
      warning: 'amber',
    }
  }

  showAlert(text, result = 'warning') {
    const resultClass = `bg-${this.resultColors[result]}-700`

    this.element.classList.remove('hidden')

    this.flashTextTarget.innerHTML = text
    this.flashTextTarget.classList.add(resultClass)

    setTimeout(
      () => {
        this.element.classList.add('hidden')

        this.flashTextTarget.innerHTML = ''
        this.flashTextTarget.classList.remove(resultClass)
      },
      1500
    )
  }
}
