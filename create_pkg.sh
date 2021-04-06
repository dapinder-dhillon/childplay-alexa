#!/bin/bash
echo "Executing create_pkg.sh..."

export PIPENV_PIPFILE="$PIPFILE_LOCATION"
rm -rf "$LAMBDA_DIST_DIR"

mkdir "$LAMBDA_DIST_DIR"

pipenv lock -r > requirements.txt
# Create and activate virtual environment...
# shellcheck disable=SC2154
virtualenv -p "$RUNTIME" env_"$FUNCTION_NAME"
# shellcheck disable=SC1090
source env_"$FUNCTION_NAME"/bin/activate
pip3 install -r requirements.txt

# Deactivate virtual environment...
deactivate

# Create deployment package...
echo "Creating deployment package..."
# shellcheck disable=SC2164
cp -r env_"$FUNCTION_NAME"/lib/"$RUNTIME"/site-packages/. "$LAMBDA_DIST_DIR"
cp -r "$SOURCE_DIR"/ "$LAMBDA_DIST_DIR"

# Removing virtual environment folder...
echo "Removing virtual environment folder..."
rm -rf env_"$FUNCTION_NAME"
rm -rf requirements.txt

echo "Finished script execution!"
