require "date"
@students = []

def try_load_students
  filename = ARGV.first #first argument from the command line
  return if filename.nil? # get out of the method if load file not given
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{pluralize(@students.count, "student")} from #{filename}."
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

def interactive_menu
  action = ""
  until action == "9"
    print_menu
    action = STDIN.gets.strip
    process_action(action)
  end
  puts "Goodbye!"
end

def print_menu
  print "\nWhat would you like to do? "
  puts "Enter a number to make your selection."
  puts "1. Input students"
  puts "2. Show students"
  puts "3. Search for students"
  puts "4. Save student list to students.csv"
  puts "5. Load student list from students.csv"
  puts "9. Exit"
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
  @students << { name: name, cohort: cohort, age: age, nationality: nationality, hobbies: hobbies }
end

def input_students
  puts "To return to the menu, just hit return twice\n"
  name = get_user_input("Please enter the name of a student").capitalize
  while !name.empty?
    cohorts = [:january, :february, :march, :april, :may, :june, :july, :august, :september, :october, :november, :december]
    cohort = nil
    until cohorts.include?(cohort)
      cohort = get_user_input("Cohort", get_current_month).downcase.to_sym
    end
    nationality = get_user_input("Nationality", "Unknown").capitalize
    age = get_user_input("Age", "Unknown")
    hobbies = get_user_input("Hobbies", "Unknown")

    append_student_to_list(name, cohort, nationality, age, hobbies)
    puts "#{pluralize(@students.count, "student")} enrolled"
    name = get_user_input("Please enter the name of a student").capitalize
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
  i = 0
  while i < sorted_by_cohort.length
    student = sorted_by_cohort[i]
    number = (i + 1).to_s.rjust(4)
    name = student[:name].ljust(20)
    cohort = student[:cohort].to_s.capitalize.ljust(20)
    nationality = student[:nationality].ljust(20)
    age = student[:age].to_s.ljust(10)
    hobbies = student[:hobbies].ljust(25)
    puts number + " " + name + cohort + nationality + age + hobbies
    i += 1
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
  # open the file for writing
  file = File.open("students.csv", "w")
  # iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort], student[:nationality],
                    student[:age], student[:hobbies]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
  puts "#{pluralize(@students.count, "student")} saved!"
end

def load_students(filename="students.csv")
  puts "Loading..."
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, cohort, nationality, age, hobbies = line.chomp.split(",")
    append_student_to_list(name, cohort, nationality, age, hobbies)
  end
  file.close
  show_students(@students)
end

def process_action(action)
  case action
  when "1"
    input_students
  when "2"
    show_students(@students)
  when "3"
    search_students
  when "4"
    save_students
  when "5"
    load_students
  end
end

try_load_students
interactive_menu
