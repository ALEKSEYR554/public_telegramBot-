class FishSocket
  # This module assigned to creating InlineKeyboardButton
  module Inline_Button
    #HAVE_PROMO = Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Есть промокод?', callback_data: 'force_promo')
  #  NEXT_PHOTO = Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Далее', callback_data: 'next_photo')
    ENTER_CODE = Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Ввести код', callback_data:'full_code_check')
    #RANDOM_IMAGE=Telegram::Bot::Types::InlineKeyboardButton.new(text:'Фоточка', callback_data:'rule34_img')
    #POST_IMAGE = Telegram::Bot::Types::InlineKeyboardButton.new(text:'Выложить', callback_data:'post_image')
    #SUBSCRIBE_CHECK= Telegram::Bot::Types::InlineKeyboardButton.new(text:'Выложить', callback_data:'SUBSCRIBE_CHECK')
    ADMIN_BUTTONS=Telegram::Bot::Types::InlineKeyboardButton.new(text:"Администраторные кнопки",callback_data:'admin_buttons')
    ADD_ADMIN =  Telegram::Bot::Types::InlineKeyboardButton.new(text:"Добавить админа",callback_data:'add_admin')
    ADD_FULL = Telegram::Bot::Types::InlineKeyboardButton.new(text:"Добавить фулл",callback_data:'add_full')
    SEND_FILES = Telegram::Bot::Types::InlineKeyboardButton.new(text:"Получить базу данных",callback_data:'send_files')
    REPLACE_DB_FILE = Telegram::Bot::Types::InlineKeyboardButton.new(text:"Заменить файл датабазы",callback_data:'replace_db_file')
    SEND_MESSAGE_BY_ID = Telegram::Bot::Types::InlineKeyboardButton.new(text:"Отправить сообщение по айди",callback_data:'send_message_by_id')
    SEND_REVIEW= Telegram::Bot::Types::InlineKeyboardButton.new(text:"Отправить комманду для отзыва",callback_data:'send_review')
  end
  module Reply_keyboard
    MAIN_KEYBOARD=Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(A B), %w(C D)], one_time_keyboard: false)
  end
end
