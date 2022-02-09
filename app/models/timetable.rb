require_relative 'course'
require_relative 'student'

class Timetable

    def Timetable.build_with(teachers, students)
        possible_courses = []
        
        # Create possible courses given teachers time slots
        teachers.each do |teacher|
            teacher.slots.each do |slot|
                Student::LEVELS.each do |level|
                    Student::MODES.each do |mode|
                        possible_courses << Course.new(slot, teacher, level, mode)
                    end
                end
            end 
        end

        possible_courses_by_slot = possible_courses.group_by(&:slot)

        # I assume that a Group is valid if there are more than one student
        valid_group_students = (students.select { |students| students.mode == 'GROUP' }.
                               group_by(&:level).select { |level, students| students.length > 1 }.values.flatten! || [])
        
        valid_students = valid_group_students + students.select { |students| students.mode == 'INDIVIDUAL' }
        
        valid_students.each do |student|
            student.slots.each do |slot|
                if possible_courses_by_slot.key?(slot)
                    possible_courses_by_slot[slot].each do |course|
                        if ((course.level == student.level) and 
                            (course.mode == student.mode) and 
                            (course.students.count < Course::MAX_SIZE))
                            if (course.mode == 'GROUP') or (course.mode == 'INDIVIDUAL' and course.students.count == 0)
                                course.students << student
                                course.valid = true
                                if course.mode == 'INDIVIDUAL'
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end

        possible_courses.filter(&:valid)
    end

end

