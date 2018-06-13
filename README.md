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

If the above command fails, make sure the following system packages are
installed. For Debian/Ubuntu, issue as root:

~~~ sh
apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev
~~~

[gem]: http://rubygems.org/gems/feedigest
[RubyGems]: http://rubygems.org/

## Configuration

feedigest is configured through shell environment variables. Instead of passing
them one by one when you run it, it is better to store them in a separate file
and source it to make them available.

It is suggested to place this file under `~/.feedigest/env`:

~~~ sh
mkdir -p ~/.feedigest
touch ~/.feedigest/env
chmod 600 ~/.feedigest/env
cat >~/.feedigest/env
FEEDIGEST_EMAIL_RECIPIENT=me@mydomain.com
...
^D
~~~

In the example above, `^D` stands for pressing `Ctrl-D`.

The following environment variables are supported:

* `FEEDIGEST_ENTRY_WINDOW` (default: `86400`) the maximum age, in seconds, of
  entries to include in the digest
* `FEEDIGEST_EMAIL_SENDER` (default: `feedigest@hostname`) the "from" address in
  the email
* `FEEDIGEST_EMAIL_RECIPIENT` (required) the email address to send the email to
* `FEEDIGEST_SMTP_ADDRESS`
* `FEEDIGEST_SMTP_PORT` (default: `587`)
* `FEEDIGEST_SMTP_USERNAME`
* `FEEDIGEST_SMTP_PASSWORD`
* `FEEDIGEST_SMTP_AUTH` (default: `plain`)
* `FEEDIGEST_SMTP_STARTTLS` (default: `true`)

You can get a free SMTP service plan from [Mailgun][].

[Mailgun]: http://www.mailgun.com/

You also need to provide, to the standard input (stdin) of feedigest, a list of
feed URLs, with each URL on a separate line:

~~~ sh
cat >~/.feedigest/feeds.txt
https://github.com/agorf/feed2email/commits.atom
https://github.com/agorf.atom
...
^D
~~~

## Use

~~~
export $(cat ~/.feedigest/env | xargs) && feedigest-send < ~/.feedigest/feeds.txt
~~~

It is best to run this with [cron][] e.g. once per day at 10 am.

[cron]: https://en.wikipedia.org/wiki/Cron

## Contributing

Using feedigest and want to help? [Let me know](https://agorf.gr/) how you use
it and if you have any ideas on how to improve it.

## License

Licensed under the MIT license (see [LICENSE.txt][license]).

[license]: https://github.com/agorf/feedigest/blob/master/LICENSE.txt

## Author

Angelos Orfanakos, <https://agorf.gr/>
