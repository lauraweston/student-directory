require_relative "load_students.rb"

class LoadFromCommandLine

  def execute
    filename = ARGV.first #first argument from the command line
    filename = "students.csv" if filename.nil?
    LoadStudentsCommand.new(filename).execute
  end
  
end
