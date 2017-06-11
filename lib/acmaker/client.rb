module Acmaker
  class Client
    include Acmaker::Logger::Helper
    include Acmaker::Utils::Helper

    def initialize(options = {})
      @options = options
      @client = @options[:client] || Aws::ACM::Client.new
      @driver = Acmaker::Driver.new(@client, @options)
      @exporter = Acmaker::Exporter.new(@client, @options)
    end

    def export
      @exporter.export
    end

    def apply(file)
      walk(file)
    end

    private

    def walk(file)
      expected = load_file(file)
      actual = @exporter.export
      updated = walk_domains(expected, actual)

      @options[:dry_run] ? false : updated
    end

    def walk_domains(expected, actual)
      updated = false

      expected.each do |domain_name, expected_certificate|
        next unless matched?(domain_name)

        actual_certificate = actual.delete(domain_name)

        if actual_certificate
          updated = walk_certificate(domain_name, expected_certificate, actual_certificate) || updated
        elsif expected_certificate
          @driver.create_certificate(domain_name, expected_certificate)
          updated = true
        end
      end

      actual.each do |domain_name, actual_certificate|
        @driver.delete_certificate(domain_name, actual_certificate[:certificate_arn])
        updated = true
      end

      updated
    end

    def walk_certificate(domain_name, expected_certificate, actual_certificate)
      if expected_certificate.nil? || expected_certificate.empty?
        @driver.delete_certificate(domain_name, actual_certificate[:certificate_arn])
        return true
      end

      if expected_certificate != actual_certificate
        log(:info, diff(actual_certificate, expected_certificate, color: @options[:color]), color: false)
        log(:warn, "Domain `#{domain_name}`: certificate can not be changed", color: :yellow)
      end

      false
    end

    def load_file(file)
      if file.is_a?(String)
        open(file) do |f|
          Acmaker::DSL.parse(f.read, file)
        end
      elsif file.respond_to?(:read)
        Acmaker::DSL.parse(file.read, file.path)
      else
        raise TypeError, "can't convert #{file} into File"
      end
    end
  end
end
