module Acmaker
  module DSL
    class Context
      def self.eval(dsl, path, options = {})
        new(path, options) do
          eval(dsl, binding, path)
        end
      end

      attr_reader :result

      def initialize(path, options = {}, &block)
        @path = path
        @options = options
        @result = {}
        instance_eval(&block)
      end

      private

      def require(file)
        acmfile = file =~ %r{\A/} ? file : File.expand_path(File.join(File.dirname(@path), file))

        if File.exist?(acmfile)
          instance_eval(File.read(acmfile), acmfile)
        elsif File.exist?(acmfile + '.rb')
          instance_eval(File.read(acmfile + '.rb'), acmfile + '.rb')
        else
          Kernel.require(file)
        end
      end

      def domain(name)
        name = name.to_s

        raise "Domain #{name} is already defined" if @result[name]

        @result[name] = yield
      end
    end
  end
end
