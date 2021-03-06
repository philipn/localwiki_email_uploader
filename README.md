Localwiki Email Uploader
========================

Localwiki content uploader from email using [Localwiki API] and custom API(see About Custom API).
Email sender's address required in relation to User and API Key.
Email subject is used Localwiki's page name.
If Localwiki's page doesn't exist, create page and map, and upload jpeg file.
If Localwiki's page exist, upload jpeg file, and modify page(don't modify map).

[Localwiki API]: http://localwiki.readthedocs.org/en/latest/api.html "API Documentation"

## About Custom API

Custom API is available at [Our branch].
This API allow access to get API key.
Please check [commit for api].

[Our branch]: https://github.com/Georepublic/localwiki "Georepublic's master_ja branch"
[commit for api]: https://github.com/Georepublic/localwiki/commit/29cf7ad5e0d846f617e12c46a0ac5fe35652b459 "add custom API for customer"

## Setup

This is ruby script, install ruby 1.9.3 and follow:

    $ gem install bundler
    $ bundle install --path vendor/bundle
    $ cp api_settings.rb.example api_settings.rb
    $ vim api_settings.rb
    (edit your setting)

And setup your .forward file. For example, if you use rbenv:

    $ cp sample/rbenv-entrypoint.sh app.sh
    $ chmod +x app.sh
    $ vim ~/.forward
    | <your path>/localwiki_email_uploader/app.sh

Please check rbenv-entrypoint.sh, this file has many hints.

If you setup in Ubuntu, see also: [Setup Email Uploader in Ubuntu]

[Setup Email Uploader in Ubuntu]: https://github.com/Georepublic/localwiki_email_uploader/blob/master/Setup_Ubuntu.md "Setup Email Uploader in Ubuntu"

## app_settings.rb

ex: Localwiki's instance run "http://example.com" and create user "mail" and generate api_key "xxx" and add tag "frommail".

    def get_setting
      return {
        :base_url => 'http://example.com',
        :user_name => 'mailuser',
        :api_key => 'xxx',
        :tag_slug => 'frommail'
      }
    end

## Test

Save email and follow:

    $ cat test.eml | bundle exec ruby parser.rb

## Note

This script designed for our customer.
Please hack as you please.

## License

Released under the MIT license.

