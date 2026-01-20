module OctopressLiquidFilters
  # Format date with ordinal (e.g., "Nov 3rd, 2014")
  def date_to_ordinal(date)
    date = Time.parse(date.to_s) if date.is_a?(String)
    day = date.strftime('%e').to_i
    ordinal = ordinal_suffix(day)
    "#{date.strftime('%b')} #{day}#{ordinal}, #{date.strftime('%Y')}"
  end

  # Returns ordinal suffix for a number (1st, 2nd, 3rd, 4th, etc.)
  def ordinal_suffix(number)
    if (11..13).include?(number % 100)
      'th'
    else
      case number % 10
      when 1 then 'st'
      when 2 then 'nd'
      when 3 then 'rd'
      else 'th'
      end
    end
  end

  # Extracts raw content DIV from template
  def raw_content(input)
    /<div class="entry-content">(?<content>[\s\S]*?)<\/div>\s*<(footer|\/article)>/ =~ input
    return (content.nil?) ? input : content
  end

  # Condenses multiple spaces and tabs into a single space
  def condense_spaces(input)
    input.to_s.gsub(/\s{2,}/, ' ')
  end

  # Removes trailing forward slash from a string
  def strip_slash(input)
    if input =~ /(.+)\/$|^\/$/
      input = $1
    end
    input
  end

  # Used on the blog index to split posts on the <!--more--> marker
  def excerpt(input)
    if input.index(/<!--\s*more\s*-->/i)
      input.split(/<!--\s*more\s*-->/i)[0]
    else
      input
    end
  end

  # Checks for excerpts (helpful for template conditionals)
  def has_excerpt(input)
    input =~ /<!--\s*more\s*-->/i ? true : false
  end

  # Summary is used on the Archive pages to return the first block of content from a post.
  def summary(input)
    if input.index(/\n\n/)
      input.split(/\n\n/)[0]
    else
      input
    end
  end

  # Escapes CDATA sections in post content
  def cdata_escape(input)
    input.gsub(/<!\[CDATA\[/, '&lt;![CDATA[').gsub(/\]\]>/, ']]&gt;')
  end

  # Replaces relative urls with full urls
  def expand_urls(input, url='')
    url ||= '/'
    input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/[^\/>]{1}[^\"'>]*)/ do
      $1+url+$3
    end
  end

  # Returns a url without the protocol (http://)
  def shorthand_url(input)
    input.gsub /(https?:\/\/)(\S+)/ do
      $2
    end
  end

  # Returns a title cased string
  def titlecase(input)
    input.to_s.gsub(/\w+/) do |word|
      word.capitalize
    end
  end
end

Liquid::Template.register_filter OctopressLiquidFilters
