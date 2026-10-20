# Plan de Trabajo y Versionamiento - Panadería Don Pan

Evidencias de referencia: `TRA-NK - Informe Técnico Plan de Trabajo.docx`
(GA7-220501096-AA1-EV01) y `TRA-NK - Instalación y Configuración de
Herramienta de Vers...docx` (GA7-220501096-AA1-EV04).

## 1. Herramientas de desarrollo

| Herramienta | Tipo | Función en el proyecto |
|---|---|---|
| Visual Studio Code | Editor | Editar HTML, CSS, JS y PHP |
| HTML5 | Lenguaje de marcado | Estructura de las páginas |
| CSS3 | Lenguaje de estilos | Diseño visual (`public/css/style.css`) |
| JavaScript | Lenguaje de programación | Interactividad en el navegador |
| PHP | Lenguaje de programación | Lógica de servidor y sesiones |
| MySQL | Base de datos | Almacenamiento relacional |
| MongoDB | Base de datos NoSQL | Práctica de la evidencia AA1-EV03 (`sql/query.sql`) |
| XAMPP | Servidor local | Ejecuta Apache, PHP y MySQL |
| Composer | Gestor de dependencias | `mongodb/mongodb` (driver oficial) |

> Nota: aunque el informe menciona Bootstrap, el proyecto **no lo usa**. El
> diseño está hecho con CSS propio, lo que evita dependencias de terceros y
> mantiene el control de la paleta documentada.

## 2. Versionamiento local vs. remoto

| Aspecto | Versionamiento local | Versionamiento remoto |
|---|---|---|
| Ubicación | En el PC del desarrollador | En un servidor en la nube |
| Internet | No requiere | Sí requiere |
| Colaboración | Individual | En equipo |
| Respaldo | Manual | Automático en la nube |
| Riesgo de pérdida | Alto | Bajo |
| Herramienta | Git (local) | GitHub, GitLab, Bitbucket |
| Comandos | `git init`, `git add`, `git commit` | `git push`, `git pull`, `git clone` |

Ambos son complementarios: el local permite trabajar sin internet y el remoto
aporta respaldo en la nube y colaboración.

## 3. Flujo de trabajo con Git y GitHub

```bash
git init                                             # Crear repositorio local
git add .                                            # Preparar cambios
git commit -m "Mensaje"                              # Guardar en local
git remote add origin <URL>                          # Conectar con el remoto
git push origin master                               # Subir cambios
git pull origin master                               # Descargar cambios
```

Repositorio remoto configurado:
`https://github.com/nikolasmv75/don_pan.git`

Verificación local rápida:

```powershell
git --no-pager log --oneline -5
git remote -v
```

## 4. Estándares de codificación aplicados

| Elemento | Estándar | Ejemplo en el proyecto |
|---|---|---|
| Variables | `snake_case` / `camelCase` (PHP) | `$stockMinimo`, `$idTurno` |
| Funciones | `camelCase`, verbo en infinitivo | `getConnection()`, `logAndRedirect()` |
| Clases | `PascalCase` | — (el proyecto es procedural) |
| Paquetes | minúsculas, separados por puntos | `mongodb/mongodb` |
| Comentarios | Explicar la lógica no evidente | Cabecera de cada archivo de `includes/` |
| Indentación | 4 espacios | Consistente en todo el proyecto |
| Longitud de línea | 80–100 caracteres | — |

### Reglas de seguridad que sigue el código

- Todo acceso a datos usa sentencias preparadas (`mysqli` + `bind_param`).
- Toda salida a HTML pasa por `htmlspecialchars()`.
- Los formularios incluyen token CSRF (`includes/csrf.php`).
- Las páginas restringidas validan sesión y rol (`requireLogin()`,
  `requireOwner()`).
- El login aplica bloqueo temporal tras 5 intentos fallidos.

## 5. Fases del plan

| Fase | Actividad | Estado |
|---|---|---|
| 1. Configuración | Instalar VS Code, XAMPP, Git y configurar GitHub | Completada |
| 2. Diseño | Estructura de carpetas y archivos base | Completada |
| 3. Desarrollo Frontend | Pantallas (login, dashboard, productos, ventas, inventario, clientes, reportes) | Completada |
| 4. Desarrollo Backend | Conexión a BD, validaciones, sesiones | Completada |
| 5. Base de datos | Esquema relacional y datos iniciales | Completada |
| 6. Pruebas | Verificar cada módulo con XAMPP y el navegador | Completada |
| 7. Versionamiento | Subir los cambios a GitHub tras cada avance | Continua |