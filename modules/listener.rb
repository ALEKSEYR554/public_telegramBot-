class FishSocket
  # Sorting new message module
  module Listener
    attr_accessor :message, :bot

    def catch_new_message(message,bot)
      self.message = message
      self.bot = bot
      begin
      #return false if Security.message_too_far
      if !Listener::Security.is_subscribe(self.message,self.bot)
        return false
      end
      if Listener::Security.is_blacklisted(self.message,self.bot)
        Listener::Response.std_message("Вы были заблокированны в данном боте")
        return false
      end
      case self.message
      when Telegram::Bot::Types::CallbackQuery
        CallbackMessages.process
      when Telegram::Bot::Types::Message
        StandartMessages.process
      end
      rescue Exception => e
        if e.to_s.include? "retry after"
          Listener::Response.std_message("#{e}",TelegramConstants::ERROR_CHANNEL_ID)
          retry
        end
        if not e.to_s.include? "bot was blocked by the user"
          Listener.bot.api.send_message(chat_id:TelegramConstants::ERROR_CHANNEL_ID, text:"Я КРАШНУЛСЯ")
          Listener.bot.api.send_message(chat_id:TelegramConstants::ERROR_CHANNEL_ID, text:"Сообщение перед ошибкой #{Listener.message} \n #{Time.now} \n #{e}\n Айди человека: <code>#{message.from.id}</code> \n Человек @#{Listener.message.from.username}",parse_mode: 'html')
        end
      end
    end

    module_function(
      :catch_new_message,
      :message,
      :message=,
      :bot,
      :bot=
    )
  end
end
