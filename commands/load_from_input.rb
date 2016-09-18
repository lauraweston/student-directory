require_relative "load_students.rb"

class LoadFromInputCommand

  def initialize(students=[])
  end

  def execute
    puts "Which file do you want to load?"
    filename = STDIN.gets.strip
    filename += ".csv" if !filename.end_with?(".csv")
    LoadStudentsCommand.new(filename).execute
  end
end
