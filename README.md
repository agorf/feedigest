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

feedigest is configured through a [YAML][] configuration file located under
`~/.feedigest/config.yaml`:

[YAML]: https://en.wikipedia.org/wiki/YAML

The following configuration options are supported:

* `entry_window` (default: `86400`) the maximum age, in seconds, of
  entries to include in the digest
* `email_sender` (default: `feedigest@hostname`) the "from" address in
  the email
* `email_recipient` the email address to send the email to

feedigest uses SMTP to send emails. You can get a free plan from [Mailgun][].
The relevant configuration options are:

[Mailgun]: http://www.mailgun.com/

* `smtp_address` (required) SMTP service address to connect to
* `smtp_port` (default: `587`) SMTP service port to connect to
* `smtp_username` (required) username of your email account
* `smtp_password` (required) password of your email account
* `smtp_auth` (default: `plain`) controls authentication method (can also be
  `login` or `cram_md5`)
* `smtp_starttls` (default: `true`) controls use of STARTTLS

Finally, you need to provide to the standard input (stdin) of feedigest, a
line-separated list of feed URLs:

~~~ sh
$ cat > ~/.feedigest/feeds.txt
https://github.com/agorf/feed2email/commits.atom
https://github.com/agorf.atom
...
^D
~~~

**Note:** In the example above, `^D` stands for pressing `Ctrl-D`.

## Use

~~~ sh
feedigest send < ~/.feedigest/feeds.txt
~~~

You can run this with [cron][] e.g. once per day at 10 am:

[cron]: https://en.wikipedia.org/wiki/Cron

~~~
0 10 * * * feedigest send < ~/.feedigest/feeds.txt
~~~

Alternatively, you can have feedigest simply print the generated email so that
you can send it yourself e.g. by piping it to sendmail. To do that, you simply
replace `feedigest send` with `feedigest print`:

~~~ sh
feedigest print < ~/.feedigest/feeds.txt
~~~

## Contributing

Using feedigest and want to help? Please [let me know][contact] how you use it
and if you have any ideas on how to improve it.

[contact]: https://agorf.gr/contact/

## License

Licensed under the MIT license (see [LICENSE.txt][license]).

[license]: https://github.com/agorf/feedigest/blob/master/LICENSE.txt

## Author

Angelos Orfanakos, <https://agorf.gr/>
