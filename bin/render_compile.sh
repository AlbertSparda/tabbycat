#!/usr/bin/env bash
# exit on error
set -o errexit

echo "-----> Install dependencies"
pip install -r ./config/requirements_core.txt
pip install -r ./config/requirements_render.txt

echo "-----> I'm post-compile hook"
cd ./tabbycat/

echo "-----> Running database migration"
python manage.py migrate --noinput

echo "-----> Running dynamic preferences checks"
python manage.py checkpreferences

echo "-----> Running static asset compilation"
npm install -g @vue/cli-service-global
npm install
npm run build

echo "-----> Running static files compilation"
python manage.py collectstatic --noinput

echo "-----> Post-compile done"
