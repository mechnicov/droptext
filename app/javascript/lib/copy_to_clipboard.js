import ClipboardJS from 'clipboard'

document.addEventListener('turbo:load', () => {
  new ClipboardJS('.js-clipboard', { text: trigger => trigger.getAttribute('data-clipboard-text') }).on('success', e => {
    const tooltip = e.trigger.querySelector('.copied-tooltip')
    tooltip.classList.remove('hidden')
    setTimeout(() => tooltip.classList.add('hidden'), 300)
  })
})
