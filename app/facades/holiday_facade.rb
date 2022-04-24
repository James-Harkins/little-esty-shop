class HolidayFacade
  def service
    @_nager ||= NagerService.new
  end

  def holiday_data
    binding.pry
    @_holiday_data ||= service.get_holidays
  end

  def holidays
    Holiday.new(holiday_data)
  end
end
