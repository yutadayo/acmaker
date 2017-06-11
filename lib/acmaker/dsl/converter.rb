module Acmaker
  module DSL
    class Converter
      include Acmaker::Utils::Helper

      class << self
        def convert(exported, options = {})
          new(exported, options).convert
        end
      end

      def initialize(exported, options)
        @exported = exported
        @options = options
      end

      def convert
        certificates = []

        @exported.each do |domain_name, certificate|
          next if !certificate || !matched?(domain_name)
          certificates << output_certificate(domain_name, certificate)
        end

        certificates.join("\n")
      end

      private

      def output_certificate(domain_name, certificate)
        certificate = certificate.pretty_inspect.gsub(/^/, '  ').strip

        <<-EOS
domain #{domain_name.inspect} do
  #{certificate}
end
        EOS
      end
    end
  end
end
