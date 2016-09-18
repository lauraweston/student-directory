require_relative "commands/load_from_command_line.rb"
require_relative "commands/input_students.rb"
require_relative "commands/show_students.rb"
require_relative "commands/search_students.rb"
require_relative "commands/save_students.rb"
require_relative "commands/load_from_input.rb"
require_relative "commands/exit.rb"

@all_students = []
@menu = {
  1 => { :description => "Input students", :action => "InputStudentCommand" },
  2 => { :description => "Show students", :action => "ShowStudentsCommand" },
  3 => { :description => "Search for students", :action => "SearchStudentsCommand" },
  4 => { :description => "Save current student list", :action => "SaveStudentsCommand" },
  5 => { :description => "Load a student list", :action => "LoadFromInputCommand" },
  6 => { :description => "Exit", :action => "ExitCommand" }
}

def interactive_menu
  loop do
    print_menu
    selection = STDIN.gets.to_i
    while @menu[selection].nil?
      puts "Please enter a valid number"
      selection = STDIN.gets.to_i
    end
    process_selection(selection)
  end
end

def print_menu
  puts "\nWhat would you like to do?"
  puts "Enter a number to make your selection."
  @menu.each { |number, item| puts "#{number} #{item[:description]}" }
end

def process_selection(selection)
  command_name = @menu[selection][:action]
  command = Object.const_get(command_name).new(@all_students)
  @all_students = command.execute
end

puts
@all_students = LoadFromCommandLine.new.execute
interactive_menu
