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

		def to_hc
			hc_hash = {}

			self.instance_variables.each do |variable|
				v = variable.to_s[1,variable.length]
				hc_hash.store(v,self.send(v))
			end

			return hc_hash
		end

		def create_array_of_dates
			all_dates = IceCube::Schedule.new(Time.parse(@start), :end_time => Time.parse(@end))

			case @x
			when "month"
				all_dates.add_recurrence_rule IceCube::Rule.monthly
				rule = "%m-%Y"
			when "week"
				all_dates.add_recurrence_rule IceCube::Rule.weekly
				rule = "%m-%d"
			when "day"
				all_dates.add_recurrence_rule IceCube::Rule.daily
				rule = "%m-%d"
			when "hour"
				all_dates.add_recurrence_rule IceCube::Rule.hourly
				rule = "%I%p"
			when "minute"
				all_dates.add_recurrence_rule IceCube::Rule.minutely
				rule = "%I:%M%p"
			when "second"
				all_dates.add_recurrence_rule IceCube::Rule.secondly
				rule = "%I:%M:%S%p"
			end

			all_dates.all_occurrences.each do |date|
				@categories << date.strftime(rule)
			end

		end
	end
end
