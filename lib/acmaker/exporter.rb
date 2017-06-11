module Acmaker
  class Exporter
    include Acmaker::Utils::Helper

    def initialize(client, options = {})
      @client = client
      @options = options
    end

    def export
      export_certificates
    end

    private

    def export_certificates
      result = {}
      certificates = list_certificates
      concurrency = @options[:request_concurrency]

      Parallel.each(certificates, in_threads: concurrency) do |certificate|
        domain_name = certificate.domain_name
        next unless matched?(domain_name)
        result[domain_name] = export_domain_certificate(certificate)
      end

      result
    end

    def export_domain_certificate(certificate)
      arn = certificate.certificate_arn
      resp = @client.describe_certificate(certificate_arn: arn)

      {
        certificate_arn: resp.certificate.certificate_arn,
        created_at: resp.certificate.created_at&.to_s,
        domain_name: resp.certificate.domain_name,
        domain_validation_options: export_domain_validation_options(resp.certificate.domain_validation_options),
        failure_reason: resp.certificate.failure_reason,
        imported_at: resp.certificate.imported_at&.to_s,
        in_use_by: resp.certificate.in_use_by,
        issued_at: resp.certificate.issued_at&.to_s,
        issuer: resp.certificate.issuer,
        key_algorithm: resp.certificate.key_algorithm,
        not_after: resp.certificate.not_after&.to_s,
        not_before: resp.certificate.not_before&.to_s,
        renewal_summary: export_renewal_summary(resp.certificate.renewal_summary),
        revocation_reason: resp.certificate.revocation_reason,
        revoked_at: resp.certificate.revoked_at,
        serial: resp.certificate.serial,
        signature_algorithm: resp.certificate.signature_algorithm,
        status: resp.certificate.status,
        subject: resp.certificate.subject,
        subject_alternative_names: resp.certificate.subject_alternative_names,
        type: resp.certificate.type,
      }
    rescue Aws::ACM::Errors::ResourceNotFoundException
      nil
    end

    def export_domain_validation_options(options)
      options.each_with_object([]) do |option, arr|
        arr << {
          domain_name: option.domain_name,
          validation_domain: option.validation_domain,
          validation_emails: option.validation_emails,
          validation_status: option.validation_status,
        }
      end
    end

    def export_renewal_summary(summary)
      return {} if summary.nil?
      {
        renewal_summary: {
          renewal_status: summary.renewal_status,
          domain_validation_options: export_domain_validation_options(summary.domain_validation_options),
        }
      }
    end

    def list_certificates
      certificates = []
      next_token = nil

      loop do
        resp = @client.list_certificates(next_token: next_token)
        certificates.concat(resp.certificate_summary_list)
        next_token = resp.next_token
        break unless next_token
      end

      certificates
    end
  end
end
