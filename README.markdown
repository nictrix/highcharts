## Information

Highcharts Gem to allow for easily extending other classes in your application to create highchart's json.  Highcharts the javascript library is located here: http://www.highcharts.com/ (this library is not affiliated with Highcharts in anyway, it helps ruby developers use the Highcharts javascript library)

## Installation

  gem install highcharts

## Using

do an include in your class, example below:

    class Object
      include Highcharts::Charting
    end

you can call a couple other methods:

		Object.new.x_choices (all possible choices this gem can provide)
		Object.new.style_choices (all possible style choices highcharts provides)
		Object.new.humanize_categories (provides human readable category labels for datetimes)

## Roadmap

- Give examples of html forms
- Give examples of javascript functions
- Provide function to include highcharts javascript automatically at any version within html
- Provide function to include javascript functions for this data model automatically

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
