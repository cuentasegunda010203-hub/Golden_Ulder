# Golden Underworld — integración del cliente SA-MP Android

## Objetivo

Convertir Golden Underworld en una experiencia propia de launcher + cliente SA-MP Android, manteniendo el launcher visual en Flutter y sin alterar el GameMode, MySQL ni el hosting Pterodactyl existente.

## Evaluación inicial del cliente existente

Se revisó el snapshot público de Alyn SA-MP Mobile v17.x:

- Fuente: https://github.com/east9-777/Nativo_ApkSamp
- Cliente nativo: Java + C++/JNI; usa el motor Android de GTA: San Andreas 2.10 (`libGTASA.so`).
- ABIs declaradas: `armeabi-v7a` y `arm64-v8a`.
- Herramientas declaradas: JDK 17, Android SDK 35, NDK 25.1.8937393 y CMake.
- El código fuente no incluye los archivos del juego.
- La publicación indica que se liberó públicamente, pero en el repositorio revisado no se identificó una licencia explícita que permita asumir redistribución o modificación comercial.

## Decisión de ingeniería

No se debe fingir que abrir `samp://` integra el cliente dentro de Golden Underworld. El puente de enlaces externo es provisional y no satisface el objetivo final.

Antes de fusionar el cliente nativo, hay que confirmar la licencia y los derechos de reutilización de su código y dependencias. Si no se puede confirmar, se debe pedir autorización al autor o elegir una base con licencia clara. No se incluirán APK de GTA SA ni datos propietarios del juego en el repositorio o en las compilaciones.

## Fases de implementación

1. **Auditoría del cliente:** revisar licencia, dependencias, manifest, permisos, CMake/JNI, almacenamiento y compatibilidad de la versión 2.10 del motor.
2. **Compilación independiente:** construir el cliente base con GitHub Actions para ARM64 y ARMv7, sin tocar el launcher Flutter.
3. **Prueba de funcionamiento:** instalar en dispositivo real, detectar una instalación legítima compatible del juego y conectar a un servidor SA-MP de prueba.
4. **Integración de producto:** incorporar el runtime nativo en el mismo paquete de Golden Underworld, con pantalla de inicio, estado de instalación, verificación de archivos, selector de servidor e inicio del juego dentro de la app.
5. **Instalador seguro:** descargar únicamente archivos cuya distribución esté autorizada; para los archivos del juego, guiar la instalación desde una fuente legítima y validar los archivos necesarios sin alojar copias no autorizadas.
6. **Verificación:** compilar el APK, probar instalaciones nuevas y actualizaciones, probar ambas arquitecturas y documentar limitaciones reales.

## Restricciones

- No modificar el GameMode ni el esquema MySQL actual.
- El servidor Pterodactyl sigue alojando el servidor SA-MP; no es necesario convertirlo en API para lograr la conexión básica del cliente.
- Los datos del jugador y la autenticación del juego deben seguir controlados por el servidor SA-MP.
- Una compilación exitosa no demuestra por sí sola que el juego funcione; la conexión y el renderizado requieren pruebas en dispositivo real.
