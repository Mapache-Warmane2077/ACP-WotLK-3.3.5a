# ACP 3.3.8-WotLK

**Edición comunitaria no oficial de Addon Control Panel para World of Warcraft 3.3.5a.**

ACP 3.3.8-WotLK conserva y actualiza la experiencia clásica de Addon Control Panel, manteniendo la compatibilidad con el cliente de World of Warcraft 3.3.5a y con los datos guardados por ACP 3.3.7.

Este proyecto no está afiliado ni mantenido por el equipo actual del proyecto oficial ACP.

---

## Compatibilidad

- World of Warcraft 3.3.5a
- Interfaz `30300`
- Lua 5.1
- Compatible con los datos guardados de `ACP_Data` de ACP 3.3.7
- No utiliza API modernas de Retail, Classic actual ni Cataclysm Classic

---

## Funciones principales

- Activar y desactivar AddOns sin volver a la pantalla de selección de personaje.
- Cargar AddOns marcados como carga bajo demanda.
- Proteger AddOns importantes para evitar que sean desactivados.
- Guardar, cargar y renombrar conjuntos de AddOns.
- Ordenar y agrupar AddOns mediante distintos criterios.
- Mostrar dependencias, bibliotecas embebidas, estado y compatibilidad.
- Activar automáticamente las dependencias necesarias.
- Sistema de localización centralizado con fallback seguro al inglés.
- Detección automática del idioma en clientes oficiales.
- Selección manual de idioma para clientes con traducciones comunitarias.
- Selector visual de idioma dentro de la ventana de ACP.
- Compatibilidad con archivos de traducción creados para ACP 3.3.7.
- Corrección de varios errores heredados del addon original.

---

## Idiomas incluidos

ACP incluye traducciones completas para:

- `enUS` — English
- `enGB` — English (United Kingdom)
- `enCN` — English para clientes chinos comunitarios
- `deDE` — Deutsch
- `frFR` — Français
- `esES` — Español (España)
- `esMX` — Español (Latinoamérica)
- `ptBR` — Português (Brasil)
- `itIT` — Italiano
- `ruRU` — Русский
- `koKR` — 한국어
- `zhCN` — 简体中文
- `zhTW` — 繁體中文

Los idiomas oficiales se seleccionan automáticamente mediante `GetLocale()`.

Algunos clientes traducidos por la comunidad continúan identificándose como `enUS`. En esos casos, utiliza el selector de idioma dentro de ACP o los comandos indicados a continuación.

---

## Selección manual de idioma

Abre ACP y utiliza el desplegable de idioma situado junto al selector de ordenación.

También puedes utilizar:

```text
/acp locale
/acp locale ptBR
/acp locale esMX
/acp locale esES
/acp locale auto
```

Ejemplo:

```text
/acp locale ptBR
```

Fuerza el uso de portugués de Brasil.

```text
/acp locale auto
```

Elimina el idioma forzado y vuelve a la detección automática.

También se acepta `/acp language` como alias de `/acp locale`.

---

## Instalación

1. Descarga la versión más reciente desde la sección **Releases**.
2. Extrae el archivo ZIP.
3. Copia la carpeta `ACP` dentro de:

```text
World of Warcraft\Interface\AddOns\
```

La ruta final debe quedar así:

```text
World of Warcraft\Interface\AddOns\ACP\ACP.toc
```

4. Inicia World of Warcraft.
5. Activa Addon Control Panel desde la lista de AddOns.
6. Abre ACP desde el menú del juego o mediante:

```text
/acp
```

---

## Actualización desde ACP 3.3.7

ACP 3.3.8-WotLK conserva la estructura de `ACP_Data` y mantiene los conjuntos de AddOns guardados.

Antes de actualizar se recomienda crear una copia de seguridad de:

```text
WTF\Account\<CUENTA>\SavedVariables\ACP.lua
```

Reemplaza completamente la carpeta antigua:

```text
Interface\AddOns\ACP
```

No mezcles archivos de versiones diferentes dentro de la misma carpeta.

---

## Comandos

```text
/acp
/acp help
/acp nochildren
/acp norecurse
/acp debug
/acp locale
/acp locale <código>
/acp locale auto
/acp language <código>
```

### Descripción de los comandos

- `/acp` — Abre o cierra Addon Control Panel.
- `/acp help` — Muestra los comandos disponibles.
- `/acp nochildren` — Activa o desactiva el tratamiento de AddOns hijos de carga bajo demanda.
- `/acp norecurse` — Activa o desactiva la activación recursiva de dependencias.
- `/acp debug` — Activa o desactiva los mensajes de depuración de localización.
- `/acp locale` — Muestra el idioma detectado y el idioma utilizado por ACP.
- `/acp locale <código>` — Fuerza uno de los idiomas registrados.
- `/acp locale auto` — Vuelve a la detección automática.
- `/acp language <código>` — Alias de `/acp locale <código>`.

---

## Opción Recursive

Cuando **Recursive** está activado, al activar un AddOn ACP también intenta activar sus dependencias obligatorias y bibliotecas relacionadas.

Cuando está desactivado, ACP solo activa el AddOn seleccionado.

El comando:

```text
/acp norecurse
```

cambia la misma opción que la casilla **Recursive**.

---

## Pruebas

El proyecto incluye:

```text
ACP-SelfTest.lua
```

Este archivo es una batería de pruebas ejecutable desde línea de comandos y no es cargado por World of Warcraft.

Las pruebas automáticas comprueban, entre otras cosas:

- Claves y marcadores de localización.
- Fallback de idiomas.
- Selección manual y persistencia del idioma.
- Compatibilidad con localizaciones de ACP 3.3.7.
- Compatibilidad con `ACP_Data`.
- Migración de criterios de ordenación.
- Colisiones entre nombres de carpetas y claves traducibles.
- Sincronización de la opción Recursive.
- Funcionamiento del selector visual de idioma.

La versión actual supera 129 comprobaciones automáticas.

El diseño visual y el comportamiento de la API real de World of Warcraft deben seguir verificándose dentro de un cliente 3.3.5a.

---

## Estado del proyecto

Este proyecto se mantiene exclusivamente para World of Warcraft 3.3.5a.

No está destinado a:

- World of Warcraft Retail.
- Classic moderno.
- Cataclysm Classic.
- Expansiones posteriores.
- Clientes que utilizan la API moderna `C_AddOns`.

---

## Créditos

Autores y colaboradores originales de Addon Control Panel:

- sylvanaar
- Rophy
- Saien

ACP está basado en rMCP, una modificación de MCP realizada por Rophy y creado originalmente por Saien.

### Mantenedor de la edición para WotLK 3.3.5a

- Mapache-Warmane2077

---

## Licencia

Distribuido bajo la licencia MIT.

Consulta el archivo `LICENSE` para obtener más información.
