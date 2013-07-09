module DateExtensions
  
  def self.included(base)
    base.class_eval do
      def shipping_week
      	next_thursday = self + ((4 - self.wday) % 7)
	    shipping_week = next_thursday.day / 7 + 1
	    shipping_week = self.five_fridays_in_month? ? 5 : 1 if shipping_week == 5
	    shipping_week
      end

      def five_fridays_in_month?
      	fridays = (self.beginning_of_month..self.end_of_month).to_enum.select { |day| day.wday == 5 }
      	fridays.count == 5
      end
    end
  end

end

Date.send(:include, DateExtensions)