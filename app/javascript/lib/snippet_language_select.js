import Choices from 'choices.js'

document.addEventListener('turbo:load', () => {
  const languageSelect = document.querySelector('#snippet_language')

  if (!languageSelect) return

  new Choices(languageSelect, {
    noResultsText: languageSelect.dataset.noResults,
    itemSelectText: languageSelect.dataset.itemSelect,
    sorter: (a, b) => new Intl.Collator(languageSelect.dataset.locale).compare(a.label, b.label),
  })
})
