require 'test/test_helper'

class ParserTest < Test::Unit::TestCase

  def test_parse
    p = VectorVictor::Parser.new :filename => "test/data/full.log",
                                 :from => "2011-08-01",
                                 :to   => "2011-08-31",
                                 :verbose => true

    expected = { :traffic => 31802933267, :interest => 706933, :ratio => 15 }

    assert_equal expected, p.parse
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

  def test_munge
    m = VectorVictor::Parser.munge [
      { :traffic => 10, :interest => 1 },
      { :traffic => 10, :interest => 1 },
      { :traffic => 10, :interest => 1 }
    ]

    assert_equal 30, m[:traffic]
    assert_equal  3, m[:interest]
    assert_equal 10, m[:ratio]
  end

end