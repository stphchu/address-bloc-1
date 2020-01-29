require_relative 'controllers/menu_controller'
require 'bloc_record'

BlocRecord.connect_to("db/address_bloc.sqlite")

menu = MenuController.new
system "clear"
puts "Welcome to AddressBloc!\n\n"
menu.main_menu
