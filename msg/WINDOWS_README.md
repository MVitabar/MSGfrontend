# Ejecutar MSG en Windows

## 🚨 Problema de CMake

Si ves este error al ejecutar `flutter run`:
```
CMake Error: CMake 3.23 or higher is required. You are running version 3.20
```

## ✅ Solución: Ejecutar en Web

### **Opción 1: Chrome (Recomendado)**
```bash
flutter run -d chrome
```

### **Opción 2: Edge**
```bash
flutter run -d edge
```

### **Opción 3: Build para producción web**
```bash
flutter build web
# Luego abre build/web/index.html en tu navegador
```

## 🎯 Por qué Web es mejor para Windows

✅ **Sin problemas de CMake** - Web no necesita compilación nativa
✅ **Todas las funcionalidades** multimedia funcionan igual
✅ **Hot reload rápido** - Cambios se ven inmediatamente
✅ **Compatible con todas** las dependencias
✅ **Debugging fácil** - Herramientas de desarrollador del navegador

## 📱 Si quieres ejecutar en móvil

### **Para Android:**
1. Conecta tu dispositivo Android o inicia un emulador
2. Ejecuta: `flutter run -d android`

### **Para iOS:**
1. Conecta tu dispositivo iOS o usa Simulator
2. Ejecuta: `flutter run -d ios`

## 🔧 Configuración optimizada

Las dependencias han sido configuradas específicamente para:
- ✅ **Web**: Funciona perfectamente
- ✅ **Android**: Funciona perfectamente
- ✅ **iOS**: Funciona perfectamente
- ⚠️ **Windows**: Limitaciones por CMake (usa Web como alternativa)

## 🎮 Funcionalidades disponibles

**En Web todas las funcionalidades multimedia funcionan:**
- ✅ **Enviar imágenes** desde cámara o archivos
- ✅ **Enviar videos** con reproducción completa
- ✅ **Enviar audio** con controles de reproducción
- ✅ **Enviar documentos** con preview
- ✅ **Chat en tiempo real** con WebSocket
- ✅ **Autenticación completa**

## 🆘 Si necesitas CMake 3.23+

### **Actualizar CMake:**
1. Descarga desde: https://cmake.org/download/
2. Instala la versión 3.23 o superior
3. Reinicia tu terminal/IDE
4. Ejecuta: `flutter run -d windows`

### **O mejor aún:**
**¡Usa Web para desarrollo!** Es más rápido y no tiene problemas de dependencias.

---
**💡 Recomendación final: `flutter run -d chrome` para desarrollo en Windows**
