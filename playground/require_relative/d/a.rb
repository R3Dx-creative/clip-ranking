require_relative "../x"

module Y
  def g(a)
    a + X.f(a)
  end

  module_function :g
end

puts Y.g(2)
puts File.dirname(__FILE__)
puts __dir__
