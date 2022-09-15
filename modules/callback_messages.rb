class FishSocket
  module Listener
    # This module assigned to processing all callback messages
    module CallbackMessages
      attr_accessor :callback_message

      def process
        self.callback_message = Listener.message.message
        if Listener.message.data.to_s.include? "send_review_"
          @id1=Listener.message.data.to_s[12..-1]
          Listener.message.data="send_review_"
        end
        case Listener.message.data
        when 'send_message_by_id'
          Listener::Response.force_reply_message("Введите айди человека")
          Listener::Security.answer_callback_query
        when 'replace_db_file'
          #Listener::Response.std_message("Отправьте blacklist, admin_list, date, code_to_full")
          Listener::Response.force_reply_message("Введите имя файла\n blacklist, admin_list, date, code_to_full")
          Listener::Security.answer_callback_query
        when "add_full"
          return Listener::Response.std_message 'Вы не админ' if not Listener::Codes.is_admin?
          Listener::Response.force_reply_message("Отправьте код, для отмены введите 0")
          Listener::Security.answer_callback_query
        when 'full_code_check'
          Listener::Response.force_reply_message('Введите код, для отмены введите 0')
          Listener::Security.answer_callback_query
        when 'add_admin'
          return Listener::Response.std_message 'Вы не админ' if not Listener::Codes.is_admin?
          Listener::Response.force_reply_message("Перешлите сообщение человека для добавления его в админы, для отмены введите 0")
          Listener::Security.answer_callback_query
        when 'send_files'
          #["admin_list","date","code_to_full","blacklist"]
          Listener::Response.send_document(Faraday::UploadIO.new("admin_list.txt","txt"))
          Listener::Response.send_document(Faraday::UploadIO.new("date.txt","txt"))
          Listener::Response.send_document(Faraday::UploadIO.new("code_to_full.txt","txt"))
          Listener::Response.send_document(Faraday::UploadIO.new("blacklist.txt","txt"))
          Listener::Security.answer_callback_query
        when 'admin_buttons'
          return Listener::Response.std_message 'Вы не админ' if not Listener::Codes.is_admin?
          Listener::Response.inline_message("Дополнительное меню:", Listener::Response.generate_inline_markup([
            Inline_Button::ADD_ADMIN,
            Inline_Button::ADD_FULL,
            Inline_Button::SEND_FILES,
            Inline_Button::REPLACE_DB_FILE
        ]), false)
          Listener::Security.answer_callback_query
        when 'send_review_'
          #File.write("callback.txt","#{Listener.bot.api.get_updates}")
          message_id=Listener.bot.api.get_updates.dig("result",0,"callback_query","message","message_id")
          chat_id=Listener.bot.api.get_updates.dig("result",0,"callback_query","message","chat","id")
          #p chat_id
          #p message_id
          Listener.bot.api.deleteMessage(chat_id:chat_id,message_id:message_id)
          Listener::Response.std_message("Оставить отзыв можно коммандой /review",@id1.to_i)
          Listener::Response.std_message("Заявка на отзыв отправленна")
          Listener::Security.answer_callback_query
        end
      end

      module_function(
          :process,
          :callback_message,
          :callback_message=
      )
    end
  end
end
