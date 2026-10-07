# Guía de diseño

Estilo: **mosaico geométrico** (Bauhaus). Paneles rectangulares pegados entre sí, esquinas rectas,
formas simples (semicírculos, círculos concéntricos, asterisco, franjas) y 3 colores.

## Colores (`lib/ui/theme/app_colors.dart`)

| Token | Hex | Uso |
|---|---|---|
| `ink` | `#231F20` | Paneles oscuros |
| `gold` | `#BB8F0A` | Acción principal, acentos |
| `cream` | `#FCF9F2` | Paneles claros, texto |
| `inkDeep` | `#181516` | Fondo de la app |
| `inkRaised` | `#2F2A2B` | Panel oscuro secundario |
| `creamDim` / `inkMuted` | `#B9B3AA` / `#6B6465` | Texto secundario sobre negro / sobre crema |

Reglas: no escribir `Color(0xFF…)` en widgets; el texto usa `AppText.*` (heredan el color del panel);
`AppColors.on(fondo)` devuelve negro o crema según el contraste.

## Cómo añadir cosas

- **Nuevo panel**: `GeoTile(color: …, decorations: […], child: …)` dentro de un `Expanded`.
- **Nueva forma**: un `CustomPainter` más en `widgets/geo_shapes.dart`.
- **Nueva pantalla**: valor en `AppPage` (`bloc/ui/pager_bloc.dart`), entrada en `AppShell._pages`
  y botón en `AppNavRail._items`.
- **Cambiar IP/enlaces**: `lib/config/app_config.dart`.
