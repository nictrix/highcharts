require "highcharts/version"

require 'ice_cube'
require 'time'
require 'date'

module Highcharts
	module Charting
		attr_accessor :title, :subtitle, :drilldown, :start, :end, :style, :x, :y, :maximum, :minimum, :sla, :series, :categories, :color

		def initialize(user_supplied_hash={})
			standard_hash = { title:"", subtitle:"", drilldown:"", start:"", end:"", style:"",
				x:"", y:"", maximum:"", minimum:"", sla:0, series:[], categories:[], color:"" }

			user_supplied_hash = standard_hash.merge(user_supplied_hash)

			user_supplied_hash.each do |key,value|
				self.instance_variable_set("@#{key}", value)
				self.class.send(:define_method, key, proc{self.instance_variable_get("@#{key}")})
				self.class.send(:define_method, "#{key}=", proc{|x| self.instance_variable_set("@#{key}", x)})
			end
		end

		def self.x_choices
			return [ "year", "month", "week", "day", "hour", "minute", "second" ]
		end

		def self.style_choices
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

			rule = case @x
							when "month"
								IceCube::Rule.monthly
							when "week"
								IceCube::Rule.weekly
							when "day"
								IceCube::Rule.daily
							when "hour"
								IceCube::Rule.hourly
							when "minute"
								IceCube::Rule.minutely
							when "second"
								IceCube::Rule.secondly
							end

			all_dates.add_recurrence_rule rule
			@categories = all_dates.all_occurrences
		end

		def humanize_categories
			label = case @x
							when "month"
								"%m-%Y"
							when "week", "day"
								"%m-%d"
							when "hour"
								"%I%p"
							when "minute"
								"%I:%M%p"
							when "second"
								"%I:%M:%S%p"
							end

			temp_categories = []
			@categories.each do |date|
				temp_categories << date.strftime(label)
			end

			@categories = temp_categories
		end
	end
end
