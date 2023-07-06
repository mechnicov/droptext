import '@hotwired/turbo-rails'
import './controllers'

import hljs from './lib/highlight.js'
import ClipboardJS from 'clipboard'
import Choices from 'choices.js'

document.addEventListener('turbo:load', (event) => {
  hljs.highlightAll()

  new ClipboardJS('.js-clipboard', { text: trigger => trigger.getAttribute('data-clipboard-text') }).on('success', e => {
    const tooltip = e.trigger.querySelector('.copied-tooltip')
    tooltip.classList.remove('hidden')
    setTimeout(() => tooltip.classList.add('hidden'), 300)
  })

  const languageSelect = document.querySelector('#snippet_language')

  if (languageSelect) {
    new Choices(languageSelect, {
      noResultsText: languageSelect.dataset.noResults,
      itemSelectText: languageSelect.dataset.itemSelect,
      sorter: (a, b) => new Intl.Collator(languageSelect.dataset.locale).compare(a.label, b.label),
    })
  }
})
