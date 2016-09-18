class ExitCommand

  def initialize(students)
    @students = students
  end

  def execute
    puts "Goodbye!"
    exit
  end
end
