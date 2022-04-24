class HolidayFacade
  def service
    @_nager ||= NagerService.new
  end

  def holiday_data
    @_holiday_data ||= service.get_holidays
  end

  def next_three_holidays
    holidays = []
    holiday_data[0..2].each do |holiday_sub_data|
      holidays << Holiday.new(holiday_sub_data)
    end
    holidays
  end
end
