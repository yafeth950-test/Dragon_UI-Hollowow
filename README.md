<div align="center">

# 🐉 DragonUI (WoW Hollow Edition)

[![Version](https://img.shields.io/badge/version-3.2-blue.svg)](https://github.com/yafeth950-test/Dragon_UI-Hollowow)
[![WoW Client](https://img.shields.io/badge/WoW-3.3.5a%20(12340)-gold.svg)](https://github.com/yafeth950-test/Dragon_UI-Hollowow)
[![Server](https://img.shields.io/badge/Server-WoW--Hollow-orange.svg)](https://github.com/yafeth950-test/Dragon_UI-Hollowow)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

**DragonUI** transforma la interfaz clásica de World of Warcraft 3.3.5a (Wrath of the Lich King) en la moderna, elegante y limpia interfaz de **Dragonflight / The War Within**.

*Versión adaptada y optimizada por **MiiKiis** especialmente para la comunidad y servidor de **WoW Hollow**.*

---

</div>

## ✨ Características Principales

- 🎮 **Estilo Moderno Dragonflight (Retail)**: Rediseño completo de barras de acción, marcos de unidad, minimapa, micro menú, bolsas, paneles y alertas.
- 📐 **Modo Editor Visual (`/dui edit`)**:
  - Cuadrícula milimétrica para alinear marcos en pantalla.
  - Arrastra y reposiciona libremente barras de acción, marcos de jugador/objetivo, avisos de botín, barras de lanzamiento y más.
  - Ajustes de coordenadas precisos con guardado automático por perfil.
- 🎁 **Módulo `ItemLoot` (Pretty Loot Alert)**:
  - Alertas emergentes (*loot toasts*) animadas con texturas HD y efectos de sonido para objetos épicos, legendarios, recetas, dinero y monturas.
  - Sincronizado al 100% con la card **"Botín"** del Modo Editor.
- 🔍 **Módulo `Iconic`**:
  - Iconos de objetos integrados directamente en los enlaces del chat.
  - Información extendida de nivel de objeto (*ilvl*), clase y mejoras en los paneles de comerciante y tooltips.
- 📊 **Control Modular Completo**:
  - Activa o desactiva módulos individuales desde el panel de opciones (**Módulos → Sistemas de IU**).
  - Vuelve a la interfaz por defecto de Blizzard para cualquier elemento que desees con un solo clic.
- 🌐 **Soporte Multilingüe (10 idiomas)**:
  - Español (esES, esMX), Inglés (enUS), Alemán (deDE), Francés (frFR), Portugués (ptBR), Ruso (ruRU), Coreano (koKR) y Chino (zhCN, zhTW).

---

## 📦 Estructura del Addon

| Módulo / Carpeta | Descripción |
|---|---|
| **DragonUI** | Core del addon: barras de acción, marcos de unidad, minimapa, castbars y utilidades. |
| **DragonUI_Options** | Panel de configuración en el juego (`/dragonui`). |
| **DragonUI_NewEra** | Port de paneles modernos (Libro de hechizos, talentos, profesiones, etc.). |
| **modules/itemloot** | Notificaciones animadas de botín integradas (*Pretty Loot Alert*). |
| **modules/iconic** | Iconos en chat, comerciantes y tooltips avanzados. |

---

## 🚀 Instalación

1. Descarga la última versión del repositorio:
   ```bash
   git clone https://github.com/yafeth950-test/Dragon_UI-Hollowow.git
   ```
2. Copia las carpetas en tu directorio de AddOns de World of Warcraft:
   ```
   World of Warcraft/Interface/AddOns/
   ├── DragonUI/
   ├── DragonUI_Options/
   └── DragonUI_NewEra/ (opcional)
   ```
3. Inicia el juego y asegúrate de marcar **"Cargar accesorios antiguos"** en la pantalla de selección de personajes.

---

## ⌨️ Comandos del Chat

| Comando | Acción |
|---|---|
| `/dragonui` o `/dui` | Abre el panel principal de configuración. |
| `/dui edit` o `/duiedit` | Activa o desactiva el **Modo Editor** para mover elementos en pantalla. |
| `/dragonui version` | Muestra la versión actual del addon en el chat. |
| `/dragonui help` | Lista todos los comandos disponibles. |

---

## 🛠️ Configuración y Opciones

Accede al menú escribiendo `/dui` o a través del botón en el minimapa / menú de juego:

1. **General / Acerca de**: Información de versión, idioma y créditos de desarrollo.
2. **Módulos**:
   - **Sistemas de IU**: Activa o desactiva Minimapa, Alertas de Botín (*Loot Toast*), Rastreador de misiones, etc.
   - **Barras de lanzamiento**: Opciones para jugador, objetivo y foco.
   - **Capas de marcos de unidad**: Predicción de sanación, escudos de absorción y pérdida animada de salud.
3. **Modo Editor**: Ajusta el tamaño de cuadrícula, resetea posiciones a valores predeterminados o guarda perfiles personalizados.

---

## 👥 Créditos y Autores

- **Adaptación y desarrollo para WoW Hollow**: [MiiKiis](https://github.com/yafeth950-test)
- **Desarrollo original**: **Neticsoul**
- **Contribuciones de la comunidad y forks previos**: **PentSec** (AscensionWoW), equipo DragonUI y colaboradores de código abierto.

---

## 📄 Licencia

Este proyecto está distribuido bajo la licencia **MIT** para el código propio del proyecto. Las dependencias externas empaquetadas conservan sus respectivas licencias originales de sus autores.
