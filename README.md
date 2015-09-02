[![Build Status](https://travis-ci.org/zanloy/tap.svg?branch=master)](https://travis-ci.org/zanloy/tap)
[![Coverage Status](https://coveralls.io/repos/zanloy/tap/badge.svg?branch=master&service=github)](https://coveralls.io/github/zanloy/tap?branch=master)

TaP is a ticket tracking website designed as a lightweight replacement to Jira.
It allows any use from a Google Apps domain to create tickets and track their
progress. TaP also allows you to attach purchases to a ticket. These purchases
will need to be approved by a manager of the project and then by a company
executive. Once they are approved, finance is notified and the items can be
purchased.

# Demo

Unfortunately TaP does not currently have a demo website. I am working on it
though so check back again soon.

# Installation

If you want to install the application on your own computer, you will need to be
using either Linux or Mac. Sorry, there are some requirements that do not work
on Windows.

## Requirements

You will need to have Ruby 2.1.4+ installed. You will need to have PostgreSQL
installed and setup for your user to have admin (or at a minimum 'create
database') access (the application needs to build the database). You will need
to have ImageMagick installed as well for image processing of file attachments.

## Steps

* Clone the repo

```
git clone https://github.com/zanloy/tap.git
```

* Create your environment file

In the tap directory, you will need to create a file called '.env' and put
some important information in there. The most important is your google auth
apikey and secret. TaP uses Google Oauth2 for authentication and without
this, you will not be able to login to the site. This site is designed to be
private so you can not access any information without logging in with a valid
account.

Here is the format:

```
GOOGLE_CLIENT_ID="SUPERSECRETCLIENTID"
GOOGLE_SECRET="SUPERSECRETSECRET"

# This is only needed in Production. Use rake secret to generate a secret key.
SECRET_KEY_BASE='BLAH'
```

* Use bundler to install packages

Run the following command in the tap directory.

```
bundle install --path .bundle
```

* Generate the database

This will create the database and table schemas.

```
bundle exec rake db:create db:migrate
```

* Seed the database

```
bundle exec rake db:seed
```

* Start the web server

This will spawn 2 processes. One is the main web server and another for a
background worker for delayed jobs.

```
bundle exec foreman start
```

* Visit the site in your web browser

Finally if all has gone well, you can visit the site in your web browser by
going to [http://localhost:5000/](http://localhost:5000/).

## Deployment

I use [capistrano](http://capistranorb.com/) for deploying the website to my
web server. I won't go into a lot of detail here since that is beyond the scope
of this readme. You will need to edit config/deploy/production.rb to setup your
web server information.

## Issues

If you have any feature requests or notice any bugs, please add an issue on
[GitHub](https://github.com/zanloy/tap/issues).
