require 'date'

class PeopleController
  def initialize(params)
    @params = params
  end

  def normalize
    dollar_format = params[:dollar_format]
    percent_format = params[:percent_format]
    order = params[:order]
    peoples = parse_format(dollar_format, "$")
    peoples += parse_format(percent_format, "%")

    peoples.sort! { |p1, p2| p1[order] <=> p2[order] }

    return peoples.map { |people|
      birthdate = people[:birthdate]
      people[:first_name] + ", " + convert_city(people[:city]) + ", " + "#{birthdate.month}/#{birthdate.day}/#{birthdate.year}"
    }
  end

  def convert_city(city)
    if (city == 'LA')
      return 'Los Angeles'
    elsif (city == 'NYC')
      return 'New York City'
    else
      return city
    end
  end

  def parse_format(data, format_char)
    lines = data.split(/\n/)
    column_line = lines[0]
    columns = column_line.split(format_char).map(&:strip)

    peoples = []

    (1...lines.size).each { |index|
      line = lines[index]
      people_data = line.split(format_char).map(&:strip)

      people = {}

      (0..columns.size - 1).each { |index1|

        if (columns[index1].to_s === "birthdate")
          people[columns[index1].to_sym] = Date.parse(people_data[index1])
        else
          people[columns[index1].to_sym] = people_data[index1]
        end
      }

      peoples.push(people)
    }

    return peoples
  end

  private

  attr_reader :params
end
