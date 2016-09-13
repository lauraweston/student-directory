def ask_for_action
  puts "What would you like to do?"
  action = ""
  student_list = []
  until action == "x"
    puts "\nEnter A to Add students, S to Search students or X to exit."
    action = gets.downcase.chomp
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

    puts "#{students.count} new students have been enrolled"
    name = get_user_input("Please enter the name of a student").capitalize
  end
  students
end

def get_user_input(prompt, default="")
  print prompt + ": "
  input = gets.chomp
  return default if input.empty?
  input
end

def get_current_month
  Time.now.strftime("%B")
end

def search(students)
  puts "To search for students, enter the first letter or first few letters of the name and press Enter."
  search_term = gets.downcase.chomp
  filtered_student_list = students.select do |student|
    student[:name].downcase.start_with?(search_term)
  end
  print_students(filtered_student_list)
end

def print_students(students)
  print_header
  i = 0
  while i < students.length
    student = students[i]
    if student[:name].length < 12
      number = (i + 1).to_s
      name = student[:name]
      cohort = student[:cohort].to_s.capitalize
      nationality = student[:nationality]
      age = student[:age].to_s
      hobbies = student[:hobbies]
      puts "#{number.rjust(4)} #{name.ljust(20)}#{cohort.ljust(20)}#{nationality.ljust(20)}#{age.ljust(10)}#{hobbies.ljust(25)}"
    end
    i += 1
  end
end

def print_header
  puts "Students of Villains Academy\n".upcase.center(100)
  puts "     Name".ljust(25) + "Cohort".ljust(20) + "Nationality".ljust(20) + "Age".ljust(10) + "Hobbies".ljust(25)
  puts ("-" * 100)
end

def print_footer(names)
  puts ("-" * 100)
  puts "Altogether, we have #{names.count} great students"
end

ask_for_action
