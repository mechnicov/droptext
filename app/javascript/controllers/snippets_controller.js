import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    recaptchaSiteKey: String,
    successMessage: String,
    emptyBodyMessage: String,
    unsafeWords: Array,
  }

  static targets = [
    'backdrop',
    'modal',
  ]

  connect() {
    this.form = document.querySelector('#snippet_form')
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
          this.form.querySelector('input[name="snippet[recaptcha_token]"]').value = token
        })

        this.captchaLoaded = true
      })
    }

    document.querySelector('head').appendChild(script)
  }

  async submitForm(checkUnsafeWords = true) {
    const formData = new FormData(this.form)
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
      await fetch(this.form.action, {
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
