# public_telegramBot
Основано на https://github.com/sorshireality/sorshireality-ruby-teleram-bot-native

Телеграм бот для ведения канала аниме или подобной тематики
Есть функция автопринятия запросов на вступление в канал
# Подготовка перед запуском
Убедитесь что вы заполнили все пропуски в файлах [mac-shake](https://github.com/ALEKSEYR554/public_telegramBot-/blob/main/library/mac-shake.rb) и [texts](https://github.com/ALEKSEYR554/public_telegramBot-/blob/main/library/texts.rb)
# Возможности бота со стороны пользователя:
+ Запросить фулл (/pls_find_full) - подписчик отправляет боту фотографию/видео/файл который в последствии пересылается в канал с SUGGEST_CHANNEL_ID, сообщение будет формата "Сколько на сегодня осталось запросов; Кто отправил, его айди; Само сообщение с вложением"
+ Предложить запись, идею (/post_suggest) - подписчик отправляет боту сообщение или вложения для последующего рассмотрения его администрацией в SUGGEST_CHANNEL_ID канал
+ Проверить код (/code_check) - Проверяется код из файла code_to_full.txt и при совпадении отправляет контент запросившему
+ Донат (/donat) - Выводится информация о донатах, что дает донат
+ Правила (/rules) - Выводятся правила бота и/или канала
# Возможности бота со стороны администратора (нужно указать его айди в mac-shake.rb)
Все комманды ниже являются подкоммандами /admin_commands
+ Отправить сообщение по айди - Напрямую зависит от /pls_find_full и /post_suggest, позволяет ответить пользователю от имени бота (если человек заблокировал бота, то выведет соответсвующее сообщение)
+ Добавить фулл - Сначала отсылается код по которому будет доступен контент, а после в ОТВЕТ НА СООБЩЕНИЕ отсылается само вложение в виде видео/фото/файла/текста
+ Получить базу данных - Бот отсылает всю базу данных запросившему её админу (code_to_full, date, blacklist, admin_list(будет удалено за ненадобностью))
+ Заменить файл датабазы - Нужно выбрать файл у которого нужно заменить содержимое и после отослать новое (для code_to_full отослать готовый файл)
