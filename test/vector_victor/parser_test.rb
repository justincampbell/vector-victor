require 'test/test_helper'

class ParserTest < Test::Unit::TestCase

  def test_valid_class
    assert VectorVictor::Parser.is_a? Class
  end

end