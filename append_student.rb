def append_student_to_list(students, name, cohort, nationality, age, hobbies)
  if !name.nil? && !name.empty?
    students << { name: name, cohort: cohort, age: age, nationality: nationality, hobbies: hobbies }
  end
  students
end
