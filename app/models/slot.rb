class Slot

    class ValueError < StandardError; end

    attr_reader :day, :hour

    DAYS = %w[MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY].freeze
    HOURS = %i[8 9 10 11 12 13 14 15 16 17 18 19].freeze

    def initialize(day, hour)
        raise ValueError unless DAYS.include?(day) && HOURS.include?(hour)
        @day = day
        @hour = hour
    end

end
