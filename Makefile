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

NITRATE_MAJOR_VERSION = 4
NITRATE_MINOR_VERSION = 12
NITRATE_VERSION = $(NITRATE_MAJOR_VERSION).$(NITRATE_MINOR_VERSION)
PYTHON_VERSION = 3.10
ALPINE_VERSION = 3.16
REPOSITORY = carstencodes/nitrate

.PHONY: layers all web worker migrate setup latest
.DEFAULT: all

layers:
	docker build ./src/

worker: layers
	docker build -t $(REPOSITORY)-worker:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) --target worker ./src/

web: layers
	docker build -t $(REPOSITORY)-web:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) --target web ./src/

migrate: layers
	docker build -t $(REPOSITORY)-migrate:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) --target migrate ./src/

setup: layers
	docker build -t $(REPOSITORY)-setup:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) --target setup ./src/

all: web migrate setup worker

latest: all
	docker tag $(REPOSITORY)-setup:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) $(REPOSITORY)-setup:$(NITRATE_MAJOR_VERSION)-alpine
	docker tag $(REPOSITORY)-setup:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) $(REPOSITORY)-setup:latest

	docker tag $(REPOSITORY)-migrate:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) $(REPOSITORY)-migrate:$(NITRATE_MAJOR_VERSION)-alpine
	docker tag $(REPOSITORY)-migrate:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) $(REPOSITORY)-migrate:latest

	docker tag $(REPOSITORY)-web:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) $(REPOSITORY)-web:$(NITRATE_MAJOR_VERSION)-alpine
	docker tag $(REPOSITORY)-web:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) $(REPOSITORY)-web:latest

	docker tag $(REPOSITORY)-worker:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) $(REPOSITORY)-worker:$(NITRATE_MAJOR_VERSION)-alpine
	docker tag $(REPOSITORY)-worker:$(NITRATE_VERSION)-py$(PYTHON_VERSION)-alpine$(ALPINE_VERSION) $(REPOSITORY)-worker:latest
