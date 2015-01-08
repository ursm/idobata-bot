require "./idobata/idobata.rb"
require "./zoi-chan-bot.rb"

zoichan = Idobata::ZoiChanBot.new()
zoichan.run()
