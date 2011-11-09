require 'test/test_helper'

class ParserTest < Test::Unit::TestCase

  def test_valid_class
    assert VectorVictor::Parser.is_a? Class
  end

  def test_unpack_line
    line = VectorVictor::Parser.unpack_line open("test/data/1.log").read

    assert line.is_a? Array
    assert_equal 8, line.size
  end

  def test_parse_line
    line = VectorVictor::Parser.unpack_line open("test/data/1.log").read
    data = VectorVictor::Parser.parse_line line

    assert data.is_a? Hash
    assert_equal 1310443200, data[:timestamp]
    assert_equal 1056924685, data[:traffic]
    assert_equal      23590, data[:interest]
    assert_equal 3867635626, data[:checksum]
  end

end