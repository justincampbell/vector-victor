require 'test/test_helper'

class VectorVictorTest < Test::Unit::TestCase

  def test_valid_module
    assert VectorVictor.is_a? Module
  end

end