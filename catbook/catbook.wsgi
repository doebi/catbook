import site
import os
import sys

path = '/vagrant/catbook'
if path not in sys.path:
    sys.path.append(path)

os.environ['DJANGO_SETTINGS_MODULE'] = 'catbook.settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()

import catbook.monitor
catbook.monitor.start(interval=1.0)
