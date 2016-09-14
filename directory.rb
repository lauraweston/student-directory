require "date"

def ask_for_action
  puts "What would you like to do?"
  action = ""
  student_list = []
  until action == "x"
    puts "\nEnter A to Add students, S to Search students or X to exit."
    action = gets.strip.downcase
    case action
      when "a"
        student_list += input_students
        print_students(student_list)
        print_footer(student_list)
      when "s"
        search(student_list)
    end
  end
  puts "Goodbye!"
end

def input_students
  puts "To return to the menu, just hit return twice\n"
  students = []
  name = get_user_input("Please enter the name of a student").capitalize
  cohorts = [:january, :february, :march, :april, :may, :june, :july, :august, :september, :october, :november, :december]

  while !name.empty? do
    cohort = nil
    until cohorts.include?(cohort)
      cohort = get_user_input("Cohort", get_current_month).downcase.to_sym
    end
    nationality = get_user_input("Nationality", "Unknown").capitalize
    age = get_user_input("Age", "Unknown")
    hobbies = get_user_input("Hobbies", "Unknown")

    students << { name: name, cohort: cohort, age: age, nationality: nationality, hobbies: hobbies }

    puts "#{students.count} new #{pluralize(students.count, "student")} enrolled"
    name = get_user_input("Please enter the name of a student").capitalize
  end
  students
end

def get_user_input(prompt, default="")
  print prompt + ": "
  input = gets.strip
  return default if input.empty?
  input
end

def get_current_month
  Time.now.strftime("%B")
end

def search(students)
  puts "To search for students, enter the first letter or first few letters of the name and press Enter."
  search_term = gets.strip.downcase
  filtered_student_list = students.select do |student|
    student[:name].downcase.start_with?(search_term)
  end
  print_students(filtered_student_list)
end

def print_students(students)
  names_less_than_12 = select_names_less_than_12(students)
  sorted_by_cohort = sort_by_cohort(names_less_than_12)
  print_header
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

def select_names_less_than_12(students)
  students.select { |student| student[:name].length < 12 }
end

def sort_by_cohort(students)
    students.sort do |a, b|
      Date::MONTHNAMES.index(a[:cohort].to_s.capitalize) <=> Date::MONTHNAMES.index(b[:cohort].to_s.capitalize)
    end
end

def pluralize(num, word)
  num == 1 ? word : word + "s"
end

def print_header
  puts "Students of Villains Academy\n".upcase.center(100)
  puts "     Name".ljust(25) + "Cohort".ljust(20) + "Nationality".ljust(20) + "Age".ljust(10) + "Hobbies".ljust(25)
  puts ("-" * 100)
end

def print_footer(names)
  puts ("-" * 100)
  number = names.count
  puts "Altogether, we have #{number} great #{pluralize(number, "student")}"
end

ask_for_action
