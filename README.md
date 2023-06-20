# Stripe Parser

Stripe Parser is a small project written on Ruby on Rails and used to fetch data from Stripe in the background.

## Requirements

1. MySQL installed with `utf8mb4` charset and `utf8mb4_unicode_ci` collation configured
2. Redis to store Sidekiq queue data
3. Ruby 2.3.x or 2.4.x

## Usage

1. Clone the repo: `git clone git@github.com:ingo4it/ruby-stripe-parser.git`
2. Install dependencies: `cd ruby-stripe-parser && bundle install`
3. Run sidekiq as a daemon: `bundle exec sidekiq -d -l log/sidekiq.log`
4. Start data fetchers: `rails runner "SyncAllScheduler.call"`

## Logging

There is a separate log file for each worker available inside `ruby-stripe-parser/log/`