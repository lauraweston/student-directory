require "csv"
require_relative "../text_utilities.rb"
require_relative "show_students.rb"
require_relative "../append_student.rb"

class LoadStudentsCommand

  def initialize(filename)
    @filename = filename
  end

  def execute
    if !File.exist?(@filename)
      puts "#{@filename} not found. Load student list skipped."
      return
    end

    puts "Loading from #{@filename}"
    students_to_load = []
    CSV.foreach(@filename, "r") do |row|
        name, cohort, nationality, age, hobbies = row
        students_to_load = append_student_to_list(students_to_load, name, cohort, nationality, age, hobbies)
    end
    message = "Loaded #{pluralize(students_to_load.count, "student")} from #{@filename}."
    ShowStudentsCommand.new(students_to_load, message).execute
    students_to_load
  end

end
