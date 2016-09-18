require_relative "show_students.rb"
require_relative "../text_utilities.rb"

class SearchStudentsCommand

  def initialize(students)
    @all_students = students
  end

  def execute
    if @all_students.empty?
      puts "We have no current students"
    else
      puts "To search for students, enter the first letter or first few letters of the name and press return."
      search_term = STDIN.gets.strip.downcase
      filtered_students = @all_students.select { |student| student[:name].downcase.start_with?(search_term) }
      if filtered_students.empty?
        puts "No students found matching '#{search_term}'."
      else
        message = "#{pluralize(filtered_students.count, "student")} found"
        ShowStudentsCommand.new(filtered_students, message).execute
      end
    end
    @all_students
  end

end
