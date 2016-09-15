require "date"
@students = []

def interactive_menu
  action = ""
  until action == "9"
    print_menu
    action = gets.strip
    process(action)
  end
  puts "Goodbye!"
end

def print_menu
  print "\nWhat would you like to do? "
  puts "Enter a number to make your selection."
  puts "1. Input students"
  puts "2. Show students"
  puts "3. Search for students"
  puts "9. Exit"
end

def pluralize(num, word)
  num == 1 ? word : word + "s"
end

def get_user_input(prompt, default="")
  print prompt + ": "
  input = gets.strip
  input.empty? ? default : input
end

def get_current_month
  Time.now.strftime("%B")
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

    @students << { name: name, cohort: cohort, age: age, nationality: nationality, hobbies: hobbies }
    puts "#{@students.count} new #{pluralize(@students.count, "student")} enrolled"
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
  number = students.count
  footer = message.nil? ? "Altogether, we have #{number} great #{pluralize(number, "student")}" : message
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
    search_term = gets.strip.downcase
    filtered_students = @students.select { |student| student[:name].downcase.start_with?(search_term) }
    if filtered_students.empty?
      puts "No students found matching '#{search_term}'."
    else
      message = "#{filtered_students.count} #{pluralize(filtered_students.count, "student")} found"
      show_students(filtered_students, message)
    end
  end
end

def process(action)
  case action
  when "1"
    input_students
  when "2"
    show_students(@students)
  when "3"
    search_students
  end
end

interactive_menu
