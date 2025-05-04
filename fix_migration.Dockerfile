FROM diploma-project-backend:latest

# Create an empty migration file to replace the problematic one
RUN echo "from django.db import migrations\n\
\n\
class Migration(migrations.Migration):\n\
    dependencies = [('artworks', '0001_initial')]\n\
    operations = []\n\
" > /app/artworks/migrations/0002_artist_contact_email_artist_kaspi_card_number_and_more.py

# Create a command to fake the migration
CMD python manage.py migrate artworks 0001_initial && \
    python manage.py migrate artworks 0002_artist_contact_email_artist_kaspi_card_number_and_more --fake && \
    python manage.py runserver 0.0.0.0:8000 