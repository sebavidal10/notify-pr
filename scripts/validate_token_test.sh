#!/bin/bash

# Script simple para probar la validación de tokens de GitHub desde la terminal

if [ -z "$1" ]; then
    echo "❌ Error: Debes proporcionar un token de GitHub como argumento."
    echo "Uso: ./validate_token_test.sh ghp_tu_token_aqui"
    exit 1
fi

TOKEN=$1

echo "🔍 Verificando token..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $TOKEN" https://api.github.com/user)

if [ "$RESPONSE" == "200" ]; then
    echo "✅ El token es VÁLIDO (200 OK)."
    # Obtener el login del usuario
    USER_LOGIN=$(curl -s -H "Authorization: token $TOKEN" https://api.github.com/user | grep '"login":' | sed -E 's/.*"login": "([^"]+)".*/\1/')
    echo "👤 Usuario: $USER_LOGIN"
elif [ "$RESPONSE" == "401" ]; then
    echo "❌ El token es INVÁLIDO o ha expirado (401 Unauthorized)."
else
    echo "❓ El servidor respondió con el código: $RESPONSE"
fi
