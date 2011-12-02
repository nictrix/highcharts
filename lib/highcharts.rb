require "highcharts/version"

module Highcharts
	module Charting
		attr_accessor :title, :subtitle, :drilldown, :start, :end, :style, :x, :y, :maximum, :minimum, :sla, :series, :categories

		def initialize(user_supplied_hash={})
			standard_hash = { title:"", subtitle:"", drilldown:"", start:"", end:"", style:"",
				x:"", y:"", maximum:"", minimum:"", sla:9999999, series:[], categories:[] }

			user_supplied_hash = standard_hash.merge(user_supplied_hash)

			user_supplied_hash.each do |key,value|
				self.instance_variable_set("@#{key}", value)
				self.class.send(:define_method, key, proc{self.instance_variable_get("@#{key}")})
				self.class.send(:define_method, "#{key}=", proc{|x| self.instance_variable_set("@#{key}", x)})
			end
		end

		def self.get_x_axis_choices
			return [ "month", "week", "day" ]
		end

		def self.get_style_choices
			return [ "line", "spline", "area", "areaspline", "column", "bar", "pie", "scatter" ]
		end

		def to_hc
			hc_hash = {}

			hc_hash.store(:categories,@categories)
			hc_hash.store(:drilldown,@drilldown)
			hc_hash.store(:start,@start)
			hc_hash.store(:end,@end)
			hc_hash.store(:maximum,@maximum)
			hc_hash.store(:minimum,@minimum)
			hc_hash.store(:series,@series)
			hc_hash.store(:sla,@sla)
			hc_hash.store(:style,@style)
			hc_hash.store(:subtitle,@subtitle)
			hc_hash.store(:title,@title)
			hc_hash.store(:x,@x)
			hc_hash.store(:y,@y)

			return hc_hash
		end

		#Need to fix this to include hours also
		def self.transform_x_axis(x_axis)
			case x_axis
			when 'month'
				return 31
			when 'week'
				return 7
			when 'day'
				return 1
			else
				return x_axis
			end
		end

		def self.difference_between_two_dates(start_time,end_time,x_axis)
			x_axis = Highcharts::Charting.transform_x_axis(x_axis)

			return ((Date.strptime(end_time) - Date.strptime(start_time)) / x_axis).to_i
		end

		#Need to fix this to include hours also
		def self.create_array_of_dates(start_time,end_time,x_axis)
			old_x_axis = x_axis
			x_axis = Highcharts::Charting.transform_x_axis(x_axis)

			x_amount = Highcharts::Charting.difference_between_two_dates(start_time,end_time,x_axis)

			categories = Array.new
			categories << Time.parse(start_time+" 00:00:00")
			for range in 1..x_amount
				if old_x_axis == "month"
					categories << Time.parse(start_time+" 00:00:00") + range.month
				else
					categories << Time.parse(start_time+" 00:00:00") + (x_axis * range).days
				end
			end

			return categories
		end

		def fix_categories
			x = []
			@categories.each do |category|
				x << category.strftime("%m-%d")
			end

			@categories = x
		end
	end
end
