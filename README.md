# NotifyPR 🐙

**NotifyPR** es una herramienta nativa para la barra de menú de macOS diseñada para desarrolladores. Monitorea tus Pull Requests pendientes en GitHub con una interfaz moderna y visual, permitiéndote identificar rápidamente quién requiere tu atención sin interrumpir tu flujo de trabajo.

## ✨ Características

- **Vista Popover Moderna:** Una ventana flotante nativa (estilo SwiftUI) que te muestra el detalle de tus tareas.
- **🔐 Almacenamiento Seguro (Keychain):** Tu token de GitHub se guarda de forma segura en el Keychain de macOS, nunca en texto plano ni en UserDefaults.
- **⚙️ Gestión de Credenciales:** Flujo seguro de "Editar", "Guardar" y "Eliminar" token para evitar modificaciones accidentales o desvincular la cuenta fácilmente.
- **✅ Validación de Token en Tiempo Real:** Indicador visual sobre el estado de tu token (Válido, Inválido o Expirado).
- **⚠️ Confirmación de Seguridad:** Diálogos de confirmación al cerrar la app o al desvincular credenciales.
- **👤 Avatares de Usuarios:** Identifica visualmente al autor del PR mediante la integración de avatares oficiales de GitHub.
- **Contador Inteligente:** Visualiza el número de PRs pendientes o un indicador de carga directamente en la barra de menú.
- **Frecuencia Configurable:** Tú decides cada cuánto tiempo consultar la API de GitHub (1, 5 o 15 min).
- **Navegador Preferido:** Elige abrir tus PRs con tu navegador favorito (Safari, Chrome, Arc, Brave, Firefox o el predeterminado del sistema).
- **Auto-Update:** Sistema de actualizaciones automáticas (vía App Store o integrado para la versión de GitHub).

---

## 🛠️ Requisitos y Configuración

Para conectar NotifyPR con tu cuenta de GitHub necesitas un Personal Access Token (PAT). Puedes elegir entre dos modalidades:

### Opción 1: Fine-grained Personal Access Token (Recomendada - Privilegios Mínimos)
1. Ve a [GitHub Settings > Personal Access Tokens > Fine-grained tokens](https://github.com/settings/tokens?type=beta).
2. Selecciona el **Resource owner** (tu cuenta de usuario o tu organización).
3. En **Repository access**, selecciona **All repositories** (o los repositorios específicos que deseas monitorear).
4. En **Permissions > Repository permissions**, asigna:
   - **Pull requests**: `Read-only` *(permite listar y buscar PRs asignados para review)*.
   - *(Metadata: Read-only se habilita automáticamente por GitHub)*.
5. *Nota:* Los fine-grained tokens están asociados a un único propietario (usuario u organización). Si revisas PRs en múltiples organizaciones distintas, crea un token por organización o utiliza un token clásico.

### Opción 2: Personal Access Token Classic
1. Ve a [GitHub Settings > Personal Access Tokens > Tokens (classic)](https://github.com/settings/tokens).
2. Habilita el scope `repo` (o `public_repo` si únicamente revisas repositorios públicos).

### Configuración en la App
1. Abre **NotifyPR** y dirígete a la pestaña de GitHub (icono de candado 🔒).
2. Ingresa tu **Usuario de GitHub** y tu **Token**.
3. Haz clic en **Guardar** (icono de check ✓).

---

## 🔒 Privacidad y Seguridad

NotifyPR está diseñado bajo una arquitectura de **privacidad por diseño**:
- **Sin backend propio (Local-first):** Las credenciales y preferencias se almacenan localmente en tu Mac. NotifyPR no opera servidores intermedios ni bases de datos; la app se comunica de forma directa y exclusiva con la API oficial de GitHub (`https://api.github.com`).
- **Keychain de macOS:** El token de GitHub reside en el Keychain del sistema mediante la API de Seguridad de Apple.
- **Comunicación Directa:** Las peticiones de red viajan exclusivamente entre tu Mac y la API oficial de GitHub (`https://api.github.com`) vía HTTPS con autenticación `Bearer`.
- **Cero Telemetría:** Sin analíticas, sin rastreo de comportamiento y sin SDKs publicitarios.

Para más detalles, consulta nuestra [Política de Privacidad](PRIVACY.md).

---

## 🚀 Instalación

**Opción principal (Recomendada):**
1. Descarga **NotifyPR** directamente desde la [App Store](https://apps.apple.com/cl/app/notifypr/id6759353217?mt=12).
2. Abre la app y configura tus credenciales en el icono de configuración ⚙️ / candado 🔒.

**Opción alternativa (GitHub):**
1. Ve a la sección de [Releases](https://github.com/sebavidal10/notify-pr/releases).
2. Descarga el archivo `NotifyPR.zip` de la última versión.
3. Arrastra `NotifyPR.app` a tu carpeta de **Aplicaciones**.

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más información.

---

Desarrollado con ❤️ y Swift por [Sebastián Vidal Aedo](https://github.com/sebavidal10).
