## Information

Highcharts Gem to allow for easily extending other classes in your application to create highchart's json

## Installation

  gem install highcharts

## Using

do a include in your class, example below:

    class Object
      include Highcharts::Charting
    end

## Examples

In a model

	class MyClass
		include Highcharts::Charting

		def parse(pas_type)
			@categories = Highcharts::Charting.create_array_of_dates(@start,@end,@x)
			self.calculate_data(data)
			self.fix_categories
		end

		#This is a sample method for getting data via ActiveRecord
		def calculate_data(data)
			@series = []
			@series << { name:"Series Name", type:"areaspline", data:[] }

			@min_max_array = []

			@categories.each do |category|
				if @x == "month"
					category_end = category + 1.month
				else
					category_end = Time.parse((category + (Highcharts::Charting.transform_x_axis(@x) - 1).days).strftime("%Y-%m-%d")+" 23:59:59")
				end

					data_count = MyClass.some_scope_to_send_start_and_end_dates_to(category,category_end).count

				if data_count != nil && data_count != []
					@series[0][:data] << data_count
					@min_max_array << data_count
				else
					@series[0][:data] << nil
				end
			end

			@minimum = @min_max_array.min.to_f
			@maximum = @min_max_array.max.to_f
		end
	end

In a route

	get '/custom' do
		if params[:x] == nil
			flash[:notice] = "Parameter (x) needs to equal: <br> month, week, or day"
			redirect back
		elsif params[:start] == nil || params[:end] == nil
			flash[:notice] = "Parameter (start/end) needs to equal a date in this format: <br> #{Time.now.strftime("%Y-%m-%d")}"
			redirect back
		elsif params[:x] =~ /month/i && params[:start] != nil && params[:end] != nil
			range = Highcharts::Charting.difference_between_two_dates(params[:start],params[:end],1)
			if range < 27
				flash[:notice] = "Parameters (start & end) need to have a range greater than 27 days <br> Range: #{range} days"
				redirect back
			end
		end

		@x_axis_choices = Highcharts::Charting.get_x_axis_choices
		@style_choices = Highcharts::Charting.get_style_choices

		@my_class_object = MyClass.new

		@my_class_object.start = params[:start].strip
		@my_class_object.end = params[:end].strip

		@my_class_object.x = params[:x].strip.downcase unless params[:x].nil?
		@my_class_object.y = params[:y].strip.downcase unless params[:y].nil?

		@my_class_object.style = params[:style].strip.downcase unless params[:style].nil?

		@my_class_object.title = params[:title].strip unless params[:title].nil?
		@my_class_object.subtitle = params[:subtitle].strip unless params[:subtitle].nil?

		@json = (call env.merge("PATH_INFO" => "/custom.json"))[2][0]

		@title = "My Classes Route"
		erb :custom
	end

	get '/custom.:format' do
		@my_class_object = MyClass.new

		@my_class_object.start = params[:start].strip
		@my_class_object.end = params[:end].strip

		@my_class_object.x = params[:x].strip.downcase unless params[:x].nil?
		@my_class_object.y = params[:y].strip.downcase unless params[:y].nil?

		@my_class_object.style = params[:style].strip.downcase unless params[:style].nil?

		@my_class_object.title = params[:title].strip unless params[:title].nil?
		@my_class_object.subtitle = params[:subtitle].strip unless params[:subtitle].nil?

		@deployed.drilldown = "click into link"

		@my_class_object.parse

		case params[:format]
		when /xml/i
			content_type :xml
			@my_class_object.to_hc.to_xml
		when /json/i
			content_type :json
			@my_class_object.to_hc.to_json
		when /yaml/i
			content_type :yaml
			@my_class_object.to_hc.to_yaml
		else
			"#{@my_class_object.inspect}"
		end
	end

