require File.dirname(__FILE__) + '/spec_helper'

describe Highcharts do
  it 'return the highcharts gem vesion' do
    Highcharts::VERSION.should == Highcharts::VERSION
  end
end

describe Highcharts::Charting, "Default Object Values" do
  it "returns default object and it's variables" do
		class Test
			include Highcharts::Charting
		end

    chart_test = Test.new

    chart_test.title.should eq ""
    chart_test.subtitle.should eq ""
    chart_test.drilldown.should eq ""
    chart_test.start.should eq ""
    chart_test.end.should eq ""
    chart_test.style.should eq ""
    chart_test.x.should eq ""
    chart_test.y.should eq ""
    chart_test.maximum.should eq ""
    chart_test.minimum.should eq ""
    chart_test.sla.should eq 0
    chart_test.series.should eq []
    chart_test.categories.should eq []
    chart_test.color.should eq ""
  end
end

describe Highcharts::Charting, "Self Methods" do
  it "returns choices for the x and style" do
		Highcharts::Charting.x_choices.should eq [ "year", "month", "week", "day", "hour", "minute", "second" ]
		Highcharts::Charting.style_choices.should eq [ "line", "spline", "area", "areaspline", "column", "bar", "pie", "scatter" ]
  end
end

describe Highcharts::Charting, "Array of Dates" do
  it "returns object with categories defined" do
		class Test
			include Highcharts::Charting
		end

    chart_test = Test.new
    chart_test.start = "2012-01-01 00:00:00"
    chart_test.end = "2012-02-01 00:00:00"
    chart_test.x = "month"
    chart_test.create_array_of_dates
    chart_test.humanize_categories

    chart_test.categories.should eq ["01-2012", "02-2012"]

    chart_test.x = "week"
    chart_test.create_array_of_dates
    chart_test.humanize_categories

    chart_test.categories.should eq ["01-01", "01-08", "01-15", "01-22", "01-29"]

    chart_test.start = "2012-01-01 00:00:00"
    chart_test.end = "2012-01-02 00:00:00"
    chart_test.x = "day"
    chart_test.create_array_of_dates
    chart_test.humanize_categories

    chart_test.categories.should eq ["01-01", "01-02"]

    chart_test.start = "2012-01-01 00:00:00"
    chart_test.end = "2012-01-01 02:00:00"
    chart_test.x = "hour"
    chart_test.create_array_of_dates
    chart_test.humanize_categories

    chart_test.categories.should eq ["12AM", "01AM", "02AM"]

    chart_test.start = "2012-01-01 00:00:00"
    chart_test.end = "2012-01-01 00:02:00"
    chart_test.x = "minute"
    chart_test.create_array_of_dates
    chart_test.humanize_categories

    chart_test.categories.should eq ["12:00AM", "12:01AM", "12:02AM"]

    chart_test.start = "2012-01-01 00:00:00"
    chart_test.end = "2012-01-01 00:00:02"
    chart_test.x = "second"
    chart_test.create_array_of_dates
    chart_test.humanize_categories

    chart_test.categories.should eq ["12:00:00AM", "12:00:01AM", "12:00:02AM"]
  end
end

describe Highcharts::Charting, "Create Highcharts Hash" do
  it "returns object in hash format with variables" do
		class Test
			include Highcharts::Charting
		end

    chart_test = Test.new

    chart_test.start = "2012-01-01"
    chart_test.end = "2012-02-01"
    chart_test.x = "month"
    chart_test.create_array_of_dates
    chart_test.humanize_categories

    chart_test.to_hc.should eq({"title"=>"", "subtitle"=>"", "drilldown"=>"", "start"=>"2012-01-01", "end"=>"2012-02-01", "style"=>"", "x"=>"month", "y"=>"", "maximum"=>"", "minimum"=>"", "sla"=>0, "series"=>[], "categories"=>["01-2012", "02-2012"], "color"=>"" })
  end
end