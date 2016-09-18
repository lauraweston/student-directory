require "csv"
require_relative "../text_utilities.rb"

class SaveStudentsCommand

  def initialize(students)
    @all_students = students
  end

  def execute
    filename = ""
    until !filename.empty?
      puts "Please enter a name for the list:"
      filename = gets.strip
    end
    filename += ".csv" if !filename.end_with?(".csv")
    CSV.open(filename, "w") do |csv|
      @all_students.each do |student|
        student_data = [student[:name], student[:cohort], student[:nationality],
                        student[:age], student[:hobbies]]
        csv << student_data
      end
    end
    puts "#{pluralize(@all_students.count, "student")} saved to #{filename}"
    @all_students
  end

end
