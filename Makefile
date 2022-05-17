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

.PHONY: layers all web worker migrate setup latest
.DEFAULT: all

layers:
	docker build ./src/

worker: layers
	docker build -t carstencodes/nitrate/worker:4.12-py3.9-alpine3.15 --target worker ./src/

web: layers
	docker build -t carstencodes/nitrate/web:4.12-py3.9-alpine3.15 --target web ./src/

migrate: layers
	docker build -t carstencodes/nitrate/migrate:4.12-py3.9-alpine3.15 --target migrate ./src/

setup: layers
	docker build -t carstencodes/nitrate/setup:4.12-py3.9-alpine3.15 --target setup ./src/

all: web migrate setup worker

latest: all
	docker tag carstencodes/nitrate/setup:4.12-py3.9-alpine3.15 carstencodes/nitrate/setup:4-alpine
	docker tag carstencodes/nitrate/setup:4.12-py3.9-alpine3.15 carstencodes/nitrate/setup:latest

	docker tag carstencodes/nitrate/migrate:4.12-py3.9-alpine3.15 carstencodes/nitrate/migrate:4-alpine
	docker tag carstencodes/nitrate/migrate:4.12-py3.9-alpine3.15 carstencodes/nitrate/migrate:latest

	docker tag carstencodes/nitrate/web:4.12-py3.9-alpine3.15 carstencodes/nitrate/web:4-alpine
	docker tag carstencodes/nitrate/web:4.12-py3.9-alpine3.15 carstencodes/nitrate/web:latest

	docker tag carstencodes/nitrate/worker:4.12-py3.9-alpine3.15 carstencodes/nitrate/worker:4-alpine
	docker tag carstencodes/nitrate/worker:4.12-py3.9-alpine3.15 carstencodes/nitrate/worker:latest
