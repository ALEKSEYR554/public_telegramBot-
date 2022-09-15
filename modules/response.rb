class FishSocket
  module Listener
    # This module assigned to responses from bot
    module Response
      def std_message(message, chat_id="main")
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        a=nil
        a=case chat_id
        when "main"
          chat_id=nil
          Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(Проверить_код👀 Предложка🔸), %w(Попросить_фулл🙏 Донат💸), %w(admin_commands🧑‍💻 Правила❗️)],resize_keyboard:true)
        when "donat"
          chat_id=nil
          Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(Тематический_день👑 Заказать_автора🌄), %w(Донат💵 Отзывы💎),%w(Назад🔙)],resize_keyboard:true)
        end
        chat = chat_id if chat_id

        Listener.bot.api.send_message(
          parse_mode: 'html',
          chat_id: chat,
          text: message,
          reply_markup:a
        )
      end
      def fully_copy_and_send_message(chat_id)
        a=Listener::Codes.file_id_get
        count=a.each_slice(10).to_a.length#split array to arrays by 10 elements
        for j in 1..count do
          caption= Listener.bot.api.get_updates.dig("result",0,"message","caption").nil? ? "" :Listener.bot.api.get_updates.dig("result",0,"message","caption").to_s
          #File.write("twetw.txt","#{Listener.bot.api.get_updates()}")
          send_smth=false
          out=[]
          a.map{ |e|
             if e[1]=="video" or e[1]=="photo"
               out << e
             elsif e[1]=="document"
               Listener::Response.send_document("#{e[0]}",chat_id)
               send_smth=true
             elsif e[1]=="text"
               Listener::Response.std_message("#{e[0]}",chat_id)
               send_smth=true
             end
           }
          return false if out==[] and not send_smth # main check
          if out.length()==1
           case out[0][1]
             when "photo"
               Listener::Response.send_photo(out[0][0],chat_id,caption: caption)
               send_smth=true
             when "video"
               Listener::Response.send_video(out[0][0],chat_id)
                send_smth=true
           end
          elsif out.length()>1
            photo_yes=false
           for i in 0..out.length()-1
             case out[i][1]
             when "photo"
               if photo_yes
                 out[i]=Telegram::Bot::Types::InputMediaPhoto.new(media:"#{out[i][0]}")
               else
                 out[i]=Telegram::Bot::Types::InputMediaPhoto.new(media:"#{out[i][0]}",caption:caption)
                 photo_yes=true
               end
             when "video"
               out[i]=Telegram::Bot::Types::InputMediaVideo.new(media:"#{out[i][0]}")
             end
           end
           #File.write("dads.txt","#{out}")
           Listener::Response.send_media_group(out,chat_id) if not send_smth==true
           #send_smth=true
          end
        end
      end
      def send_media_group(file_array,chat_id=false)
        return false if file_array.length()<2
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_media_group(
          chat_id: chat,
          media: file_array
        )
      end
      def forward_message(to_chat_id, type="", add="")
        case type
        when "pls_find_full"
          Listener.bot.api.send_message(chat_id:chat_id,text:"НАЙТИ ФУЛЛ Осталось на сегодня #{add} \n Айди отправителя: <code>#{message.from.id}</code>",parse_mode: 'html')
        when "post_suggest"
          Listener.bot.api.send_message(chat_id:chat_id,text:"ПЖ ВЫЛОЖИТЕ \n Айди отправителя: <code>#{message.from.id}</code> \n Отправитель #{Listener.message.from.username}",parse_mode: 'html')
        end
        from_chat_id=Listener.message.chat.id
        message_id =Listener.message.message_id
        Listener.bot.api.forward_message(
          chat_id:to_chat_id,
          from_chat_id:from_chat_id,
          message_id: message_id,
          disable_notification:true
        )
      end
      def send_animation(file_id, chat_id = false )
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_animation(
          parse_mode: 'html',
          chat_id: chat,
          animation: file_id.to_s
        )
      end
      def send_photo(file_id, chat_id = false,caption="" )
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_photo(
          parse_mode: 'html',
          chat_id: chat,
          photo: file_id.to_s,
          caption: caption.to_s
        )
      end
      def send_document(file_id, chat_id = false )
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_document(
          parse_mode: 'html',
          chat_id: chat,
          document: file_id
        )
      end
      def send_video(file_id, chat_id = false )
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_video(
          parse_mode: 'html',
          chat_id: chat,
          video: file_id.to_s
        )
      end
      def inline_message(message, inline_markup, editless = false, chat_id = false)
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        #puts chat
        chat = chat_id if chat_id
        if editless
          return Listener.bot.api.edit_message_text(
            chat_id: chat,
            parse_mode: 'html',
            message_id: Listener.message.message.message_id,
            text: message,
            reply_markup: inline_markup
          )
        end
        Listener.bot.api.send_message(
          chat_id: chat,
          parse_mode: 'html',
          text: message,
          reply_markup: inline_markup
        )
      end

      def generate_inline_markup(kb, force = false)
        Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: kb
        )
      end
      def show_reply_keyboard(keyboard, one_time=true, chat_id = false)
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        answers=Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard:keyboard,
          one_time_keyboard:one_time,
          resize_keyboard:true
        )
        Listener.bot.api.send_message(chat_id: chat, text: "FUCK", reply_markup: answers)
      end

      def force_reply_message(text, chat_id = false)
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_message(
          parse_mode: 'html',
          chat_id: chat,
          text: text,
          reply_markup: Telegram::Bot::Types::ForceReply.new(
            force_reply: true,
            selective: true
          )
        )
      end

      module_function(
        :std_message,
        :generate_inline_markup,
        :inline_message,
        :force_reply_message,
        :show_reply_keyboard,
        :send_document,
        :send_photo,
        :send_video,
        :send_animation,
        :forward_message,
        :send_media_group,
        :fully_copy_and_send_message
      )
    end
  end
end
