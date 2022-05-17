#!/usr/bin/env python3
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

from os import getenv
from time import sleep
from typing import Optional

from django import setup
setup()

from django.contrib.auth.models import User
from django.core.management import call_command
from django.db import connection

def create_super_user(username: str, 
                    password: str, 
                    email: Optional[str] = "", 
                    firstName: Optional[str] = "", 
                    lastName: Optional[str] = "") -> Optional[User]:
    invalidInputs = [None]

    if username is None or username.strip() in invalidInputs or password is None or password.strip() in invalidInputs:
        return None

    user = User(
        username = username,
        email = email,
        first_name = firstName,
        last_name = lastName,
    )
    user.set_password(password)
    user.is_superuser = True
    user.is_staff = True
    user.save()

    return user

def wait_for_db() -> None:
    connected: bool = False
    while not connected:
        try:
            connection.cursor()
            connected = True
        except:  # noqa
            sleep(0.5)


def initialize_db() -> None:
    call_command('migrate')
    
def set_default_permissions() -> None:
    call_command('setdefaultperms')

wait_for_db()
initialize_db()
set_default_permissions()
user = create_super_user(
    getenv("NITRATE_SUPERUSER_LOGIN"),
    getenv("NITRATE_SUPERUSER_PASSWORD"),
    getenv("NITRATE_SUPERUSER_EMAIL"),
    getenv("NITRATE_SUPERUSER_FIRSTNAME"),
    getenv("NITRATE_SUPERUSER_LASTNAME")
    )

if user is None:
    raise SystemExit("Failed to create superuser", 1)
