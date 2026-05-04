# NotifyPR 🐙

**NotifyPR** es una herramienta nativa para la barra de menú de macOS diseñada para desarrolladores. Monitorea tus Pull Requests pendientes en GitHub con una interfaz moderna y visual, permitiéndote identificar rápidamente quién requiere tu atención sin interrumpir tu flujo de trabajo.

## ✨ Características

- **Vista Popover Moderna:** Una ventana flotante nativa (estilo SwiftUI) que te muestra el detalle de tus tareas.
- **🔐 Almacenamiento Seguro (Keychain):** Tu token de GitHub se guarda de forma segura en el Keychain de macOS, nunca en texto plano.
- **⚙️ Gestión de Token Mejorada:** Nuevo flujo de "Editar" y "Guardar" para evitar cambios accidentales y mejorar la seguridad.
- **✅ Validación de Token:** Indicador visual en tiempo real sobre el estado de tu token (Válido, Inválido o Expirado).
- **⚠️ Confirmación al Cerrar:** Diálogo de seguridad para evitar cerrar la app accidentalmente y perder notificaciones.
- **👤 Avatares de Usuarios:** Identifica visualmente al autor del PR gracias a la integración de avatares de GitHub.
- **Contador Inteligente:** Visualiza el número de PRs pendientes o un indicador de carga directamente en la barra de menú.
- **✨ Interfaz Optimizada:** Botones de configuración reemplazados por iconos (Guardar, Cancelar, Editar) para una vista más limpia y compacta.
- **Frecuencia Configurable:** Tú decides cada cuánto tiempo consultar la API de GitHub (1, 5, 15 o 30 min).
- **Auto-Update:** Sistema de actualizaciones automáticas (vía App Store o integrado para la versión de GitHub).

## 🛠️ Requisitos y Configuración

1. **GitHub Token:** Genera un _Personal Access Token (Classic)_ con el permiso `repo` habilitado.
2. **Usuario:** Ingresa tu nombre de usuario de GitHub en la configuración.
3. **Inicio Automático:** Opción integrada para arrancar la app al iniciar sesión en tu Mac.

## 🚀 Instalación

**Opción principal (Recomendada):**
1. Descarga **NotifyPR** directamente desde la App Store.
2. Abre la app y configura tus credenciales en el engranaje ⚙️.

**Opción alternativa (GitHub):**
1. Ve a la sección de [Releases](https://github.com/sebavidal10/notify-pr/releases).
2. Descarga el archivo `NotifyPR.zip` de la última versión.
3. Arrastra `NotifyPR.app` a tu carpeta de **Aplicaciones**.

---

Desarrollado con ❤️ y Swift por [Sebastián Vidal Aedo](https://github.com/sebavidal10).
