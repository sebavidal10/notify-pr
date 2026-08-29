# Política de Privacidad de NotifyPR

Última actualización: Agosto 2026

**NotifyPR** es una aplicación de código abierto para macOS diseñada con un enfoque de privacidad por diseño (*privacy-first*). Esta política describe de manera transparente qué información procesa la aplicación, cómo se almacena y hacia dónde se transmite.

---

## 1. Sin Servidores Propios ni Intermediarios
- **NotifyPR no opera ningún servidor backend, base de datos ni proxy intermedio.**
- Todas las comunicaciones de red ocurren exclusivamente de forma directa entre tu Mac y la API oficial de GitHub (`https://api.github.com`) mediante HTTPS cifrado.
- NotifyPR no tiene acceso, visibilidad ni capacidad de interceptar tus datos o credenciales.

---

## 2. Almacenamiento Seguro del GitHub Token (macOS Keychain)
- **Dónde se guarda:** Tu Personal Access Token (PAT) de GitHub se almacena exclusivamente en el **macOS Keychain** local del sistema (utilizando la API del framework `Security` de Apple con la clase `kSecClassGenericPassword` y servicio `com.sebavidal.NotifyPR`).
- **Dónde NO se guarda:** El token nunca se almacena en `UserDefaults`, archivos de texto plano, `.plist`, registros del sistema (`logs`) ni en código fuente.
- **Destino del token:** El token únicamente se envía como encabezado de autorización HTTP (`Authorization: Bearer <TOKEN>`) a los endpoints oficiales de GitHub (`api.github.com/user` y `api.github.com/search/issues`). Nunca sale de tu equipo hacia ningún otro destino.
- **Eliminación:** Puedes eliminar tu token del Keychain en cualquier momento desde la pestaña de configuración de GitHub en la aplicación.

---

## 3. Preferencias de la Aplicación (`UserDefaults`)
NotifyPR almacena localmente en tu Mac únicamente preferencias generales de configuración no sensibles:
- Nombre de usuario de GitHub configurado (`gh_user`).
- Intervalo de refresco para consultas a GitHub (`refresh_interval`).
- Navegador web preferido para abrir enlaces (`default_browser`).
- Estado del modo demostración (`is_demo_mode`).
- Preferencia de búsqueda de actualizaciones en versiones no distribuidas por App Store (`auto_update_enabled`).

---

## 4. Datos Obtenidos desde GitHub
NotifyPR realiza consultas de solo lectura a la API de GitHub para obtener la siguiente información mínima necesaria:
- Estado y validez de la sesión autenticada (`/user`).
- Lista de Pull Requests abiertas donde se te solicita revisión (`/search/issues?q=is:open+is:pr+review-requested:<usuario>`):
  - Título del Pull Request.
  - URL del Pull Request en GitHub.
  - Nombre de usuario y URL del avatar del autor del PR (obtenido directamente desde `github.com` / `avatars.githubusercontent.com`).
- En la versión de GitHub (fuera de App Store), consulta la versión más reciente del repositorio público `sebavidal10/notify-pr/releases/latest` si la opción está activa.

NotifyPR **no** lee contenido de código fuente de tus repositorios, variables de entorno ni otros datos privados fuera de la metadata del PR requerida para la notificación.

---

## 5. Sin Telemetría ni Analíticas
- NotifyPR **no incluye herramientas de analítica, telemetría, rastreo de usuarios ni publicidad** (sin Google Analytics, Firebase, Sentry, Mixpanel ni similares).
- No se recopilan datos de uso, estadísticas ni identificadores de hardware.

---

## 6. Código Abierto y Auditoría
NotifyPR es un proyecto de código abierto. Puedes auditar e inspeccionar todo el código fuente, la gestión del Keychain y el manejo de red directamente en su repositorio de GitHub:
[https://github.com/sebavidal10/notify-pr](https://github.com/sebavidal10/notify-pr)
