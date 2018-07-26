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

```sh
gem install feedigest
```

If the above command fails, make sure the following system packages are
installed. For Debian/Ubuntu, issue as root:

```sh
apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev
```

[gem]: http://rubygems.org/gems/feedigest
[RubyGems]: http://rubygems.org/

## Configuration

feedigest is configured through a [YAML][] configuration file (located under
`~/.feedigest/config.yaml` by default):

[YAML]: https://en.wikipedia.org/wiki/YAML

The following configuration options are supported:

* `entry_window` (default: `24`) the maximum age, in hours, of entries to
  include in the digest
* `email_sender` (default: `feedigest@hostname`) the "from" address in
  the email
* `email_recipient` (required) the email address to send the email to

feedigest uses SMTP to send emails ([Mailgun][] has a free plan). The relevant
configuration options are:

[Mailgun]: http://www.mailgun.com/

* `smtp_address` (required) SMTP service address to connect to
* `smtp_port` (default: `587`) SMTP service port to connect to
* `smtp_username` (required) username of your email account
* `smtp_password` (required) password of your email account
* `smtp_auth` (default: `plain`) controls authentication method (can also be
  `login` or `cram_md5`)
* `smtp_starttls` (default: `true`) controls use of STARTTLS

Here's a sample config file:

```yaml
email_recipient: me@mydomain.com
email_sender: feedigest@mydomain.com
smtp_address: smtp.mailgun.org
smtp_username: postmaster@mydomain.com
smtp_password: 'mypassword'
```

Finally, you will need a line-separated list of feed URLs:

```sh
$ cat > ~/.feedigest/feeds.txt
https://github.com/agorf/feedigest/commits.atom
https://github.com/agorf.atom
...
^D
```

**Note:** `^D` stands for pressing `Ctrl-D`.

## Use

```sh
feedigest --feeds ~/.feedigest/feeds.txt
```

You can run this with [cron][] e.g. once per day at 10 am:

[cron]: https://en.wikipedia.org/wiki/Cron

```
0 10 * * * feedigest --feeds ~/.feedigest/feeds.txt
```

Alternatively, you can have feedigest simply print the generated email so that
you can send it yourself e.g. by piping it to sendmail:

```sh
feedigest --dry-run --feeds ~/.feedigest/feeds.txt | sendmail
```

It is also possible to have each feed filtered with a custom command. For
example, the following script fixes a feed's entry publication dates that use
Greek month names and don't follow the required RFC822 format:

```ruby
require 'nokogiri'

feed_data = $stdin.read
doc = Nokogiri.XML(feed_data)

case feed_data
when /advendure\.com/
  doc.css('pubDate').each do |pubdate|
    %w[
      Ιαν Φεβ Μαρ Απρ Μαι Ιουν Ιουλ Αυγ Σεπ Οκτ Νοβ Δεκ
      Δε Τρ Τε Πε Πα Σα Κυ
    ].zip(
      %w[
        Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
        Mo Tu We Th Fr Sa Su
      ]
    ).each do |greek, latin|
      pubdate.content = pubdate.content.sub(greek, latin)
    end
  end

  print doc
else
  print feed_data # Do nothing
end
```

The script reads the feed XML from its standard input (stdin) and writes the
modified XML to its standard output (stdout). To use it as a filter, you simply
pass as a command-line argument the necessary command to run it:

```sh
feedigest --feeds ~/.feedigest/feeds.txt --filter 'ruby /path/to/filter.rb'
```

It is also possible to specify the path to the YAML configuration file with
`--config`:

```sh
feedigest --feeds ~/.feedigest/feeds.txt --config ~/.config/feedigest.yaml
```

You can issue `feedigest -h` to get some help text on the supported options.

## License

[MIT][]

[MIT]: https://github.com/agorf/feedigest/blob/master/LICENSE.txt

## Author

[Angelos Orfanakos](https://agorf.gr/contact/)
