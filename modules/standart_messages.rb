class FishSocket
  module Listener
    # This module assigned to processing all standart messages
    module StandartMessages
      def process
        if Listener.message.text.to_s.include? "/start code_check_"
          @code=Listener.message.text.to_s[18..-1]
          Listener.message.text="/start code_check_"
        end
        case Listener.message.text
        when '/start', 'команды','/commands'
          Listener::Response.std_message("Обязательно прочитайте /rules.\n Используйте меню комманд слева от поля ввода сообщения")
        when 'fff'
          Listener::Response.force_reply_message("file_id_send")
        when '/rules', '/start rules',"Правила❗️"
          Listener::Response.std_message(Bot_Texts::RULES,"main")
        when '/admin_commands',"admin_commands🧑‍💻"
          return false if not Listener::Codes.is_admin?
          Listener::Response.inline_message("Меню:", Listener::Response.generate_inline_markup([
            Inline_Button::ADD_FULL,
            Inline_Button::SEND_FILES,
            Inline_Button::REPLACE_DB_FILE,
            Inline_Button::SEND_MESSAGE_BY_ID
        ]), false)
        when "Назад🔙"
          Listener::Response.std_message("Выполненно","main")
      when "/donat" ,"/start donat","Донат💸"
          Listener::Response.std_message(Bot_Texts::DONAT_TEXT,"donat")
          #Listener::Response.std_message(") #после обратитесь к админу @Panic_mode или @ALEKSEYR554")
        when "/temat_day", "/start temat_day", "Тематический_день👑"
          Listener::Response.std_message(Bot_Texts::TEMAT_DAY_TEXT,"donat")
        when "/author_request", "/start author_request", "Заказать_автора🌄"
          Listener::Response.std_message(Bot_Texts::AUTHOR_REQUEST,"donat")
        when "/donation","/start donation","Донат💵"
          Listener::Response.std_message("Простая поддержка канала","donat")
        when "/reviews","/start reviews","Отзывы💎"
          Listener::Response.std_message(Bot_Texts::REVIEW_TEXT,"donat")
        when "/code_check", "/start code_check","Проверить_код👀"
          Listener::Response.force_reply_message('Введите код ответом на сообщение, для отмены введите 0')
        when "/start code_check_"
          return Listener::Response.std_message 'Неверный код' if not Codes.check_and_send_full(@code)
          @code=nil
        when "/review"
          Listener::Response.force_reply_message("Отправьте отзыв на нашего бота или канал")
        when "/post_suggest", "/start post_suggest","Предложка🔸"
          @last_id=0
          Listener::Response.force_reply_message("Отправьте предложенную запись")
        when "/pls_find_full", "/start pls_find_full","Попросить_фулл🙏"
          @last_id=0
          Listener::Response.std_message(Bot_Texts::PLS_FIND_FULL_TEXT,"main")
          if File.read("date.txt").count("\n")!=3
            day,current_left,max_left=Time.now.day,10,10
          else
            day,current_left,max_left=File.read("date.txt").split
          end
          day,current_left,max_left=day.to_i,current_left.to_i,max_left.to_i
          if Time.now.day.to_i != day
            current_left=max_left
            day=Time.now.day
          end
          if current_left.<=0
            Listener::Response.std_message("Бесплатные запросы сегодня больше не принимаются, попробуйте завтра")
          else
            Listener::Response.force_reply_message(Bot_Texts::REQUEST_TEXT)
            File.open("date.txt", "w+") do |f|
              f.puts([day,current_left,max_left]) end
          end
        else
          unless Listener.message.reply_to_message.nil?
            case Listener.message.reply_to_message.text
            when /Отправьте предложенную запись/
              return Listener::Response.std_message 'Отмена' if Listener.message.text.to_s=="0"
              #return Listener::Response.std_message 'Коды применять по команде /code_check' if Listener::Codes.is_code
              return false if not @last_id==0
              @last_id=1
              Listener.bot.api.send_message(chat_id:TelegramConstants::SUGGEST_CHANNEL_ID,text:"ПЖ ВЫЛОЖИТЕ \n Айди отправителя: <code>#{Listener.message.from.id}</code> \n Отправитель @#{Listener.message.from.username}",parse_mode: 'html')
              Listener::Response.fully_copy_and_send_message(TelegramConstants::SUGGEST_CHANNEL_ID)
              Listener::Response.std_message("Отправленно на проверку","main")
            when /file_id_send/
              Listener::Response.send_photo(Listener.message.text.to_s)
            when /Отправьте отзыв на нашего бота или канал/
              Listener::Response.forward_message(TelegramConstants::REVIEW_CHANNEL_ID,Listener.message.chat.id)
              Listener::Response.std_message(Bot_Texts::REVIEW_SENDED,"main")
            when /Отправьте фото для поиска фулла ответом на сообщение, для отмены введите 0/
              return Listener::Response.std_message 'Отмена' if Listener.message.text.to_s=="0"
              #return Listener::Response.std_message 'Коды применять по команде /code_check' if Listener::Codes.is_code
              return false if not @last_id==0
              @last_id=1
              cont=File.read("date.txt").split
              current_left=cont[1].to_i-1
              cont[1]=current_left
              File.open("date.txt", "w+") do |f|
                f.puts(cont) end
              Listener.bot.api.send_message(chat_id:TelegramConstants::SUGGEST_CHANNEL_ID,text:"НАЙТИ ФУЛЛ Осталось на сегодня #{current_left} \n Айди отправителя: <code>#{Listener.message.from.id}</code> \n Отправитель @#{Listener.message.from.username}",parse_mode: 'html')
              Listener::Response.fully_copy_and_send_message(TelegramConstants::SUGGEST_CHANNEL_ID)
              #Listener::Response.forward_message(-1001732598335, Listener.message, "pls_find_full","#{current_left}")
              Listener::Response.std_message("Отправлено на проверку и поиск","main")
            when /Введите имя файла\n blacklist, admin_list, date, code_to_full/
              return Listener::Response.std_message 'Отмена' if Listener.message.text.to_s=="0"
              case Listener.message.text#.to_s
              when 'blacklist'
                Listener::Response.std_message("Вводить айди человека через пробел например:\n 7417404 3412415 41251512")
                Listener::Response.force_reply_message("Введите новое содержимое файла blacklist.txt")
              when "admin_list"
                Listener::Response.std_message("Вводить айди человека через пробел например:\n 7417404 3412415 41251512")
                Listener::Response.force_reply_message("Введите новое содержимое файла admin_list.txt")
              when "date"
                Listener::Response.std_message("сегодняшнее_число осталось_на_сегодня макс_на_день например:\n 15 10 10")
                Listener::Response.force_reply_message("Введите новое содержимое файла date.txt")
              when "code_to_full"
                Listener::Response.send_document(Faraday::UploadIO.new("code_to_full.txt","txt"))
                Listener::Response.force_reply_message("Отправьте файл с новым содержимым code_to_full.txt")
              end
            when /Отправьте файл с новым содержимым code_to_full.txt/
              file=Listener.bot.api.get_file(file_id:"#{Listener::Codes.file_id_get()[0][0]}").dig('result','file_path').to_s
              File.write("code_to_full.txt",(URI.open("https://api.telegram.org/file/bot#{TelegramConstants::API_KEY}/#{file}").read.to_s))
              Listener::Response.std_message("Данные code_to_full.txt заменены")
              Listener::Response.send_document(Faraday::UploadIO.new("code_to_full.txt","txt"),TelegramConstants::ERROR_CHANNEL_ID)
            when /Введите новое содержимое файла blacklist.txt/
              File.open("blacklist.txt", "w+") do |f|
                f.puts(Listener.message.text.split(" "))
              end
              Listener::Response.std_message("Данные blacklist.txt заменены")
              Listener::Response.send_document(Faraday::UploadIO.new("blacklist.txt","txt"),TelegramConstants::ERROR_CHANNEL_ID)
            when /Введите новое содержимое файла admin_list.txt/
              File.open("admin_list.txt", "w+") do |f|
                f.puts(Listener.message.text.split(" "))
              end
              Listener::Response.std_message("Данные admin_list.txt заменены")
            when /Введите новое содержимое файла date.txt/
              File.open("date.txt", "w+") do |f|
                f.puts(Listener.message.text.split(" "))
              end
              Listener::Response.std_message("Данные date.txt заменены")
            when /Введите код ответом на сообщение, для отмены введите 0/
              return Listener::Response.std_message 'Отмена' if Listener.message.text.to_s=="0"
              return Listener::Response.std_message 'Неверный код' if not Codes.check_and_send_full(Listener.message.text)
            when /Перешлите сообщение человека для добавления его в админы, для отмены введите 0/#НЕ РАБОАЕТ
              return Listener::Response.std_message 'ЭТО НЕ РАБОАЕТ НЕ ТРОГАТЬ АДМИНА В РУЧНУЮ ДОБАВЛЯЕМ'
              return Listener::Response.std_message 'Отмена' if Listener.message.text =="0"
              Listener::Response.std_message("#{Listener.message.forward_from.id.to_s}")
              Database.db.execute("insert into admin_list values ( ? )", Listener.message.forward_from.id.to_s)
            when /Введите айди человека/
              return Listener::Response.std_message 'Отмена' if Listener.message.text.to_s=="0"
              @last_id=0
              #@id=Listener.message.text.to_s
              Listener::Response.force_reply_message("Теперь отправьте сообщение для #{Listener.message.text.to_s}")
            when /Теперь отправьте сообщение для/
              return Listener::Response.std_message 'Отмена' if Listener.message.text.to_s=="0"
              begin
              return false if @last_id==Listener.message.date#@last_id+1==Listener.message.message_id.to_i or @last_id+2==Listener.message.message_id.to_i
              @last_id=Listener.message.date
              id = Listener.message.reply_to_message.text[31..-1]
              Listener::Response.fully_copy_and_send_message(id)
              #Listener::Response.forward_message(@id,Listener.message)
              Listener::Response.std_message("Отправленно")
              Listener::Response.inline_message("кнопка:", Listener::Response.generate_inline_markup([
                Telegram::Bot::Types::InlineKeyboardButton.new(text:"Отправить комманду для отзыва #{id}",callback_data:"send_review_#{id}"),
            ]), false)
              rescue
                Listener::Response.std_message("Этот человек заблокировал бота")
              end
            when /Отправьте код, для отмены введите 0/
              return Listener::Response.std_message 'Отмена1234' if Listener.message.text.to_s=="0"
              #Listener::Response.std_message("#{Listener.message}")
              @last=0
              Listener::Response.force_reply_message("Теперь отправьте фулл для кода #{Listener.message.text}")
            when /Теперь отправьте фулл для кода/
              return Listener::Response.std_message 'Отмена' if Listener.message.text.to_s=="0"
              return Listener::Response.std_message 'Вы не админ' if not Listener::Codes.is_admin?
              code=Listener.message.reply_to_message.text.to_s[31..-1]
              return if Listener.message.date ==@last
              @last=Listener.message.date
              a=Listener::Codes.file_id_get().each_slice(10).to_a
              a.map{|e|
              e=e.to_s.gsub!(", ",",") if e.to_s.include?(", ")
              e=e.to_s.gsub!(" ","_") if e.to_s.include?(" ")
              File.write('code_to_full.txt', "#{code} #{e}\n", mode: 'a')
              }
              #Listener::Response.force_reply_message('Теперь отправьте код, для отмены введите 0') if a
              #a=a.to_s.gsub!(", ",",")
              #a=a.to_s.gsub!(" ","_") if a.to_s.include?(" ")
              #File.write('code_to_full.txt', "#{code} #{a}\n", mode: 'a')
              #File.write('stat.txt', "#{Listener.message.text}\n", mode: 'a')
              Listener::Response.std_message("#{code} #{a}\n")
              Listener::Response.std_message("#{Bot_Texts::BOT_LINK}?start=code_check_#{code}")
              Listener::Response.send_document(Faraday::UploadIO.new("code_to_full.txt","txt"),TelegramConstants::ERROR_CHANNEL_ID)
              #Database.db.execute("INSERT INTO codes_to_full_message_list VALUES (?, ?)", ["#{Listener.message.text}", "#{@a}"])
            end
          end
                  #Response.std_message "#{Listener.message.forward_from_chat.id}"
        end
      end
      module_function(
        :process
      )

    end
  end
end
