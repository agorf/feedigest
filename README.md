# feedigest [![Gem Version](https://badge.fury.io/rb/feedigest.svg)](http://badge.fury.io/rb/feedigest)

feedigest is a [headless][] [RSS][]/[Atom][] feed aggregator that sends feed
updates as a single digest email.

It was written as a simpler alternative to [feed2email][].

[headless]: http://en.wikipedia.org/wiki/Headless_software
[RSS]: http://www.rssboard.org/rss-specification
[Atom]: https://tools.ietf.org/html/rfc4287
[feed2email]: https://github.com/agorf/feed2email

## Installation

As a [gem][] from [RubyGems][]:

~~~ sh
gem install feedigest
~~~

If the above command fails, make sure the following packages are installed in
your system. For Debian/Ubuntu, issue as root:

~~~ sh
apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev
~~~

[gem]: http://rubygems.org/gems/feedigest
[RubyGems]: http://rubygems.org/

## Configuration

feedigest is configured through a simple text file that contains pairs of shell
environment variables. It is suggested to place this under `~/.feedigest`:

~~~ sh
mkdir -p ~/.feedigest
touch ~/.feedigest/env
chmod 600 ~/.feedigest/env
$EDITOR ~/.feedigest/env
~~~

**Note:** The last command will fail if the `EDITOR` environmental variable is
not set.

The following environment variables and their default values are supported:

* `FEEDIGEST_ENTRY_WINDOW` (default: `86400`) the maximum age (in seconds) of
  entries to include in the digest
* `FEEDIGEST_EMAIL_SENDER` (default: `feedigest@hostname`) the "From" address in
  the email
* `FEEDIGEST_EMAIL_RECIPIENT` (required) the email address to send the email to
* `FEEDIGEST_DELIVERY_METHOD` (default: `sendmail`) can also be `smtp`

If `FEEDIGEST_DELIVERY_METHOD` is `smtp`, the following options are also used:

* `FEEDIGEST_SMTP_HOST`
* `FEEDIGEST_SMTP_PORT` (default: `587`)
* `FEEDIGEST_SMTP_USERNAME`
* `FEEDIGEST_SMTP_PASSWORD`
* `FEEDIGEST_SMTP_AUTH` (default: `plain`)
* `FEEDIGEST_SMTP_STARTTLS` (default: `true`)

[Mailgun]: http://www.mailgun.com/

### Running

~~~
$ export $(cat ~/.feedigest/env | xargs) && feedigest-send < ~/.feedigest/feeds.txt
~~~

## Contributing

Using feedigest and want to help? [Let me know](https://agorf.gr/) how you use
it and if you have any ideas on how to improve it.

## License

Licensed under the MIT license (see [LICENSE.txt][license]).

[license]: https://github.com/agorf/feedigest/blob/master/LICENSE.txt

## Author

Angelos Orfanakos, <https://agorf.gr/>
