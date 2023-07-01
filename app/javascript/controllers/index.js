import { application } from './application'

import SnippetsController from './snippets_controller'
application.register('snippets', SnippetsController)

import FlashController from './flash_controller'
application.register('flash', FlashController)
