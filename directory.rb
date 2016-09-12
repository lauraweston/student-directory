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
        filtered_student_list = search(student_list)
        print_students(filtered_student_list)
    end
  end
  puts "Goodbye!"
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  # Create an empty array
  students = []
  # Get the first name
  name = gets.capitalize.chomp
  # While the name is not empty, repeat this code
  while !name.empty? do
    # Add the student hash to the array
    students << {name: name, cohort: :november}
    puts "#{students.count} new students have been enrolled"
    # Get another name from the user
    name = gets.capitalize.chomp
  end
  # return the array of students
  students
end

def search(students)
  puts "To search for students, enter the first letter or first few letters of the name and press Enter."
  search_term = gets.downcase.chomp
  students.select do |student|
    student[:name].downcase.start_with?(search_term)
  end
end

def print_students(students)
  print_header
  i = 0
  while i < students.length
    student = students[i]
    if student[:name].length < 12
      puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
    end
    i += 1
  end
end

def print_header
  puts "The students of Villains Academy"
  puts "------------"
end

def print_footer(names)
  puts "------------"
  puts "Altogether, we have #{names.count} great students"
end

ask_for_action
