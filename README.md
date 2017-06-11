# Acmaker

Acmaker is a tool to manage [AWS Certificate Manager](https://aws.amazon.com/jp/certificate-manager/)
It defines the state of Certificate Manager using DSL, and updates Certificate Manager according to DSL.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acmaker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acmaker

## Usage

```sh
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'
export AWS_REGION='...'
acmaker -e -o Certificatefile # export Certificate Manager
vi Certificatefile
acmaker -a --dry-run
acmaker -a            # Apply `Certificatefile` to Certificate Manager
```

## Help

```
Usage: acmaker [options]
    -k, --access-key ACCESS_KEY
    -s, --secret-key SECRET_KEY
    -r, --region REGION
        --profile PROFILE
        --credentials-path PATH
    -a, --apply
    -f, --file FILE
        --dry-run
    -e, --export
    -o, --output FILE
        --split
        --target REGEXP
        --no-color
        --debug
        --request-concurrency N
```

## Certificatefile example

```ruby
require 'other/certificatefile'

domain "yutadayo.jp" do
  {:certificate_arn=>
    "arn:aws:acm:ap-northeast-1:XXXXXXXXXXXX:certificate/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
   :created_at=>"2017-01-01 12:00:00 +0900",
   :domain_name=>"yutadayo.jp",
   :domain_validation_options=>
    [{:domain_name=>"yutadayo.jp",
      :validation_domain=>"yutadayo.jp",
      :validation_emails=>
       ["administrator@yutadayo.jp",
        "hostmaster@yutadayo.jp",
        "webmaster@yutadayo.jp",
        "info@fablic.co.jp",
        "postmaster@yutadayo.jp",
        "admin@yutadayo.jp"],
      :validation_status=>"SUCCESS"},
     {:domain_name=>"*.yutadayo.jp",
      :validation_domain=>"yutadayo.jp",
      :validation_emails=>
       ["administrator@yutadayo.jp",
        "hostmaster@yutadayo.jp",
        "webmaster@yutadayo.jp",
        "info@fablic.co.jp",
        "postmaster@yutadayo.jp",
        "admin@yutadayo.jp"],
      :validation_status=>"SUCCESS"}],
   :failure_reason=>nil,
   :imported_at=>nil,
   :in_use_by=>
    ["arn:aws:elasticloadbalancing:ap-northeast-1:XXXXXXXXXXXX:loadbalancer/XXXXXXXXXX",
     "arn:aws:elasticloadbalancing:ap-northeast-1:XXXXXXXXXXXX:loadbalancer/app/XXXXXXXXXX/XXXXXXXXXX"],
   :issued_at=>"2017-01-01 13:00:00 +0900",
   :issuer=>"Amazon",
   :key_algorithm=>"RSA-2048",
   :not_after=>"2018-02-01 21:00:00 +0900",
   :not_before=>"2017-01-01 09:00:00 +0900",
   :renewal_summary=>{},
   :revocation_reason=>nil,
   :revoked_at=>nil,
   :serial=>"XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX",
   :signature_algorithm=>"SHA256WITHRSA",
   :status=>"ISSUED",
   :subject=>"CN=yutadayo.jp",
   :subject_alternative_names=>["yutadayo.jp", "*.yutadayo.jp"],
   :type=>"AMAZON_ISSUED"}
end
```

## Create Certificate

```
$ cat Certificatefile

domain "yutadayo.jp" do
  {
    :domain_name => "yutadayo.jp",
    :subject_alternative_names => ["*.yutadayo.jp"],
    :domain_validation_options => [
      {
        :domain_name => "yutadayo.jp",
        :validation_domain => "yutadayo.jp",
      },
      {
        :domain_name => "*.yutadayo.jp",
        :validation_domain => "yutadayo.jp",
      },
    ],
  }
end

$ acmaker -a
```

## Delete Certificate

```
$ cat Certificatefile

domain "yutadayo.jp" do
end

$ acmaker -a
```

```
$ cat Certificatefile

domain "yutadayo.jp" do
  {}
end

$ acmaker -a
```

```
$ cat Certificatefile

# comment out
#domain "yutadayo.jp" do
#  ...
#end

$ acmaker -a
```

## Similar tools

- [Codenize.tools](https://codenize.tools/)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yutadayo/acmaker.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