In an ERB Template

	<form>
		<input type="text" name="start" value="<%= @my_class_object.start %>"></span>
		<input type="text" name="end" value="<%= @my_class_object.end %>"></span>

			<select name="x" class="graph">
				<% @x_axis_choices.each do |x| %>
					<% if @my_class_object.x == x %>
						<option selected="selected"><%= x %></option>
					<% else %>
						<option><%= x %></option>
					<% end %>
				<% end %>
			</select>

			<select name="style" class="graph">
				<% @style_choices.each do |style_choice| %>
					<% if @my_class_object.style != nil %>
						<% if @my_class_object.style == style_choice %>
							<option selected="selected"><%= style_choice %></option>
						<% else %>
							<option><%= style_choice %></option>
						<% end %>
					<% else %>
						<option><%= style_choice %></option>
					<% end %>
				<% end %>
			</select>
		<input name="submit">
	</form>
	<div id="results" style="display:none"></div>

	<br>

	<div id="custom"></div>
	<script>
	$(document).ready(function() {
			function showValues() {
				var str = $("form").serialize();
				$("#results").text(str);
			}
			$("select").change(showValues);

			$('#submit_button').click(function() {
				showValues();
				window.location = "/custom?" + $("#results").text();
				return false;
			});
	});
	</script>
	<script>
	$(document).ready(function() {
		hc_chart("custom",<%= @json %>)
	});
	</script>

In Javascript function (hc_chart called from erb template)

	function hc_chart(div_id,chart_data) {
			chart = new Highcharts.Chart({
				chart: {
					renderTo: div_id,
					defaultSeriesType: 'areaspline',
					zoomType: "xy",
					backgroundColor: "#FFFFFF",
					borderWidth: 0,
					plotBackgroundColor: 'rgba(255, 255, 255, 255)',
					plotShadow: false,
					plotBorderWidth: 1,
					spacingTop: 10,
					spacingRight: 10,
					spacingBottom: 10,
					spacingLeft: 10,
					connectNulls: true
				},
				colors: ['#62A992', '#ED561B'],
				title: {
					text: chart_data.title,
					style: {
						color: '#000',
						font: '14px Trebuchet MS, Verdana, sans-serif'
					}
				},
				subtitle: {
					text: chart_data.subtitle,
					style: {
						color: '#666666',
						font: '10px Trebuchet MS, Verdana, sans-serif'
					}
				},
				xAxis: {
					categories: chart_data.categories,
					labels: {
						rotation: 270,
						style: {
							color: '#666666',
							font: '10px Trebuchet MS, Verdana, sans-serif',
							fontWeight: 'normal'
						},
						title: {
							style: {
								color: '#666666',
								font: '10px Trebuchet MS, Verdana, sans-serif',
								fontWeight: 'normal'
							}
						}
					}
				},
				yAxis: {
					startOnTick: false,
					endOnTick: false,
					maxPadding: 0.2,
					minPadding: 0.2,
					title: {
						text: null,
						style: {
							color: '#666666',
							font: '10px Trebuchet MS, Verdana, sans-serif',
							fontWeight: 'normal'
						}
					},
					opposite: false,
					min: chart_data.minimum,
					max: chart_data.maximum,
					plotLines: [{
							color: 'red',
							width: 2,
							zIndex: 5,
							label: { text: "SLA - "+chart_data.sla },
							value: chart_data.sla,
							dashStyle: 'shortdot'
					}],
					labels: {
						formatter: function() { return this.value + chart_data.y; },
						style: {
							color: '#99b'
						}
					}
				},
				plotOptions: {
					series: {
						cursor: 'pointer',
						events: {
							click: function(event) {
								window.location = chart_data.drilldown;
							}
						}
					}
				},
				tooltip: {
					formatter: function() { return '<b>'+ this.series.name +'</b><br/>'+this.x +': '+ this.y + chart_data.y;
					}
				},
				series: chart_data.series,
				exporting: { enabled: true },
				legend: { enabled: false },
				credits: { enabled: true }
			});
		}

## Contributing

- Fork the project and do your work in a topic branch.
- Rebase your branch to make sure everything is up to date.
- Commit your changes and send a pull request.

## Copyright

(The MIT License)

Copyright © 2011 nictrix (Nick Willever)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
