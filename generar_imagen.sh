#!/bin/bash

# Script para generar imagen con Gemini
# Guardar como: generar_imagen.sh
# Uso: ./generar_imagen.sh "tu prompt aquí"

API_KEY="AIzaSyCH8x9EXs0MPLTWEcjfCFUWWE9sytkTn1Y"
PROMPT="${1:-Ilustración minimalista de El Sachayoj, viejo con cabello blanco hecho de enredaderas, protector del bosque, colores planos, estilo simple, tonos tierra cálidos}"

echo "Generando imagen con Gemini..."
echo "Prompt: $PROMPT"

curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp-image-generation:generateContent?key=$API_KEY" \
  -H "Content-Type: application/json" \
  -X POST \
  -d "{
    \"contents\": [{
      \"parts\": [
        {\"text\": \"$PROMPT\"}
      ]
    }],
    \"generationConfig\": {
      \"responseModalities\": [\"Text\", \"Image\"]
    }
  }" | jq -r '.candidates[0].content.parts[0].inlineData.data' | base64 -d > imagen_generada.png

if [ -f imagen_generada.png ] && [ -s imagen_generada.png ]; then
    echo "✅ Imagen guardada como: imagen_generada.png"
    ls -lh imagen_generada.png
else
    echo "❌ Error al generar la imagen"
    echo "Respuesta completa:"
    curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp-image-generation:generateContent?key=$API_KEY" \
      -H "Content-Type: application/json" \
      -X POST \
      -d "{
        \"contents\": [{
          \"parts\": [
            {\"text\": \"$PROMPT\"}
          ]
        }],
        \"generationConfig\": {
          \"responseModalities\": [\"Text\", \"Image\"]
        }
      }" | jq .
fi
