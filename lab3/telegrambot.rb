require 'telegram/bot'

token = '5051048863:AAGRjzcTUiJwIBXsa4DAQgub0nTUcnaMfn8'


QUOTES = [
	"You are always a student, never a master. You have to keep moving forward.\n- Conrad L. Hall",
	"Education is a progressive discovery of our own ignorance.\n- Durant William James",
	"The roots of education are bitter, but the fruit is sweet.\n- Aristotel",
	"Education is the best friend. An educated person is respected everywhere. Education beats the beauty and the youth.\n - Andre De Wild"
]

WORDPIC = [
	"1.png",
	"2.png",
	"3.png"
]



Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|


  	case message
	when Telegram::Bot::Types::CallbackQuery
	case message.data

		  # Here you can handle your callbacks from inline buttons
		  when 'address'
			bot.api.send_location(chat_id: message.from.id, latitude: 48.28741845756063, longitude: 25.93809926949383)
			bot.api.send_message(chat_id: message.from.id, text: "Заходьте до нас за адресою:\n➡️ вул. О.Кобилянської, 30, Чернівці, Україна")
		  when 'contacts'
		  	bot.api.send_message(chat_id: message.from.id, text: "☎️ +38 (066) 378 13 16\nЧекаємо на Ваш дзвінок!")
		  when 'quotes'
		  	bot.api.send_message(chat_id: message.from.id, text: QUOTES.sample)
		  when 'words'		  		
			bot.api.send_message(chat_id: message.from.id, text: "Оберіть, будь ласка, тему:\n/family\n/animals\n/food")
		  when 'schedule'
		  	kb2 = [
				Telegram::Bot::Types::KeyboardButton.new(text: 'ПН'),
				Telegram::Bot::Types::KeyboardButton.new(text: 'ВТ'),
				Telegram::Bot::Types::KeyboardButton.new(text: 'СР'),
				Telegram::Bot::Types::KeyboardButton.new(text: 'ЧТ'),
				Telegram::Bot::Types::KeyboardButton.new(text: 'ПТ')
		  	],
		  	[
		  		Telegram::Bot::Types::KeyboardButton.new(text: 'Субота'),
		  		Telegram::Bot::Types::KeyboardButton.new(text: 'НЕДІЛЯ')
		  	],
		  	[
		  		Telegram::Bot::Types::KeyboardButton.new(text: '/menu')
		  	]
			markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb2)
			bot.api.send_message(chat_id: message.from.id, text: "Оберіть, будь ласка, день:", reply_markup: markup)
			Telegram::Bot::Types::KeyboardButton.new(remove_keyboard: true)
		   end


		when Telegram::Bot::Types::Message
		case message.text()
		when "/start"
			bot.api.send_message(chat_id: message.chat.id, text: "Привіт, #{message.from.first_name}!\n
Вас вітає англійський мовний центр Americana! 🇺🇸\n
Ми пишаємось тим, що у нас працюють найкращі викладачі англійської у місті Чернівці!
📌 Наші викладачі - досвічені та мають всесвітньо відомі сертифікації Cambridge CELTA, DELTA, CELT-P, CELT-S, TKT та СAE. 
📌 Окрім цього, опанувати іноземні мови Вам допоможуть носії мови.\n\nДля початку роботи з ботом, натисніть, будь ласка:\n/menu", reply_markup: markup)

		when "/menu"
			kb = [
			    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Перейти на веб-сайт', url: 'http://americanaenglish.com/')
			],
			[
			    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Наше місцезнаходження', callback_data: 'address'),
			    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Контакти', callback_data: 'contacts')
			],
			[
			    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Вивчити нові слова', callback_data: 'words'),
			    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Цитата дня', callback_data: 'quotes')
			],
			[
		  		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Поділитись ботом', switch_inline_query: 'Привіт! Подивись на цей бот! Це чудова можливість вивчити англійську!')
			],
			[
			    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Графік роботи', callback_data: 'schedule'),
			]
		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
		bot.api.send_message(chat_id: message.chat.id, text: "МЕНЮ:", reply_markup: markup)

		when "/stop"
			bot.api.send_message(chat_id: message.chat.id, text: "Гарного дня, #{message.from.first_name}!\nДо зустрічі! 🙂")

		when "/food"
			bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("pictures/food/#{WORDPIC.sample}", "pictures/food/#{WORDPIC.sample}"))
			bot.api.send_message(chat_id: message.from.id, text: "Ще одне слово?\n/family\n/animals\n/food\nПовернутись до меню:\n/menu")
		when "/animals"
			bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("pictures/animals/#{WORDPIC.sample}", "pictures/animals/#{WORDPIC.sample}"))
			bot.api.send_message(chat_id: message.from.id, text: "Ще одне слово?\n/family\n/animals\n/food\nПовернутись до меню:\n/menu")
		when "/family"
			bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("pictures/family/#{WORDPIC.sample}", "pictures/family/#{WORDPIC.sample}"))
			bot.api.send_message(chat_id: message.from.id, text: "Ще одне слово?\n/family\n/animals\n/food\nПовернутись до меню:\n/menu")

		when "ПН","ВТ","СР","ЧТ","ПТ"
			bot.api.send_message(chat_id: message.chat.id, text: "Ми працюємо:\n9:00 - 19:00\n\nОбідня перерерва:\n13:00 - 14:00\n\nЧекаємо на зустріч з Вами!")
		when "Субота"
			bot.api.send_message(chat_id: message.chat.id, text: "12:00 - 16:00\nЧекаємо на зустріч з Вами!")
		when "НЕДІЛЯ"
			bot.api.send_message(chat_id: message.chat.id, text: "Неділя вихідний\nАле ми з нетерпінням чекаємо на Вас в робочі дні!")

		else
      		bot.api.send_message(chat_id: message.chat.id, text: "Ой, це невідома команда для мене :(\nСпробуйте:
      		/start
      		/menu
        	/stop")	
  		end 	
	end
end
end
