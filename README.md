# Generador de tutoriales en video para 3D Slicer

Herramientas para convertir un flujo de 3D Slicer en un **tutorial en video** con capturas, recuadros y clics marcados, zoom, subtítulos y narración. Se creó para el tutorial [Cómo segmentar un tumor cerebral con 3D Slicer](https://github.com/AndresNenger/segmentacion-tumores-3dslicer/tree/main/04-tutorial-3dslicer) y se puede adaptar a otros.

## Qué hace cada pieza

| Archivo | Para qué sirve |
|---|---|
| `ejemplo_capturas_slicer.py` | Ejemplo completo de cómo capturar los pasos **dentro de 3D Slicer**: localiza cada botón por su nombre, hace clic por código, captura solo la ventana de Slicer y guarda cada paso con sus recuadros en `steps.json`. Es el punto de partida para tu propio tutorial. |
| `tts_windows.ps1` | Genera la narración de cada paso con una voz de Windows (`System.Speech`). |
| `animar.py` | Monta el video: aparece cada captura, hace zoom a lo marcado, dibuja los recuadros numerados y un clic animado, añade subtítulos y une la narración. También crea la miniatura. |
| `ejemplo/` | Un proyecto mínimo que funciona tal cual (2 pasos con su narración). |

## Probar con el ejemplo (5 minutos)

```bash
pip install numpy pillow imageio-ffmpeg
python animar.py ejemplo --rapido --titulo "Mi tutorial"
```

Genera `ejemplo/tutorial.mp4` (≈ 1 min 12 s) y `ejemplo/miniatura_youtube.png`. Sin `--rapido` usa todos los pasos del `guion.json`.

## Hacer tu propio tutorial

1. **Escribe el guion** (`guion.json`), con este formato:
   ```json
   {
     "steps": [
       {"name": "01_abrir_modulo", "title": "Abre el módulo X", "voz": "Texto que se dirá en voz alta",
        "subtitulo": "Texto en pantalla (opcional; si falta se usa 'voz')",
        "items": [{"rect": [x, y, ancho, alto], "label": "1"}], "click": [x, y]}
     ],
     "extra": {"intro": "...", "outro": "...", "subtitulo": "...", "pie": "...", "resumen": "..."}
   }
   ```
   `rect` y `click` están en píxeles de la captura. `ejemplo_capturas_slicer.py` los calcula solo a partir de los botones reales.
2. **Captura** cada paso en Slicer (con la ventana de Slicer visible) y guarda `capturas/NOMBRE_sin_marcas.png`.
3. **Narración:** `powershell -File tts_windows.ps1 -Proyecto mi_carpeta`. En Windows instala una voz en tu idioma (Configuración → Hora e idioma → Voz). La voz será sintética.
4. **Video:** `python animar.py mi_carpeta --titulo "..."`.

## Consejos aprendidos

- **Captura solo la ventana de Slicer**, no el escritorio: `mw.grab()` nunca incluye otras ventanas. En una de las primeras pruebas se coló otra aplicación con datos personales.
- **Ejecuta Slicer con su ventana abierta** (`Slicer.exe --python-script ...`): algunas herramientas, como Grow from seeds, se cierran sin interfaz.
- Escribe cómo se **pronuncian** las siglas en el campo `voz` ("Em Ar", "tres de") y deja el texto correcto en `subtitulo`.
- Revisa el video con una hoja de contactos (un fotograma cada pocos segundos) antes de subirlo.

## Limitaciones

- La captura con `ejemplo_capturas_slicer.py` funciona en **Windows** (probado con 3D Slicer 5.12.4). `animar.py` es portable, pero no lo probé fuera de Windows.
- La voz sintética de Windows suena a máquina; para un resultado más natural, graba tu propia voz y guárdala como `voz/NOMBRE.wav`.
- `ejemplo_capturas_slicer.py` y `ejemplo_seeds.py` están escritos para el caso del tumor (rutas de Windows incluidas): úsalos como guía, no como herramienta lista.

## Licencia

MIT, ver [`LICENSE`](LICENSE). Ejercicio educativo; no es un dispositivo médico.
