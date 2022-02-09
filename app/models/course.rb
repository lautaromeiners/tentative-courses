class Course

    attr_reader :slot, :teacher, :level, :mode

    attr_accessor :students, :valid

    MAX_SIZE = 6

    def initialize(slot, teacher, level, mode)
        @slot = slot
        @teacher = teacher
        @level = level
        @mode = mode
        @students = []
        @valid = false
    end

end