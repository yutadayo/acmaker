module Acmaker
  class Driver
    include Acmaker::Logger::Helper
    include Acmaker::Utils::Helper

    def initialize(client, options = {})
      @client = client
      @options = options
    end

    def create_certificate(domain_name, expected_certificate)
      log(:info, "Create Domain `#{domain_name}` Certificate", color: :cyan)

      unless @options[:dry_run]
        resp = @client.request_certificate(expected_certificate)
        arn = resp.certificate_arn.match(/(certificate\/.*)/)[1]
        log(:info, "Certificate arn `#{arn}` has been created", color: :cyan)
      end
    end

    def delete_certificate(domain_name, certificate_arn)
      log(:info, "Delete Domain `#{domain_name}` Certificate", color: :red)

      unless @options[:dry_run]
        @client.delete_certificate(certificate_arn: certificate_arn)
      end
    end
  end
end
