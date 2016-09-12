def ask_for_action
  puts "What would you like to do?"
  action = ""
  while action
    case action
      when "a"
        students = input_students
        print_header
        print(students)
        print_footer(students)
        action = ""
      when "s"
        # Call select students method
      when "x"
        puts "Goodbye!"
        exit
      else
        puts "Enter A to Add students, S to Search students or X to exit."
        action = gets.downcase.chomp
    end
  end

end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  # Create an empty array
  students = []
  # Get the first name
  name = gets.chomp
  # While the name is not empty, repeat this code
  while !name.empty? do
    # Add the student hash to the array
    students << {name: name, cohort: :november}
    puts "Now we have #{students.count} students"
    # Get another name from the user
    name = gets.chomp
  end
  # return the array of students
  students
end

def select_students_starting

end

def print_header
  puts "The students of Villains Academy"
  puts "------------"
end

def print(students)
  students.each_with_index do |student, i|
    puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_footer(names)
  puts "Overall, we have #{names.count} great students"
end

ask_for_action
