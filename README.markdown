Html2Email: Tilt + Premailer + SMTP
===================================

Making rich HTML emails is a pain. You throw away everything you know about
semantic markup, CSS, and keeping things DRY, and memorize a large heap of
senseless special cases for displaying correctly across at __least__ 30
combinations of email clients, operating systems, browsers, and online email
services; and even then, it's still not going to look right in Outlook 2007.

It's a strange game. The only winning move is not to play.

If you have to play though, you should have a workflow:

* Use your favorite templating engine: use any engine supported by [Tilt][]
* Don't abandon stylesheets: [Premailer][] inlines external styles for you
* Use a layout file for similar projects
* Override information in the layout per email
* Email previews to a list of test addresses right from the command line

Before you start, be sure to understand what you're getting into so that you
don't lose too much hair over your project:

<http://www.campaignmonitor.com/design-guidelines/>

Synopsis
--------

Command line, render email template with layout:

    $ html2email --layout layout.haml client/offer.erb
    # => Creates client/offer.html

Command line, pipe text into `html2email` with layout, get text back on STDOUT:

    $ curl example.com/offer.html | html2email -l layout.haml > offer.html

Command line, send test email after render:

    html2email -l layout.haml --email sung@metablu.com client/offer.erb

In the layout file, layout.haml. Note that linked stylesheets can be CSS,
[Sass][], or [LESS][]:

    - @client_name = 'Example Inc.'
    %html
      %head
        %title&= @page_title || 'A generic title'
        %link{ :rel => 'stylesheet', :href => 'layout.sass',
               :type => 'text/css', :media => 'screen' }
      %body
        = yield

In the email template, offer.erb. The `:prebinding` method takes a block which
makes available to both the layout and the template the variables created
in the block. It should ideally be declared at the top of the template file:

    <% prebinding do %>
      <% @page_title = 'An example offer!' %>
    <% end %>
    <table>
      <tr>
        <td>Hello, <%= @client_name %></td>
      </tr>
    </table>

Ruby interface:

    require 'html2email/html_email'

    html = HtmlEmail.new('client/offer.erb', 'layout.haml').render
    File.open('client/offer.html', 'w') { |f| f.write html }

NOTE
----

Html2Email was put together very quickly to address a personal need. Most of the
work is done by [Tilt][] and [Premailer][], so it works just fine, but it lacks
tests and polish. Those are forthcoming.

Premailer is forked and vendored in `lib/html2email/vendor/premailer/`

Html2Email is not an email sending engine! It is only meant to ease the
development of HTML emails. You should be using a service like
[Campaign Monitor][] or [MailChimp][] to actually send bulk emails.

TODO
----

* Live mode (auto-compile with webrick server)
* Partials
* Tests
* Create <td width='\d+'> attributes in Premailer
* Mail configuration (external SMTP servers)
* Automatic conversion and upload of relative image links to a host via ssh/ftp?
* Maybe import ActionView or Sinatra::Helpers?

LICENSE
-------

    http://github.com/guns/html2email
    Copyright (c) 2010 Sung Pae <sung@metablu.com>
    Distributed under the MIT license.
    http://www.opensource.org/licenses/mit-license.php

[Tilt]: http://github.com/rtomayko/tilt
[Premailer]: http://github.com/alexdunae/premailer/
[Campaign Monitor]: http://www.campaignmonitor.com/
[MailChimp]: http://www.mailchimp.com/
[Sass]: http://sass-lang.com/
[LESS]: http://lesscss.org/
