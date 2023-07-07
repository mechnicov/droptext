require 'telegram/bot'

namespace :telegram_bot do
  desc 'Sends a message, containing new posted snippets'
  task notify_about_new_snippets: :environment do
    last_snippets = Snippet.where('created_at > ?', 24.hours.ago)

    next if last_snippets.empty?

    Rails.application.credentials.config[:telegram] => { bot_token:, owner_ids: }

    text = I18n.t('telegram.last_published_snippets')

    last_snippets.find_each do |snippet|
      text << "\n" << Rails.application.routes.url_helpers.snippet_url(token: snippet.token)
    end

    Telegram::Bot::Client.run(bot_token) do |bot|
      owner_ids.each do |chat_id|
        bot.api.send_message(chat_id:, text:)
      end
    end
  end
end
