from django.db import migrations, models
import django.db.models.deletion


def convert_user_ids(apps, schema_editor):
    LogEntry = apps.get_model('admin', 'LogEntry')
    User = apps.get_model('user_auth', 'User')
    
    # Create a mapping of id_no to UUID
    user_map = {user.id_no: user.id for user in User.objects.all()}
    
    # Update each log entry
    for log in LogEntry.objects.all():
        if log.user_id in user_map:
            log.user_id = user_map[log.user_id]
            log.save()


class Migration(migrations.Migration):

    dependencies = [
        ('user_auth', '0001_initial'),
        ('admin', '0003_logentry_add_action_flag_choices'),
    ]

    operations = [
        migrations.RunPython(
            convert_user_ids,
            reverse_code=migrations.RunPython.noop
        ),
    ] 