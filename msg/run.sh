#!/bin/bash
# Script para ejecutar la aplicación MSG en diferentes plataformas

echo "🚀 Aplicación de Mensajería MSG"
echo "================================="

# Verificar dispositivos conectados
echo "📱 Dispositivos disponibles:"
flutter devices

echo ""
echo "🔧 Opciones de ejecución:"
echo "1. Web (Chrome) - Recomendado para Windows"
echo "2. Web (Edge) - Alternativo para Windows"
echo "3. Android - Para dispositivos Android"
echo "4. iOS - Para dispositivos iOS"
echo "5. Windows - Requiere CMake 3.23+"
echo ""

read -p "Elige una opción (1-5): " choice

case $choice in
    1)
        echo "🌐 Ejecutando en Chrome (Web)..."
        flutter run -d chrome
        ;;
    2)
        echo "🌐 Ejecutando en Edge (Web)..."
        flutter run -d edge
        ;;
    3)
        echo "📱 Ejecutando en Android..."
        flutter run -d android
        ;;
    4)
        echo "📱 Ejecutando en iOS..."
        flutter run -d ios
        ;;
    5)
        echo "💻 Ejecutando en Windows..."
        echo "⚠️  Asegúrate de tener CMake 3.23+ instalado"
        flutter run -d windows
        ;;
    *)
        echo "❌ Opción no válida"
        echo "💡 Recomendación: Usa opción 1 (Chrome) para desarrollo en Windows"
        ;;
esac
