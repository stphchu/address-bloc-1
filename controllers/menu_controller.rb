require_relative '../models/address_book'

class MenuController
  attr_reader :address_book

  def initialize
    @address_book = AddressBook.first
  end

# main_menu
  def main_menu
    puts "\"#{@address_book.name}\" Address Book Selected\n[#{@address_book.entries.count} entries]\n\n"
    puts "0 - Switch AddressBook"
    puts "1 - View all entries"
    puts "2 - Create an entry"
    puts "3 - Search for an entry"
    puts "4 - Import entries from a CSV"
    puts "5 - Exit"
    print "\nEnter your selection: "

    selection = gets.chomp
# test to avoid "enter" returning as 0
    if selection.empty?
      system "clear"
      main_menu
    else
      selection = selection.to_i
    end

    case selection
      when 0
        system "clear"
        select_address_book_menu
        main_menu
      when 1
        system "clear"
        view_all_entries
        main_menu
      when 2
        system "clear"
        create_entry
        main_menu
      when 3
        system "clear"
        search_entries
        main_menu
      when 4
        system "clear"
        read_csv
        main_menu
      when 5
        puts "\n** Good-bye! **\n\n"
        exit(0)
      else
        system "clear"
        puts "Sorry, that is not a valid input\n\n"
        main_menu
    end
  end

# select_address_book_menu
  def select_address_book_menu
    puts "Select an Address Book:"
    AddressBook.all.each_with_index do |address_book, index|
      if @address_book.id == index + 1
        current_text = "[Current]"
      else
        current_text = ""
      end
        puts "#{index} - #{address_book.name} (#{address_book.entries.count} entries) #{current_text}"
    end

    print "\nSelection: "
# test to avoid "enter" returning as 0
    index = gets.chomp
    if index.empty?
      system "clear"
      main_menu
    else
      index = index.to_i
    end

    address_book_temp = AddressBook.find(index + 1)
    system "clear"
    if address_book_temp
      @address_book = address_book_temp
      return @address_book
    end
    puts "** Please select a valid index **\n\n"
    select_address_book_menu
  end

# view_all_entries
  def view_all_entries
    @address_book.entries.each do |entry|
      system "clear"
      puts entry.to_s
      entry_submenu(entry)
    end
    system "clear"
    puts "*** End of entries ***\n\n"
  end

# create_entry
  def create_entry
    system "clear"
    puts "New AddressBloc Entry"
    print "Name: "
    name = gets.chomp
    print "Phone number: "
    phone = gets.chomp
    print "Email: "
    email = gets.chomp

    address_book.add_entry(name, phone, email)

    system "clear"
    puts "** New entry created **\n\n"
  end

# search_entries
  def search_entries
    print "Search by name: "
    name = gets.chomp
    match = @address_book.find_entry(name)
    system "clear"

    if !match.empty?
      puts match.to_s
      search_submenu(match)
    else
      puts "** No match found for #{name} **\n\n"
    end
  end

# read_csv
  def read_csv
    print "Enter CSV file to import: "
    file_name = gets.chomp

    if file_name.empty?
      system "clear"
      puts "No CSV file read"
      main_menu
    end

    begin
      entry_count = address_book.import_from_csv(file_name).count
      system "clear"
      puts "#{entry_count} new entries added from #{file_name}"
    rescue
      puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
      read_csv
    end
  end

# entry_submenu
  def entry_submenu(entry)
    puts "\n"
    puts "n - next entry"
    puts "d - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"

    puts "\n"
    selection = gets.chomp

    case selection
      when "n"
      when "d"
        delete_entry(entry)
      when "e"
        edit_entry(entry)
        entry_submenu(entry)
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        entry_submenu(entry)
    end
  end

# delete_entry
  def delete_entry(entry)
    address_book.entries.delete(entry)
    puts "#{entry.name} has been deleted"
  end

# edit_entry
  def edit_entry(entry)
    updates = {}
    print "Updated name: "
    name = gets.chomp
    updates[:name] = name unless name.empty?
    print "Updated phone number: "
    phone_number = gets.chomp
    updates[:phone_number] = phone_number unless phone_number.empty?
    print "Updated email: "
    email = gets.chomp
    updates[:email] = email unless email.empty?

    entry.update_attributes(updates)
    system "clear"
    puts "Updated entry:"
    puts Entry.find(entry.id)
  end

# search_submenu
  def search_submenu(entry)
    puts "\nd - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"
    selection = gets.chomp

    case selection
      when "d"
        system "clear"
        delete_entry(entry)
        main_menu
      when "e"
        edit_entry(entry)
        system "clear"
        main_menu
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        puts entry.to_s
        search_submenu(entry)
    end
  end
end
