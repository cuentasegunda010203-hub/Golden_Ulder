# Guía de diseño — Valdoria RP

Identidad: **roleplay urbano tropical** con un sello premium. El paisaje combina cielo de atardecer, montañas costeras, edificios modernos, barrios de colores cálidos, palmeras y un paseo urbano; el borgoña y el oro siguen identificando Valdoria sobre paneles oscuros legibles.

## Colores (`lib/ui/theme/app_colors.dart`)

| Token | Hex | Uso |
|---|---|---|
| `ink` | `#151B2B` | Paneles azul noche |
| `inkDeep` | `#0D1220` | Fondo principal |
| `inkRaised` | `#20283A` | Paneles secundarios |
| `burgundy` | `#7D2638` | Sello de marca |
| `gold` | `#D5AD55` | Acciones y acentos |
| `cream` | `#F7F1E5` | Texto y superficies claras |
| `creamDim` | `#C4BEBA` | Texto secundario sobre fondos oscuros |

## Fondo ambiental

`lib/ui/widgets/cinematic_backdrop.dart` dibuja el paisaje con `CustomPainter`, sin depender de imágenes remotas. Las capas tienen movimiento ambiental suave y responden al cursor o al tacto con parallax. El contraste se controla con velos oscuros transparentes sobre el paisaje, no apagándolo por completo.

La inspiración es el ambiente de simuladores urbanos tropicales como Rio Rise; el arte de Valdoria es original y no reutiliza capturas, personajes ni logotipos del juego.

## Reglas

- Usar los tokens de `AppColors`; evitar colores sueltos dentro de widgets.
- Mantener contraste alto y reservar el oro para los elementos importantes.
- Conservar el lenguaje de escudo/sello en la marca, sin saturar todas las pantallas con adornos.
- No cambiar IP, puerto, intervalo de consulta ni comportamiento de conexión al hacer ajustes visuales.

## Cómo añadir cosas

- **Nueva pantalla**: valor en `AppPage`, entrada en `AppShell._pages` y botón en `AppNavRail._items`.
- **Cambiar IP/enlaces**: `lib/config/app_config.dart`.
