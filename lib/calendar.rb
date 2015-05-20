class Calendar < Struct.new(:view, :date, :callback)
    HEADER = %W[\s 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 19 30 31]
    MONATE = %w[Januar Februar März April Mai Juni Juli August September Oktober November Dezember]
 
    delegate :content_tag, to: :view
 
    def table year=2014
      content_tag :table, class: "calendar table table-bordered table-condensed" do
        header + month_rows(year)
      end
    end
 
    def header
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end
 
    def month_rows(year)
      months(year).map do |name, month|
        content_tag :tr do
          all = []
          all << month_name_cell(name)
          all.concat(month.map { |day| day_cell(day) })
          all.join.html_safe
        end
      end.join.html_safe
    end
    
    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end
 
    def month_name_cell(name)
      content_tag :th, name.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end
 
    def day_classes(day)
      classes = []
      classes << "active" if day.saturday? || day.sunday?
      classes << "today" if day == Date.today
      classes << "not-month" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end
 
    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
    
    def months(year) 
      months = Hash.new
      month_number = 1
      MONATE.each do |monat|
        date =  Date.new(year,month_number,1)
        month_begin = date.beginning_of_month
        month_end = date.end_of_month
        months[monat] = (month_begin..month_end).to_a
        month_number += 1
      end 
      months
    end
end
