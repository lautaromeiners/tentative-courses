require 'rspec'
require_relative '../../app/models/timetable'
require_relative '../../app/models/slot'
require_relative '../../app/models/student'
require_relative '../../app/models/teacher'
require_relative '../../app/models/course'

RSpec.describe Timetable do

    it 'Match individual course' do
        slot = Slot.new('THURSDAY', :'15') 
        student = Student.new('Jose Montoto', [slot], 'INDIVIDUAL', 'BEGINNER')
        teacher = Teacher.new('Domingo Sarmiento', [slot])

        courses = Timetable.build_with([teacher], [student])
        course = courses.first

        expect(courses.count).to          eq(1)
        expect(course.slot.day).to        eq('THURSDAY')
        expect(course.slot.hour).to       eq(:'15')
        expect(course.teacher).to         eq(teacher)
        expect(course.students).to        eq([student])
        expect(course.level).to           eq('BEGINNER')
        expect(course.mode).to            eq('INDIVIDUAL')
    end

    it 'No match for time slots' do
        student_slot = Slot.new('THURSDAY', :'15')
        teacher_slot = Slot.new('THURSDAY', :'10') 
        student = Student.new('Jose Montoto', [student_slot], 'INDIVIDUAL', 'BEGINNER')
        teacher = Teacher.new('Domingo Sarmiento', [teacher_slot])

        courses = Timetable.build_with([teacher], [student])

        expect(courses).to eq([])
    end

    it 'No match because only one student in group' do
        slot = Slot.new('THURSDAY', :'15')
        student = Student.new('Jose Montoto', [slot], 'GROUP', 'BEGINNER')
        teacher = Teacher.new('Domingo Sarmiento', [slot])

        courses = Timetable.build_with([teacher], [student])

        expect(courses).to eq([])
    end

    it 'No match because students of group have different time slots' do
        slot_1 = Slot.new('MONDAY', :'15')
        slot_2 = Slot.new('TUESDAY', :'15')
        slot_3 = Slot.new('WEDNESDAY', :'15')
        slot_4 = Slot.new('FRIDAY', :'15')
        teacher_slot = Slot.new('THURSDAY', :'15')
        student_1 = Student.new('Jose Montoto', [slot_1], 'GROUP', 'BEGINNER')
        student_2 = Student.new('Homero', [slot_2], 'GROUP', 'BEGINNER')
        student_3 = Student.new('Marge', [slot_3], 'GROUP', 'BEGINNER')
        student_4 = Student.new('Bart', [slot_4], 'GROUP', 'BEGINNER')    
        teacher = Teacher.new('Domingo Sarmiento', [teacher_slot])

        courses = Timetable.build_with([teacher], [student_1, student_2, student_3, student_4])

        expect(courses).to eq([])
    end

    it 'Match for group mode' do
        slot = Slot.new('THURSDAY', :'15')
        student_1 = Student.new('Jose Montoto', [slot], 'GROUP', 'BEGINNER')
        student_2 = Student.new('Juan Carlos', [slot], 'GROUP', 'BEGINNER')
        student_3 = Student.new('Maria', [slot], 'GROUP', 'BEGINNER')
        student_4 = Student.new('Mirta', [slot], 'GROUP', 'BEGINNER')
        student_5 = Student.new('Javier', [slot], 'GROUP', 'ADVANCED')        
        teacher = Teacher.new('Domingo Sarmiento', [slot])

        courses = Timetable.build_with([teacher], [student_1, student_2, student_3, student_4, student_5])
        course = courses.first

        expect(courses.count).to          eq(1)
        expect(course.slot.day).to        eq('THURSDAY')
        expect(course.slot.hour).to       eq(:'15')
        expect(course.teacher).to         eq(teacher)
        expect(course.students).to        eq([student_1, student_2, student_3, student_4])
        expect(course.level).to           eq('BEGINNER')
        expect(course.mode).to            eq('GROUP')
    end

    it 'Match for individual mode both students same hour different teachers' do
        slot = Slot.new('THURSDAY', :'15')
        student_1 = Student.new('Jose Montoto', [slot], 'INDIVIDUAL', 'BEGINNER')
        student_2 = Student.new('Juan Carlos', [slot], 'INDIVIDUAL', 'BEGINNER')
        teacher_1 = Teacher.new('Domingo Sarmiento', [slot])
        teacher_2 = Teacher.new('Alicia Moreau de Justo', [slot])

        courses = Timetable.build_with([teacher_1,teacher_2], [student_1, student_2])
        course_1 = courses.first
        course_2 = courses.last


        expect(courses.count).to          eq(2)
        expect(course_1.slot.day).to      eq('THURSDAY')
        expect(course_1.slot.hour).to     eq(:'15')
        expect(course_1.teacher).to       eq(teacher_1)
        expect(course_1.students).to      eq([student_1])
        expect(course_1.level).to         eq('BEGINNER')
        expect(course_1.mode).to          eq('INDIVIDUAL')

        expect(course_2.slot.day).to      eq('THURSDAY')
        expect(course_2.slot.hour).to     eq(:'15')
        expect(course_2.teacher).to       eq(teacher_2)
        expect(course_2.students).to      eq([student_2])
        expect(course_2.level).to         eq('BEGINNER')
        expect(course_2.mode).to          eq('INDIVIDUAL')
    end

    it 'Match for individual mode both teachers same hour. Matches first teacher' do
        slot = Slot.new('THURSDAY', :'15')
        student = Student.new('Jose Montoto', [slot], 'INDIVIDUAL', 'BEGINNER')
        teacher_1 = Teacher.new('Domingo Sarmiento', [slot])
        teacher_2 = Teacher.new('Alicia Moreau de Justo', [slot])

        courses = Timetable.build_with([teacher_1, teacher_2], [student])
        course = courses.first

        expect(courses.count).to        eq(1)
        expect(course.slot.day).to      eq('THURSDAY')
        expect(course.slot.hour).to     eq(:'15')
        expect(course.teacher).to       eq(teacher_1)
        expect(course.students).to      eq([student])
        expect(course.level).to         eq('BEGINNER')
        expect(course.mode).to          eq('INDIVIDUAL')

    end

    it 'Match for groups same time different levels. Ambigous result should provide both groups as valid.' do
        slot = Slot.new('THURSDAY', :'15')
        student_1 = Student.new('Jose Montoto', [slot], 'GROUP', 'BEGINNER')
        student_2 = Student.new('Juan Carlos', [slot], 'GROUP', 'BEGINNER')
        student_3 = Student.new('Maria', [slot], 'GROUP', 'BEGINNER')
        student_4 = Student.new('Mirta', [slot], 'GROUP', 'ADVANCED')
        student_5 = Student.new('Javier', [slot], 'GROUP', 'ADVANCED')
        student_6 = Student.new('Flavia', [slot], 'GROUP', 'ADVANCED')        
        teacher = Teacher.new('Domingo Sarmiento', [slot])

        courses = Timetable.build_with([teacher], [student_1, student_2, student_3, student_4, student_5, student_6])
        course_beginner = courses.first
        course_advanced = courses.last

        expect(courses.count).to                   eq(2)
        
        expect(course_beginner.slot.day).to        eq('THURSDAY')
        expect(course_beginner.slot.hour).to       eq(:'15')
        expect(course_beginner.teacher).to         eq(teacher)
        expect(course_beginner.students).to        eq([student_1, student_2, student_3])
        expect(course_beginner.level).to           eq('BEGINNER')
        expect(course_beginner.mode).to            eq('GROUP')

        expect(course_advanced.slot.day).to        eq('THURSDAY')
        expect(course_advanced.slot.hour).to       eq(:'15')
        expect(course_advanced.teacher).to         eq(teacher)
        expect(course_advanced.students).to        eq([student_4, student_5, student_6])
        expect(course_advanced.level).to           eq('ADVANCED')
        expect(course_advanced.mode).to            eq('GROUP')
    end

    it 'Match for groups same time different levels with two teachers available. Should give all 4 possibilities' do
        slot = Slot.new('THURSDAY', :'15')
        student_1 = Student.new('Jose Montoto', [slot], 'GROUP', 'BEGINNER')
        student_2 = Student.new('Juan Carlos', [slot], 'GROUP', 'BEGINNER')
        student_3 = Student.new('Maria', [slot], 'GROUP', 'BEGINNER')
        student_4 = Student.new('Mirta', [slot], 'GROUP', 'BEGINNER')
        student_5 = Student.new('Javier', [slot], 'GROUP', 'BEGINNER')
        student_6 = Student.new('Flavia', [slot], 'GROUP', 'BEGINNER')  
        student_7 = Student.new('Estela', [slot], 'GROUP', 'ADVANCED')  
        student_8 = Student.new('Federico', [slot], 'GROUP', 'ADVANCED')  
        student_9 = Student.new('Julia', [slot], 'GROUP', 'ADVANCED')        
        teacher_1 = Teacher.new('Domingo Sarmiento', [slot])
        teacher_2 = Teacher.new('Alicia Moreau de Justo', [slot])

        courses = Timetable.build_with([teacher_1, teacher_2], [student_1, student_2, student_3, student_4, student_5, student_6, student_7, student_8, student_9])
        course_1 = courses[0]
        course_2 = courses[1]
        course_3 = courses[2]
        course_4 = courses[3]

        expect(courses.count).to                   eq(4)

        expect(course_1.slot.day).to        eq('THURSDAY')
        expect(course_1.slot.hour).to       eq(:'15')
        expect(course_1.teacher).to         eq(teacher_1)
        expect(course_1.students).to        eq([student_1, student_2, student_3, student_4, student_5, student_6])
        expect(course_1.level).to           eq('BEGINNER')
        expect(course_1.mode).to            eq('GROUP')

        expect(course_2.slot.day).to        eq('THURSDAY')
        expect(course_2.slot.hour).to       eq(:'15')
        expect(course_2.teacher).to         eq(teacher_1)
        expect(course_2.students).to        eq([student_7, student_8, student_9])
        expect(course_2.level).to           eq('ADVANCED')
        expect(course_2.mode).to            eq('GROUP')

        expect(course_3.slot.day).to        eq('THURSDAY')
        expect(course_3.slot.hour).to       eq(:'15')
        expect(course_3.teacher).to         eq(teacher_2)
        expect(course_3.students).to        eq([student_1, student_2, student_3, student_4, student_5, student_6])
        expect(course_3.level).to           eq('BEGINNER')
        expect(course_3.mode).to            eq('GROUP')

        expect(course_4.slot.day).to        eq('THURSDAY')
        expect(course_4.slot.hour).to       eq(:'15')
        expect(course_4.teacher).to         eq(teacher_2)
        expect(course_4.students).to        eq([student_7, student_8, student_9])
        expect(course_4.level).to           eq('ADVANCED')
        expect(course_4.mode).to            eq('GROUP')
    end

    it 'Match for group mode, but maximum students for group mode is 6' do
        slot = Slot.new('THURSDAY', :'15')
        student_1 = Student.new('Jose Montoto', [slot], 'GROUP', 'BEGINNER')
        student_2 = Student.new('Juan Carlos', [slot], 'GROUP', 'BEGINNER')
        student_3 = Student.new('Maria', [slot], 'GROUP', 'BEGINNER')
        student_4 = Student.new('Mirta', [slot], 'GROUP', 'BEGINNER')
        student_5 = Student.new('Javier', [slot], 'GROUP', 'BEGINNER')
        student_6 = Student.new('Ernesto', [slot], 'GROUP', 'BEGINNER')
        student_7 = Student.new('Claudia', [slot], 'GROUP', 'BEGINNER')        
        teacher = Teacher.new('Domingo Sarmiento', [slot])

        courses = Timetable.build_with([teacher], [student_1, student_2, student_3, student_4, student_5, student_6, student_7])
        course = courses.first

        expect(courses.count).to          eq(1)
        expect(course.slot.day).to        eq('THURSDAY')
        expect(course.slot.hour).to       eq(:'15')
        expect(course.teacher).to         eq(teacher)
        expect(course.students).to        eq([student_1, student_2, student_3, student_4, student_5, student_6])
        expect(course.level).to           eq('BEGINNER')
        expect(course.mode).to            eq('GROUP')
    end

end