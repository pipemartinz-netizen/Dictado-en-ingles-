# Dictado Inglés — Prototipo

Prototipo funcional del **modo Dictado**: escuchar una oración en inglés,
escribirla, y ver la corrección palabra por palabra (verde = correcta,
rojo = incorrecta, ámbar = omitida, morado = de más), junto con
traducción y nota de gramática.

Usa el TTS nativo del dispositivo (`flutter_tts`) — funciona sin API keys
ni conexión a servicios de pago. La voz no es tan natural como
ElevenLabs/Azure, pero permite probar toda la mecánica ya mismo.

## Qué incluye este prototipo
- Pantalla de inicio con dos caminos: frases de ejemplo, o **pegar tu
  propio texto en inglés** (se divide automáticamente en oraciones y
  cada una se convierte en un dictado).
- Reproducción de la oración con control de velocidad (0.25x–2.0x).
- Campo de texto para escribir el dictado.
- Corrección automática palabra por palabra con colores.
- Traducción y nota gramatical tras revisar (solo disponibles en las
  frases de ejemplo; el texto pegado por ti no trae traducción todavía).
- Botón "Siguiente" para avanzar entre las oraciones de la sesión.

### Sobre "pegar cualquier texto"
La división en oraciones es simple (se corta por punto, signo de
exclamación o interrogación). Funciona bien con texto normal en
inglés. Casos raros como abreviaturas ("Mr.", "e.g.") pueden cortar
mal la oración — se puede mejorar más adelante con una librería de
segmentación o IA.

## Qué NO incluye todavía (siguientes pasos)
- Selección de nivel/tema/dificultad desde una pantalla de inicio.
- Historias, conversaciones, noticias, podcasts.
- Progreso guardado, XP, rachas, estadísticas.
- IA de análisis de errores y ejercicios personalizados.
- Reconocimiento de pronunciación ("Repetir conmigo").
- Modo offline con paquetes descargables.
- Panel de administración.
- Voces premium (ElevenLabs/Azure) — la interfaz `TtsService` ya está
  preparada para poder reemplazarse sin tocar el resto de la app.

## Cómo ejecutarlo

1. Instala Flutter: https://docs.flutter.dev/get-started/install
2. Verifica tu entorno:
   ```
   flutter doctor
   ```
3. Dentro de la carpeta del proyecto:
   ```
   flutter pub get
   flutter run
   ```
   (con un emulador Android abierto o un celular conectado por USB con
   depuración USB activada)

## Cómo generar el APK

```
flutter build apk --release
```

El archivo quedará en:
```
build/app/outputs/flutter-apk/app-release.apk
```

Ese APK ya se puede instalar directamente en un celular Android.

## Siguiente paso sugerido

Cuando este prototipo te convenza, el siguiente módulo natural es:
1. Pantalla de inicio con selección de nivel/tema/velocidad.
2. Persistencia local (SQLite/Hive) del progreso.
3. Ampliar el banco de frases y organizarlo por categorías reales.

Podemos construir cada uno por separado en las próximas conversaciones.
