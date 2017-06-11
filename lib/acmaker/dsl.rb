module Acmaker
  module DSL
    class << self
      def convert(exported, options = {})
        Acmaker::DSL::Converter.convert(exported, options)
      end

      def parse(dsl, path, options = {})
        Acmaker::DSL::Context.eval(dsl, path, options).result
      end
    end
  end
end
