# Guía de diseño — Valdoria RP

Identidad: **heráldica urbana**, sobria y premium. El azul noche crea profundidad, el borgoña aporta el sello distintivo y el oro se reserva para acciones y detalles de marca; el marfil mantiene legibilidad.

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

## Reglas

- Usar los tokens de `AppColors`; evitar colores sueltos dentro de widgets.
- Mantener contraste alto y reservar el oro para los elementos importantes.
- Conservar el lenguaje de escudo/sello en la marca, sin saturar todas las pantallas con adornos.
- No cambiar IP, puerto, intervalo de consulta ni comportamiento de conexión al hacer ajustes visuales.

## Cómo añadir cosas

- **Nueva pantalla**: valor en `AppPage`, entrada en `AppShell._pages` y botón en `AppNavRail._items`.
- **Cambiar IP/enlaces**: `lib/config/app_config.dart`.
