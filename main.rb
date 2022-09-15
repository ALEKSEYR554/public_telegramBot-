require 'telegram/bot'
require './library/mac-shake'
require './library/texts'
require './library/database'
require './modules/listener'
require './modules/security'
require './modules/standart_messages'
require './modules/response'
require './modules/callback_messages'
require './modules/assets/inline_button'
require './modules/assets/random_im'
require './modules/codes'
require './modules/threads'
require 'open-uri'
# Entry point class
class FishSocket
  include Database
  def initialize
    super
    puts "RUNNING"
    Telegram::Bot::Client.run(TelegramConstants::API_KEY) do |bot|
      # Start time variable, for exclude message what was sends before bot starts
      bot.api.send_message(chat_id: TelegramConstants::ERROR_CHANNEL_ID, text: "RUNNING")
      # Active socket listener
      Threads.startup(bot)
    end
  end
end
# Bot start
FishSocket.new
