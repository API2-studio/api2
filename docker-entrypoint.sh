#!/bin/sh
set -e
set -x

# Wait for the database to start
until ./bin/dynamic eval "Dynamic.Repo"; do
  echo "Database is unavailable - sleeping"
  sleep 1
done

# Perform the database migration
if [ ! -f /tmp/setup_done ]; then
  echo "Performing initial setup..."
  ./bin/dynamic eval "Dynamic.Release.create_and_migrate"
  touch /tmp/setup_done
fi

# Start the Elixir application
exec "$@"


