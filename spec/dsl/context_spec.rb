require 'spec_helper'

describe Acmaker::DSL::Context do
  let(:certificate_arn) { AWS_CONFIG['certificate_arn'] }
  let(:domain) { AWS_CONFIG['domain_name'] }
  let(:dsl) do
    <<-EOS
domain "#{domain}" do
end
    EOS
  end

  let(:path) { 'Certificatefile' }

  subject(:certificate) do
    Acmaker::DSL::Context.eval(dsl, path).result
  end

  describe '.eval' do
    context 'no values set' do
      it 'should return nil value' do
        expect(certificate[domain]).to be_nil
      end
    end

    context 'with certificate values set' do
      let(:dsl) do
        <<-EOS
domain "#{domain}" do
  {:certificate_arn=>
   "#{certificate_arn}",
   :domain_name=>"#{domain}",
   :domain_validation_options=>
    [{:domain_name=>"#{domain}",
      :validation_domain=>"#{domain}"}],
   :status=>"ISSUED",
   :type=>"AMAZON_ISSUED"
  }
end
        EOS
      end

      it 'should return DSL value' do
        expect(certificate[domain][:domain_name]).to eq domain
        expect(certificate[domain][:certificate_arn]).to eq certificate_arn
        expect(certificate[domain][:status]).to eq 'ISSUED'
        expect(certificate[domain][:type]).to eq 'AMAZON_ISSUED'
      end
    end
  end
end
