#!/bin/bash
set -e

APP_NAME=mywebapp
VERSION=SECURE

echo "scan code"

echo "stage build"
docker rm -f $APP_NAME 2>/dev/null || true
docker build -t $APP_NAME:$VERSION . 

echo "scan images"
docker scout cves $APP_NAME:$VERSION --output ./vulns.report
docker scout cves $APP_NAME:$VERSION --only-severity critical --exit-code
docker scout sbom --output $APP_NAME.sbom $APP_NAME:$VERSION

echo "Deploy"
docker run -d -p 80:80 --name webapp $APP_NAME:$VERSION
