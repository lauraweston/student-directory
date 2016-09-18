require "date"
require_relative "../append_student.rb"

class InputStudentCommand

  def initialize(students)
    @all_students = students
  end

  def execute
    name = get_user_input("Enter student's name (or hit return to go back to the menu)").capitalize
    while !name.empty?
      cohort = get_cohort
      nationality = get_user_input("Enter student's nationality (or hit return to skip)", "Unknown").capitalize
      age = get_age
      hobbies = get_user_input("Enter student's hobbies (or hit return to skip)", "Unknown")
      @all_students = append_student_to_list(@all_students, name, cohort, nationality, age, hobbies)
      puts "#{name} has been registered."
      name = get_user_input("Enter student's name").capitalize
    end
    @all_students
  end

  private

  def get_user_input(prompt, default="")
    print prompt + ": "
    input = STDIN.gets.strip
    input.empty? ? default : input
  end

  def check_cohort_valid(cohort)
    valid_cohorts = Date::MONTHNAMES
    valid_cohorts.include?(cohort.capitalize)
  end

  def get_current_month
    Time.now.strftime("%B")
  end

  def get_cohort
    cohort = ""
    until check_cohort_valid(cohort)
      cohort = get_user_input("Enter student's cohort (must be a month, e.g. May, or hit return to use current month)", get_current_month).downcase
    end
    cohort.to_sym
  end

  def get_age
    age = ""
    until age.to_i > 0 || age == "Unknown"
      age = get_user_input("Enter student's age (enter a number greater than 0, e.g. 30, or hit return to skip)", "Unknown")
    end
    age
  end

end
