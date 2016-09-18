require "date"
require "csv"
@students = []

def load_students_from_command_line
  filename = ARGV.first #first argument from the command line
  filename = "students.csv" if filename.nil?
  load_students(filename)
end

def pluralize(num, word)
  num == 1 ? "#{num} #{word}" : "#{num} #{word}s"
end

def get_user_input(prompt, default="")
  print prompt + ": "
  input = STDIN.gets.strip
  input.empty? ? default : input
end

def get_current_month
  Time.now.strftime("%B")
end

def append_student_to_list(name, cohort, nationality, age, hobbies)
  if !name.nil? && !name.empty?
    @students << { name: name, cohort: cohort, age: age, nationality: nationality, hobbies: hobbies }
  end
end

def check_cohort_valid(cohort)
  valid_cohorts = Date::MONTHNAMES
  valid_cohorts.include?(cohort.capitalize)
end

def get_cohort
  cohort = ""
  until check_cohort_valid(cohort)
    cohort = get_user_input("Enter student's cohort (must be a month, e.g. May, or hit return to use current month)", get_current_month).downcase
  end
  cohort.to_sym
end

def get_age
  age = ""
  until age.to_i > 0 || age == "Unknown"
    age = get_user_input("Enter student's age (enter a number greater than 0, e.g. 30, or hit return to skip)", "Unknown")
  end
  age
end

def input_students
  name = get_user_input("Enter student's name (or hit return to go back to the menu)").capitalize
  while !name.empty?
    cohort = get_cohort
    nationality = get_user_input("Enter student's nationality (or hit return to skip)", "Unknown").capitalize
    age = get_age
    hobbies = get_user_input("Enter student's hobbies (or hit return to skip)", "Unknown")
    append_student_to_list(name, cohort, nationality, age, hobbies)
    puts "#{name} has been registered."
    name = get_user_input("Enter student's name").capitalize
  end
end

def print_header
  puts "Students of Villains Academy\n".upcase.center(100)
  puts "     Name".ljust(25) + "Cohort".ljust(20) + "Nationality".ljust(20) + "Age".ljust(10) + "Hobbies".ljust(25)
  puts ("-" * 100)
end

def select_names_less_than_12(students)
  students.select { |student| student[:name].length < 12 }
end

def sort_by_cohort(students)
  students.sort do |a, b|
    Date::MONTHNAMES.index(a[:cohort].to_s.capitalize) <=> Date::MONTHNAMES.index(b[:cohort].to_s.capitalize)
  end
end

def print_students(students)
  names_less_than_12 = select_names_less_than_12(students)
  sorted_by_cohort = sort_by_cohort(names_less_than_12)
  sorted_by_cohort.each_with_index do | student, index |
    number = (index + 1).to_s
    name = student[:name]
    cohort = student[:cohort].to_s.capitalize
    nationality = student[:nationality]
    age = student[:age]
    hobbies = student[:hobbies].capitalize
    puts number.rjust(4) + " " + name.ljust(20) + cohort.ljust(20) + nationality.ljust(20) + age.ljust(10) + hobbies.ljust(25)
  end
end

def print_footer(students, message)
  puts ("-" * 100)
  footer = message.nil? ? "Altogether, we have #{pluralize(students.count, "student")}" : message
  puts footer
end

def show_students(students, message=nil)
  if !students.empty?
    print_header
    print_students(students)
    print_footer(students, message)
  else
    puts "We have no current students"
  end
end

def show_all_students
  show_students(@students)
end

def search_students
  if @students.empty?
    puts "We have no current students"
  else
    puts "To search for students, enter the first letter or first few letters of the name and press Enter."
    search_term = STDIN.gets.strip.downcase
    filtered_students = @students.select { |student| student[:name].downcase.start_with?(search_term) }
    if filtered_students.empty?
      puts "No students found matching '#{search_term}'."
    else
      message = "#{pluralize(filtered_students.count, "student")} found"
      show_students(filtered_students, message)
    end
  end
end

def save_students
  filename = ""
  until !filename.empty?
    puts "Please enter a name for the list:"
    filename = gets.strip
  end
  filename += ".csv" if !filename.end_with?(".csv")
  CSV.open(filename, "w") do |csv|
    @students.each do |student|
      student_data = [student[:name], student[:cohort], student[:nationality],
                      student[:age], student[:hobbies]]
      csv << student_data
    end
  end
  puts "#{pluralize(@students.count, "student")} saved to #{filename}"
end

def load_students_from_user_input
  puts "Which file do you want to load?"
  filename = STDIN.gets.strip
  filename += ".csv" if !filename.end_with?(".csv")
  load_students(filename)
end

def load_students(filename)
  if !File.exist?(filename)
    puts "#{filename} not found. Load student list skipped."
    return
  end

  puts "Loading from #{filename}"
  @students = []
  CSV.foreach(filename, "r") do |row|
      name, cohort, nationality, age, hobbies = row
      append_student_to_list(name, cohort, nationality, age, hobbies)
  end
  show_students(@students)
  puts "Loaded #{pluralize(@students.count, "student")} from #{filename}."
end

def exit_directory
  puts "Goodbye!"
  exit
end

def process_selection(selection)
  @menu[selection][:action].call
end

@menu = {
  1 => { :description => "Input students", :action => method(:input_students) },
  2 => { :description => "Show students", :action => method(:show_all_students) },
  3 => { :description => "Search for students", :action => method(:search_students) },
  4 => { :description => "Save current student list", :action => method(:save_students) },
  5 => { :description => "Load a student list", :action => method(:load_students_from_user_input) },
  6 => { :description => "Exit", :action => method(:exit_directory) }
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

puts
load_students_from_command_line
interactive_menu
