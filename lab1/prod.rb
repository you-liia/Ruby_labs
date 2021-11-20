require 'json'

class Prod
  attr_accessor :date, :comments, :title, :text
  def initialize(date, comments, title, text)
    @date            = date
    @comments        = comments
    @title           = title
    @text            = text
  end

  def as_json(*options)
    {
      :date         => @date,
      :comments     => @comments,
      :title        => @title,
      :text         => @text
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

  def values
      [@date, @comments, @title, @text]
  end
end
