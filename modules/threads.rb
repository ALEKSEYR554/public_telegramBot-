class FishSocket
  module Threads
    def update_info(bot,main_bot,this_thread,request_accepter_thread)
      while true
        if request_accepter_thread.alive?
          bot.api.send_message(chat_id:TelegramConstants::ERROR_CHANNEL_ID, text: "request_bot still_run")
        else
          bot.api.send_message(chat_id:TelegramConstants::ERROR_CHANNEL_ID, text: 'request_bot IS NOT RUNNING @Panic_mode')
        end
        if main_bot.alive?
          bot.api.send_message(chat_id:TelegramConstants::ERROR_CHANNEL_ID, text: "still_run")
          sleep(1800)
        else
          bot.api.send_message(chat_id:TelegramConstants::ERROR_CHANNEL_ID, text: "I AM NOT RUNNING @Panic_mode")
          this_thread.exit
          break
        end
      end
    end
    def request_bot
      Telegram::Bot::Client.run(TelegramConstants::REQUEST_BOT_API_KEY) do |bot|
        bot.api.send_message(chat_id:TelegramConstants::ERROR_CHANNEL_ID, text: "REQUEST BOT IS RUNNING")
        @last=0
        begin
        while true
          upd=bot.api.get_updates(offset:@last,allowed_updates:['chat_join_request'])#.dig("result",0,"update_id")
          lena=upd.dig("result").length
          for i in 1..lena-1
            begin
            id=upd.dig("result",i,"chat_join_request","from","id")
            bot.api.approveChatJoinRequest(chat_id:TelegramConstants::MAIN_CHANNEL_ID,user_id:id) if bot.api.getChatMember(chat_id:TelegramConstants::MAIN_CHANNEL_ID,user_id:id)['result']['status'].to_s=="left"
            rescue
            end
          end
          @last=upd.dig("result",lena-1,"chat_join_request","from","id")
          sleep(1.0/10.0)
        end
        rescue Exception => e
          File.write("thread_error.txt","#{e}")
          retry
          bot.api.send_message(chat_id:TelegramConstants::ERROR_CHANNEL_ID, text:"Я КРАШНУЛСЯ")
          bot.api.send_message(chat_id:TelegramConstants::ERROR_CHANNEL_ID, text:"Ошибка \n#{e} ",parse_mode: 'html')
        end
      end
    end
    def main_bot(bot,start_bot_time)
      begin
      bot.listen do |message|
        # Processing the new income message    #if that message sent after bot run.
        Listener.catch_new_message(message,bot) if Listener::Security.message_is_new(start_bot_time,message)
      end
      rescue Exception => e
        if e.to_s.include?"retry_after"
          p e
          sleep(5.3)
          retry
        end
        Listener::Response.std_message("ЯРИИИИИИИИККККККК БОЧЁК ПОТИИИИИИК",TelegramConstants::ERROR_CHANNEL_ID)
        Listener::Response.std_message("#{e}",TelegramConstants::ERROR_CHANNEL_ID)
      end
    end
    def startup(bot)
      start_bot_time = Time.now.to_i
      main_bot_thread = Thread.new{Threads.main_bot(bot,start_bot_time)}
      request_accepter_thread=Thread.new{Threads.request_bot()}
      update_status_thread = Thread.new{Threads.update_info(bot,main_bot_thread,update_status_thread,request_accepter_thread)}

      main_bot_thread.join
      request_accepter_thread.join
      update_status_thread.join
    end
    module_function(
      :startup,
      :main_bot,
      :request_bot,
      :update_info
    )
  end
end
