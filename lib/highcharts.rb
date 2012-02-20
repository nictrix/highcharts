require "highcharts/version"

require 'ice_cube'
require 'time'
require 'date'

module Highcharts
	module Charting
		attr_accessor :title, :subtitle, :drilldown, :start, :end, :style, :x, :y, :maximum, :minimum, :sla, :series, :categories, :color

		def initialize(user_supplied_hash={})
			standard_hash = { title:"", subtitle:"", drilldown:"", start:"", end:"", style:"",
				x:"", y:"", maximum:"", minimum:"", sla:0, series:[], categories:[] }

			user_supplied_hash = standard_hash.merge(user_supplied_hash)

			user_supplied_hash.each do |key,value|
				self.instance_variable_set("@#{key}", value)
				self.class.send(:define_method, key, proc{self.instance_variable_get("@#{key}")})
				self.class.send(:define_method, "#{key}=", proc{|x| self.instance_variable_set("@#{key}", x)})
			end
		end

		def self.get_x_axis_choices
			return [ "year", "month", "week", "day", "hour", "minute", "second" ]
		end

		def self.get_style_choices
			return [ "line", "spline", "area", "areaspline", "column", "bar", "pie", "scatter" ]
		end

		#Make this call more dynamic, iterate over all known attributes
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
			hc_hash.store(:color,@color)

			return hc_hash
		end

		def self.create_array_of_dates(start_time,end_time,x_axis)
			categories = IceCube::Schedule.new #Add on from IRB window

			return categories
		end

		#Depending on what the x axis is, this should conform to it
		def fix_categories
			x = []
			@categories.each do |category|
				x << category.strftime("%m-%d")
			end

			@categories = x
		end
	end
end
