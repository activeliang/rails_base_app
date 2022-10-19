docker compose run web bundle exec vite install
docker compose run web bundle exec rails db:create
docker compose run web bundle exec rails db:migrate
docker compose run web bundle exec rails db:seed