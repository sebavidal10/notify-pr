#!/bin/bash

# Este script incrementa el número de build (CURRENT_PROJECT_VERSION)
# usando la herramienta oficial agvtool de Apple.

# Asegurarse de estar en el directorio del proyecto
cd "$(dirname "$0")/.."

echo "🚀 Incrementando versión del proyecto..."

# Incrementar la versión usando agvtool
xcrun agvtool next-version -all

# Obtener la nueva versión
NEW_VERSION=$(xcrun agvtool what-version -terse)

echo "✅ Nueva versión de Build: $NEW_VERSION"

# Opcional: Si quieres que el script haga commit automáticamente de este cambio
# git add .
# git commit -m "chore: bump build version to $NEW_VERSION"
