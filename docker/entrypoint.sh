
#!/bin/bash

bundle exec rails db:migrate
bundle exec sidekiq -d -l log/sidekiq.log -q backfill,2 -q default -q webhook
rails server -e production -p 8080 -d

tail -f log/sidekiq.log
