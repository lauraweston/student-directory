require "date"
require_relative "../text_utilities.rb"

class ShowStudentsCommand

  def initialize(students, message=nil)
    @students = students
    @message = message
  end

  def execute
    if !@students.empty?
      print_header
      print_students
      print_footer
    else
      puts "We have no current students"
    end
    @students
  end

  private

  def print_header
    puts "Students of Villains Academy\n".upcase.center(100)
    puts "     Name".ljust(25) + "Cohort".ljust(20) + "Nationality".ljust(20) + "Age".ljust(10) + "Hobbies".ljust(25)
    puts ("-" * 100)
  end

  #def select_names_less_than_12
  #  @students.select { |student| student[:name].length < 12 }
  #end

  def truncate_names_greater_than_12(name)
    name.length > 12 ? "#{name[0, 12]}..." : name
  end

  def sort_by_cohort
    @students.sort do |a, b|
      Date::MONTHNAMES.index(a[:cohort].to_s.capitalize) <=> Date::MONTHNAMES.index(b[:cohort].to_s.capitalize)
    end
  end

  def print_students
    sorted_by_cohort = sort_by_cohort
    sorted_by_cohort.each_with_index do | student, index |
      number = (index + 1).to_s
      name = truncate_names_greater_than_12(student[:name])
      cohort = student[:cohort].to_s.capitalize
      nationality = student[:nationality]
      age = student[:age]
      hobbies = student[:hobbies].capitalize
      puts number.rjust(4) + " " + name.ljust(20) + cohort.ljust(20) + nationality.ljust(20) + age.ljust(10) + hobbies.ljust(25)
    end
  end

  def print_footer
    puts ("-" * 100)
    footer = @message.nil? ? "Altogether, we have #{pluralize(@students.count, "student")}" : @message
    puts footer
  end

end
