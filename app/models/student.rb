class Student

    class ValueError < StandardError; end

    attr_reader :full_name, :slots, :mode, :level

    MODES = %w[INDIVIDUAL GROUP].freeze
    LEVELS = %w[BEGINNER PRE_INTERMEDIATE INTERMEDIATE
                UPPER_INTERMEDIATE ADVANCED].freeze  

    def initialize(full_name, slots, mode, level)
        raise ValueError unless LEVELS.include?(level) && MODES.include?(mode)
        @full_name = full_name
        @slots = slots
        @mode = mode
        @level = level
    end

end
