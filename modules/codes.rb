class FishSocket
  module Listener
    # This module assigned to processing all promo-codes
    module Codes
      def is_admin?()
        return true if TelegramConstants::ADMIN_LIST.include? Listener.message.from.id.to_s
        return false
      end
      def is_code()
        return false if Listener.message.text.nil?
        text=Listener.message.text
        File.open("code_to_full.txt").each_line{|s|
          a=s.split(' ')            #p Kernel.eval(line.split(' ')[1])
          return true if text.to_s==a[0].to_s
        }
      end
      def file_id_get()#Listener.bot.api.get_updates
        a=Listener.bot.api.get_updates()
        #File.write("412.txt","#{a}")
        #p Listener.message.message_id
        out=[]
        i=0
        while true
          break if a.dig('result',i,'message').nil?
          #a=a.dig
          if a.dig('result',i,'message','photo')
            out << [a.dig('result',i,'message','photo',-1,'file_id'),"photo"]
          elsif a.dig('result',i,'message','video')
            out << [a.dig('result',i,'message','video','file_id'),"video"]
          elsif a.dig('result',i,'message','document')
            out << [a.dig('result',i,'message','document','file_id'),"document"]
          elsif a.dig('result',i,'message','text')
            out << [a.dig('result',i,'message','text'),"text"]
          else Listener::Response.std_message("ЕБАННЫЙ НАСРАЛ КОД file_id_get ебать")
          end
          i+=1
        end#p out
        #p "ff"
        return out
      end
      def check_and_send_full(code)
        #return true if find
        send_smth=false
        File.open("code_to_full.txt").each_line do |line|
          a=line.split(' ')            #p Kernel.eval(line.split(' ')[1])
          if a[0]==code
            out=[]
            #считывается построчно файл и если совпадает то конвертирует строку в двумерный массив
            Kernel.eval(a[1]).map{ |e|
               if e[1]=="video" or e[1]=="photo"
                 out << e
               elsif e[1]=="document" # если документ то сразу отправляет и завершает
                 Listener::Response.send_document("#{e[0]}")
                 send_smth=true
               elsif e[1]=="text"
                 if e[0].include? "_"
                   Listener::Response.std_message("#{e[0].gsub!("_"," ")}")
                 else
                   Listener::Response.std_message("#{e[0]}")
                 end
                 send_smth=true
               end
             }
             return false if out==[] and not send_smth# main check
             if out.length()==1
               case out[0][1]
                 when "photo"
                   Listener::Response.send_photo(out[0][0])
                   send_smth=true
                 when "video"
                   Listener::Response.send_video(out[0][0])
                    send_smth=true
               end
             elsif out.length()>1
               for i in 0..out.length()-1
                 case out[i][1]
                 when "photo"
                   out[i]=Telegram::Bot::Types::InputMediaPhoto.new(media:"#{out[i][0]}")
                 when "video"
                   out[i]=Telegram::Bot::Types::InputMediaVideo.new(media:"#{out[i][0]}")
                 end
               end
               Listener::Response.send_media_group(out)
               send_smth=true
             end
          end
        end
        Listener::Response.std_message("оставить о нас отзыв можете командой /review\nподдержать наш канал можно через /donat","main")
      #  if send_smth
      #    stat=File.read("stat.txt")
        #  stat=stat.split("\n")
        #  for i in 0..stat.length()-1
        #    line=stat[i].split(" ")
        #    stat[i]= line[1].nil? ? stat[i]=line[0]+(line[1].to_i+1).to_s : stat[i]=line[0]+(line[1].to_i+1).to_s
        #  end
        #  p stat
        #  File.open("stat.txt", "w+").puts(stat)
        #  return true
        #end

      end
      module_function(
          :is_admin?,
          :file_id_get,
          :check_and_send_full,
          :is_code
      )
    end
  end
end
