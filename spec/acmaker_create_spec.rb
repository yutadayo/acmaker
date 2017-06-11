require 'spec_helper'

describe Acmaker::Client do
  let(:domain) { AWS_CONFIG['domain_name'] }
  let(:tmpfile) { 'Certificatefile' }
  let(:client) { Acmaker::Client.new(request_concurrency: 0) }
  let(:export) { client.export }

  before(:each) do
    open(tmpfile, 'wb') { |f| f.puts(Acmaker::DSL.convert(export) << dsl) }
  end

  after(:each) do
    FileUtils.rm(tmpfile)
  end

  subject(:result) { client.apply(tmpfile) }

  context 'Create' do
    let(:exported) { client.export[domain] }

    after do
      driver = Acmaker::Driver.new(Aws::ACM::Client.new)
      driver.delete_certificate(domain, exported[:certificate_arn])
    end

    let(:dsl) do
      <<-EOS
domain "#{domain}" do
  {
    :domain_name => "#{domain}",
    :domain_validation_options => [
      {
        :domain_name => "#{domain}",
        :validation_domain => "#{domain}",
      }
    ],
  }
end
      EOS
    end

    it 'should create certificate' do
      expect(result).to be_truthy
      expect(exported[:domain_name]).to eq domain
    end
  end
end
