#!/bin/bash
# Docker entrypoint script.

# Fail on any error
set -e

# Navigate to the application directory
echo "Current directory content:"
ls

# Print the environment variables related to Postgres for debugging
echo "Testing if Postgres is accepting connections. Host: ${PGHOST}, Port: ${PGPORT}, User: ${PGUSER}"

# Wait until Postgres is ready to accept connections
until pg_isready -q -h "${PGHOST}" -p "${PGPORT}" -U "${PGUSER}"; do
  echo "$(date) - Waiting for database to start"
  sleep 2
done
echo "Database is up and accepting connections."
cd api_with_auth
# Check if the database exists and create, migrate, and seed if it doesn't
if ! psql -Atqc "\\list ${PGDATABASE}" > /dev/null; then
  echo "Database ${PGDATABASE} does not exist. Creating..."
  mix deps.get --only prod
  mix ecto.create
  mix ecto.migrate
  mix run priv/repo/seeds.exs
  echo "Database ${PGDATABASE} created and seeded."
else
  echo "Database ${PGDATABASE} already exists. Running migrations..."
  mix ecto.migrate
fi
# Prepare the application
echo "Cleaning and setting up the database..."
mix clean
mix ecto.setup

echo "Starting Phoenix server..."
# Start the Phoenix server
exec mix phx.server
