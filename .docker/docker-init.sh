docker compose run --no-deps web rails new . --force --database=postgresql --skip-turbolinks --skip-spring --skip-sprockets --skip-bundle

docker compose run web bundle exec vite install
docker compose run web bundle exec rails db:create
docker compose run web bundle exec rails db:migrate
docker compose run web bundle exec rails db:seed

