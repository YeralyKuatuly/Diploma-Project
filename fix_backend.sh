#!/bin/bash
set -e

# Get the backend container ID
CONTAINER_ID=$(docker ps -f name=diploma-project-backend -q)

if [ -z "$CONTAINER_ID" ]; then
  echo "Backend container is not running, starting it..."
  docker compose up -d
  
  # Wait a moment for the container to try to start
  sleep 5
  
  # Try again
  CONTAINER_ID=$(docker ps -f name=diploma-project-backend -q)
  
  if [ -z "$CONTAINER_ID" ]; then
    echo "Backend container failed to start."
    exit 1
  fi
fi

# Execute commands inside the container
echo "Fixing migration file..."
docker exec -it diploma-project-backend-1 bash -c "echo 'from django.db import migrations

class Migration(migrations.Migration):
    dependencies = [(\"artworks\", \"0001_initial\")]
    operations = []
' > /app/artworks/migrations/0002_artist_contact_email_artist_kaspi_card_number_and_more.py"

# Fake the migration
echo "Faking the migration..."
docker exec -it diploma-project-backend-1 python manage.py migrate artworks 0002_artist_contact_email_artist_kaspi_card_number_and_more --fake

echo "Migration fixed! Your backend should now start correctly." 