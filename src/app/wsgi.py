#
# Copyright (c) 2022 Carsten Igel.
#
# This file is part of Nitrate Alpine Docker Images With Social-Auth 
# (see https://github.com/carstencodes/nitrate-images).
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
import os

from django.core.wsgi import get_wsgi_application
from whitenoise import WhiteNoise

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "nitrate.settings")

application = get_wsgi_application()
application = WhiteNoise(application, root="/var/www")
application.add_files("/usr/share/nitrate/static/", prefix="static/")

