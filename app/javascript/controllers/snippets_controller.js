import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    recaptchaSiteKey: String,
    successMessage: String,
    unsafeWords: Array,
  }

  connect() {
    this.form = document.querySelector('#snippet_form')
    this.modal = document.querySelector('#unsafe-modal-confirm')
    this.backdrop = document.querySelector('#unsafe-modal-backdrop')
    this.flashContainer = document.querySelector('#flash-container')
    this.flashText = document.querySelector('#flash-text')
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

    if (checkUnsafeWords) {
      const unsafeWord =
        new RegExp(this.unsafeWordsValue.join('|'), 'i').exec(formData.get('snippet[body]'))?.shift()

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
      this.showAlert(this.successMessageValue)
      setTimeout(() => window.location.href = `/s/${encodeURIComponent(token)}`, 1000)
    }

    if (errors) this.showAlert(errors.join(' '))
  }

  showAlert(text) {
    this.flashContainer.classList.remove('hidden')
    this.flashText.innerHTML = text

    setTimeout(
      () => {
        this.flashContainer.classList.add('hidden')
        this.flashText.innerHTML = ''
      },
      1500
    )
  }

  toggleUnsafeConfirmModal() {
    this.modal.classList.toggle('hidden')
    this.backdrop.classList.toggle('hidden')
    this.modal.classList.toggle('flex')
    this.backdrop.classList.toggle('flex')
  }

  unsafeSnippetSubmitForm() {
    this.toggleUnsafeConfirmModal()
    this.submitForm(false)
  }
}
