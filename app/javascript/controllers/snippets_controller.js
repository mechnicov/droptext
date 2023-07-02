import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    recaptchaSiteKey: String,
    successMessage: String,
    emptyBodyMessage: String,
    unsafeWords: Array,
  }

  static targets = [
    'form',
    'backdrop',
    'modal',
  ]

  connect() {
    this.flashContainer = document.querySelector('#flash-container')
  }

  loadCaptcha() {
    if (this.captchaLoaded) return

    const script = document.createElement('script')

    script.src = `https://www.google.com/recaptcha/api.js?render=${encodeURIComponent(this.recaptchaSiteKeyValue)}`
    script.onload = () => {
      grecaptcha.ready(() => {
        grecaptcha.execute(
          this.recaptchaSiteKeyValue,
          {
            action: 'callback'
          }
        ).then(token => {
          this.formTarget.querySelector('input[name="snippet[recaptcha_token]"]').value = token
        })

        this.captchaLoaded = true
      })
    }

    document.querySelector('head').appendChild(script)
  }

  async submitForm(checkUnsafeWords = true) {
    const formData = new FormData(this.formTarget)
    const body = formData.get('snippet[body]')

    if (!body) return this.flashContainer.flash.showAlert(this.emptyBodyMessageValue, 'failure')

    if (checkUnsafeWords) {
      const unsafeWord = new RegExp(this.unsafeWordsValue.join('|'), 'i').exec(body)?.shift()

      if (unsafeWord) {
        document.querySelector('#unsafe-words').innerHTML = unsafeWord
        return this.toggleUnsafeConfirmModal()
      }
    }

    const response =
      await fetch(this.formTarget.action, {
        method: 'post',
        body: formData
      })

    const json = await response.json()
    const { token, errors } = json

    if (token) {
      this.flashContainer.flash.showAlert(this.successMessageValue, 'success')
      setTimeout(() => window.location.href = `/s/${encodeURIComponent(token)}`, 1000)
    }

    if (errors) this.flashContainer.flash.showAlert(errors.join(' '), 'failure')
  }

  toggleUnsafeConfirmModal() {
    this.modalTarget.classList.toggle('hidden')
    this.backdropTarget.classList.toggle('hidden')
    this.modalTarget.classList.toggle('flex')
    this.backdropTarget.classList.toggle('flex')
  }

  unsafeSnippetSubmitForm() {
    this.toggleUnsafeConfirmModal()
    this.submitForm(false)
  }
}
