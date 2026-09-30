# MySQL Workbench + XAMPP — Proyecto "Don Pan"

> Guía de conexión verificada en **este** equipo (Windows, XAMPP en `C:\xampp`,
> proyecto en `C:\xampp\htdocs\don_pan`). Todo lo de la sección 1 fue comprobado
> por consola, no es teoría.

---

## 0. Resumen rápido (los valores que necesitas)

| Campo                    | Valor correcto                                   |
|--------------------------|--------------------------------------------------|
| Connection Method        | **Standard TCP/IP** (nunca "over SSH", nunca "Local Instance") |
| Hostname                 | **127.0.0.1** (mejor que `localhost`)            |
| Port                     | **3306**                                         |
| Username                 | **root**                                         |
| Password                 | **vacío** → hay que guardarlo con *Store Password in Vault* |
| SSL / Use SSL            | **Never** (o "If the server supports it")        |
| Base de datos del proyecto | `don_pan`                                      |

> [!IMPORTANT]
> El servidor que trae XAMPP **no es MySQL, es MariaDB 10.4.32**. Ese dato explica
> casi todos los problemas con Workbench (ver secciones 2 y 6).

---

## 1. Estado real del equipo (diagnóstico verificado)

| Componente                  | Detalle verificado                                                     |
|-----------------------------|------------------------------------------------------------------------|
| Servidor de datos           | `C:\xampp\mysql\bin\mysqld.exe` → **MariaDB 10.4.32-MariaDB**          |
| Puerto                      | **3306** en escucha (`Get-NetTCPConnection` → PID de `mysqld`)         |
| Usuario `root`              | existe en `localhost`, `127.0.0.1` y `::1`, plugin `mysql_native_password`, **sin contraseña** |
| `my.ini` (`C:\xampp\mysql\bin\my.ini`) | `port=3306`, sin `bind-address`, sin `skip-networking` y **sin SSL configurado** |
| Servicio de Windows         | **NO existe** servicio de MySQL/MariaDB → se arranca desde *XAMPP Control Panel* |
| Apache / PHP                | Apache 2.4.58 + PHP 8.2.12 en puertos **80** y **443**                 |
| MySQL Workbench             | **versión 26.7.0** en `C:\Users\Nikol\AppData\Local\Programs\MySQL\MySQL Workbench` |
| Conexión guardada en Workbench | **ninguna** (no existe `server_instances.xml` ⇒ nunca llegó a conectarse) |
| Base `don_pan`              | existía **`0`** bases del proyecto; ya fue creada (ver sección 7)      |

Comandos con los que se obtuvo esta información (reutilizables, sección 9):

```powershell
# ¿MariaDB está corriendo y en qué puerto?
Get-NetTCPConnection -State Listen -LocalPort 3306 | Select-Object LocalPort, OwningProcess

# ¿Quién es el proceso?
Get-Process mysqld | Select-Object Id, Path

# ¿Entra root sin contraseña por TCP?
& 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp -e "SELECT VERSION(); SHOW DATABASES;"
```

---

## 2. Por qué no conectaba (las 4 causas reales)

1. **MariaDB no es un servicio de Windows.** En Workbench, el panel *Installed
   MySQL Servers / Local Instance* aparece vacío: si intentas conectarte por esa
   vía, falla. Hay que crear una conexión **Standard TCP/IP** manual.
2. **Contraseña vacía mal guardada.** Workbench 8/26 no acepta "dejar el campo en
   blanco": si no pulsas *Store Password in Vault…*, no envía credenciales y
   obtienes `1045 Access denied for user 'root'@'localhost'`.
3. **SSL.** `my.ini` de XAMPP no configura certificados. Si en la pestaña **SSL**
   dejaste *Use SSL = Require*, el intento muere con
   `2026 The SSL connection to the server was not made because it was compiled
   without SSL support` (o *SSL is not enabled in the server*).
4. **Workbench 26.x es herramienta de MySQL 9.x.** Oracle no soporta MariaDB: al
   conectarse a MariaDB 10.4 puede abrir y luego fallar al pintar los esquemas, o
   avisar de versión no soportada. No es culpa tuya ni de la configuración
   (soluciones en la sección 6).

Bonus: `sql/query.sql` **no es un script de MySQL**, es de **MongoDB**
(`db.clientes.drop()`, colecciones). Si lo importas en Workbench obtendrás errores
de sintaxis y parecerá que "la conexión está rota". Para MySQL solo se usan
`sql/schema.sql` y `sql/seed.sql` (ver 3.6).

---

## 3. Paso a paso: conectar Workbench a la MariaDB de XAMPP

### 3.1 Arrancar el servidor (siempre antes de tocar Workbench)

1. Abre **XAMPP Control Panel** como administrador (`C:\xampp\xampp-control.exe`).
2. Pulsa **Start** en la fila de **MySQL**. Debe aparecer `Status: Running` y
   `Port: 3306`.
3. Si **Stop** en **Apache** no hace falta para esto, déjalo Running igualmente.
4. Si MySQL **no arranca** (se apaga solo):
   - Abre `C:\xampp\mysql\data\mysql_error.log` y lee la última línea.
   - Causa típica: el 3306 ya lo usa otro MySQL instalado aparte.
     Compruébalo con el comando de la sección 9 y, si choca, cambia el puerto
     (sección 6.3).

Comprobación rápida sin panel: si esto responde, el servidor está bien

```powershell
& 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp -e "SELECT VERSION();"
# 10.4.32-MariaDB   ⇒ OK
```

### 3.2 Crear la conexión

1. Abre **MySQL Workbench**.
2. En la pantalla de inicio, junto a **MySQL Sessions**, pulsa el **`+`**
   (o menú *Database → Manage Connections → New*).
3. Rellena **solo** estos campos en la pestaña *Connection Name and Parameters*:

   | Campo                    | Qué poner                                        |
   |--------------------------|--------------------------------------------------|
   | Connection Name          | `Don Pan - XAMPP`                                |
   | Connection Method        | `Standard TCP/IP`                                |
   | Hostname                 | `127.0.0.1`                                      |
   | Port                     | `3306`                                           |
   | Username                 | `root`                                           |

   *Deja en blanco* `Allow Editing SQL Mode`, `Default Schema` (opcional:
   `don_pan`) y no toques *More options → System/Network*.
4. **No** uses *Test Connection* todavía: primero guarda la contraseña (3.3).

### 3.3 El paso que casi todo el mundo omite (contraseña vacía)

1. En esa misma ventana pulsa **`...`** a la derecha de **Password** (o el botón
   *Store Password in Vault…*).
2. En el cuadro *Enter password for root in 127.0.0.1* **deja el campo vacío**.
3. Pulsa **OK** (acepta guardar en el vault de Windows).
4. Verás que el campo Password pasa a mostrar `##########`. **Eso es correcto**
   aunque la contraseña real esté vacía: es la única forma de que Workbench
   envíe credenciales.

> [!WARNING]
> Si omites este paso el error será siempre `1045 Access denied`, y da la
> sensación de que "root no funciona" cuando sí funciona.

### 3.4 Desactivar SSL (imprescindible con XAMPP)

1. Pestaña **SSL** dentro de la misma ventana de conexión.
2. **Use SSL** → `No` (en otras versiones: `Never` / desmarcar *Use SSL*).
3. Si solo ofrece `If the server supports it`, esa opción también vale;
   **nunca** `Require`.
4. *SSL Client File Verifier* → `Don't verify server identity` (si aparece).
5. Dale **OK** para guardar la conexión.

### 3.5 Probar

1. En la pantalla de inicio, pasa el ratón sobre **Don Pan - XAMPP** y pulsa el
   rayo/**Test Connection**.
2. Resultado esperado:
   ```
   Connecting to 127.0.0.1:3306...
   Connection was successfully made!
   ```
3. Haz doble clic para abrir la pestaña SQL. Verás el *SCHEMA panel* con
   `information_schema`, `mysql`, `phpmyadmin`, `test` (y `don_pan` en cuanto
   exista).
4. Si al abrir tarda mucho o sale un aviso de versión de MariaDB, acepta/cierra
   el aviso: la consola SQL sigue siendo utilizable (ver sección 6 para el
   diagnóstico fino).

### 3.6 Crear e importar la base del proyecto

**Opción A — desde Workbench (recomendada para la evidencia):**

1. Menú **File → Open SQL Script…** y abre `C:\xampp\htdocs\don_pan\sql\schema.sql`.
2. Pulsa el rayo (**Execute**, `Ctrl+Shift+Enter`). Crea la base `don_pan` y sus
   7 tablas.
3. Abre ahora `C:\xampp\htdocs\don_pan\sql\seed.sql`, selecciona todo y ejecuta:
   inserta el turno *Mañana* y al usuario `admin`.
4. Refresca el panel **SCHEMAS** (clic derecho → *Refresh All*) para ver `don_pan`.

**Opción B — por consola (2 segundos):**

```powershell
cd C:\xampp\htdocs\don_pan
& 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp -e "source C:/xampp/htdocs/don_pan/sql/schema.sql"
& 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp -e "source C:/xampp/htdocs/don_pan/sql/seed.sql"
```

> [!NOTE]
> `schema.sql` ya lleva `CREATE DATABASE IF NOT EXISTS don_pan;` y
> `USE don_pan;`, así que no hace falta crear la base a mano.

### 3.7 Verificación final (ejecuta esto en la consola SQL de Workbench)

```sql
SELECT VERSION();                       -- 10.4.32-MariaDB
SHOW DATABASES LIKE 'don_pan';          -- 1 fila
USE don_pan;
SHOW TABLES;                            -- 7 tablas
SELECT usuario, rol FROM empleados;     -- admin | dueño
```

Y desde el navegador, la aplicación: `http://localhost/don_pan/`
→ usuario `admin`, contraseña `1234`.

---

## 4. Alternativa sin Workbench: consola MySQL y phpMyAdmin

```powershell
# Entrar a la consola interactiva (equivalente a la pestaña Query de Workbench)
& 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp
```

```sql
USE don_pan;
SELECT * FROM productos;
-- \s  -> estado del servidor |  \q -> salir
```

Exportar una copia de seguridad (para entregar o reinstalar):

```powershell
& 'C:\xampp\mysql\bin\mysqldump.exe' -u root --protocol=tcp --databases don_pan `
  --result-file=C:\xampp\htdocs\don_pan\sql\backup_don_pan.sql
```

phpMyAdmin (si Workbench se niega): **`http://localhost/phpmyadmin`**, entra con
`root` y contraseña vacía → pestaña *Importar* → elige `sql/schema.sql`.

---

## 5. Tabla de errores: mensaje → causa → solución

| Mensaje de Workbench | Causa | Solución |
|---|---|---|
| `Cannot connect to MySQL server on '127.0.0.1' (10061)` | MariaDB apagado o puerto distinto de 3306 | 3.1: arranca MySQL en XAMPP; revisa `port=` en `my.ini` |
| `Access denied for user 'root'@'localhost' (using password: NO)` | No guardaste la contraseña en el vault | 3.3: guardar **vacío** con *Store Password in Vault* |
| `Access denied ... (using password: YES)` | Escribiste una contraseña que root no tiene | 3.3 dejando el campo **vacío** |
| `2026 SSL connection ... compiled without SSL support` | XAMPP no tiene certificados SSL | 3.4: **Use SSL = Never** |
| `Lost connection at 'reading initial communication packet'` | Firewall/antivirus o `skip-networking` | Prueba `--protocol=tcp` por consola; quita `skip-networking` si existe |
| *Installed MySQL Servers / Local Instance* vacío o gris | MariaDB no está registrado como servicio | No lo instales: usa **Standard TCP/IP** (3.2) |
| `Unknown system variable` / *version not supported* / esquemas en blanco | Workbench 26.x no soporta MariaDB | Sección 6 |
| `1049 - Unknown database 'don_pan'` | Falta importar el esquema | 3.6 |
| `1064 You have an error in your SQL syntax` al importar `query.sql` | `query.sql` es de **MongoDB** | Usa solo `schema.sql` y `seed.sql` |
| MySQL no arranca en XAMPP | Puerto 3306 ocupado por otro MySQL | 6.3 |
| La app PHP: `Connection refused` / `Unknown database` | MariaDB apagado o base inexistente | 3.1 + 3.6 (la app lee `config/db.php`) |

---

## 6. Si Workbench sigue sin conectar con la MariaDB de XAMPP

### 6.1 La causa de fondo

* MySQL Workbench **26.7.0** pertenece a la serie de herramientas de MySQL 9.x.
* XAMPP distribuye **MariaDB 10.4** (ramo ya fuera de soporte).
* Oracle no garantiza compatibilidad Workbench ↔ MariaDB: la conexión TCP puede
  abrirse y luego Workbench fallar al leer `information_schema`.

Si el *Test Connection* dice **"Connection was successfully made"** pero la
ventana queda sin esquemas o lanza avisos de versión, **no es tu configuración**:
es esa limitación. Tres salidas, de menor a mayor esfuerzo.

### 6.2 Opción 1 — Quedarte con MariaDB y usar otra GUI (0 minutos)

* **phpMyAdmin**, ya instalado con XAMPP: `http://localhost/phpmyadmin`
  (`root`, sin contraseña). Permite crear tablas, importar `schema.sql`, editar
  datos y exportar el `.sql` de evidencia.
* **MySQL Shell** (ya viene con tu Workbench):

  ```powershell
  & "$env:LOCALAPPDATA\Programs\MySQL\MySQL Workbench\resources\app\shell\bin\mysqlsh.exe" --uri root@127.0.0.1:3306
  ```

  ```sql
  \use don_pan
  \show tables
  ```

### 6.3 Opción 2 — Servidor MySQL "de verdad" para que Workbench sea feliz

Si la evidencia del curso exige capturas de MySQL Workbench, instala
**MySQL Community Server 8.4 LTS** (instalador oficial, *Server only*, como
servicio de Windows) y luego:

1. En el asistente elige **puerto 3307** (deja el 3306 para MariaDB) **o** pulsa
   **Stop** en MySQL dentro de XAMPP y quédate con el 3306.
2. Crea la conexión en Workbench como en 3.2, con el puerto elegido y la
   contraseña que sí definiste en el asistente.
3. Importa `sql/schema.sql` y `sql/seed.sql` (3.6).
4. La app PHP debe apuntar al nuevo servidor. `config/db.php` lee variables de
   entorno, así que **no hace falta editar código**:

   ```powershell
   setx DB_HOST "127.0.0.1"
   setx DB_USER "root"
   setx DB_PASS "tu_password"
   setx DB_NAME "don_pan"
   ```

   Reinicia Apache para que herede las variables.

> [!WARNING]
> `config/db.php` hace `new mysqli(host, user, pass, db)`: **no admite puerto
> personalizado**. Si MySQL queda en 3307 hay que añadirlo:
> `new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME, (int)(getenv('DB_PORT') ?: 3306))`.
> Usando 3306 no necesitas tocar nada.

### 6.4 Opción 3 — Registrar MariaDB como servicio (solo para arranque automático)

```powershell
& 'C:\xampp\mysql\bin\mysqld.exe' --install MySQL-XAMPP --defaults-file="C:\xampp\mysql\bin\my.ini"
Start-Service MySQL-XAMPP
# Quitarlo: Stop-Service MySQL-XAMPP; & 'C:\xampp\mysql\bin\mysqld.exe' --remove MySQL-XAMPP
```

Esto **no** resuelve la incompatibilidad de Workbench; solo el arranque.

---

## 7. Estado de la base del proyecto (ya resuelto en este equipo)

| Objeto             | Estado                                                                                                                     |
|--------------------|----------------------------------------------------------------------------------------------------------------------------|
| Base `don_pan`     | ✅ creada (antes **no existía**: solo había `mysql`, `test`, `phpmyadmin`)                                                    |
| Tablas (7)         | ✅ `turnos`, `empleados`, `productos`, `clientes`, `ventas`, `detalle_ventas`, `movimientos_inventario`                       |
| Datos semilla      | ✅ 1 turno (*Mañana*) y 1 empleado (`admin`, rol `dueño`)                                                                   |
| Productos / ventas | 0 (se rellenan desde la app)                                                                                                 |
| Login de la app    | ✅ probado end-to-end: `admin` / `1234` → 302 a `ventas.php` con sesión iniciada                                              |

> [!IMPORTANT]
> El hash que venía en `sql/seed.sql` **no correspondía** a `1234`
> (`password_verify()` devolvía `false`), así que el inicio de sesión fallaba
> siempre aunque la base existiera. Se regeneró, se aplicó a la tabla
> `empleados` y se actualizó `sql/seed.sql`. Para generar uno nuevo:
>
> ```powershell
> & 'C:\xampp\php\php.exe' -r "echo password_hash('1234', PASSWORD_DEFAULT);"
> ```
>
> ```sql
> UPDATE don_pan.empleados SET password_hash = '<hash-nuevo>' WHERE usuario = 'admin';
> ```

---

## 8. Notas del repositorio que afectan a la base de datos

1. **Dos motores conviven en el proyecto.** `config/db.php` es MySQL/MariaDB
   (`mysqli`) y `config/mongo.php` es MongoDB. `sql/schema.sql` y `sql/seed.sql`
   son del primero; `sql/query.sql` es de **MongoDB** y no debe importarse en
   Workbench.
2. **Puertos en uso:** Apache `80`/`443`, MariaDB `3306`, MongoDB `27017` (si se usa).
3. **`.htaccess`** bloquea desde el navegador `/config/`, `/includes/` y los
   archivos `.sql`, `.md` y `.env`. Por eso este documento **no** se abre en
   `http://localhost/don_pan/mysql.md`: ábrelo en el editor (VS Code).
4. **Carpeta basura** generada por un `mkdir {config,includes,public...}` de Bash
   ejecutado en PowerShell (PowerShell no expande llaves):
   `don_pan\{config,includes,public\css,public\js,sql,actions}` — solo carpetas
   vacías. Puedes borrarla sin riesgo:

   ```powershell
   Remove-Item -LiteralPath 'C:\xampp\htdocs\don_pan\{config,includes,public' -Recurse -Force
   ```

---

## 9. Comandos de diagnóstico (copiar y pegar en PowerShell)

```powershell
# 1) ¿Servidor escuchando en 3306? ¿Qué binario y qué PID?
Get-NetTCPConnection -State Listen -LocalPort 3306 | Select-Object LocalAddress, LocalPort, OwningProcess
Get-Process mysqld | Select-Object Id, Path

# 2) ¿Hay algún servicio MySQL/MariaDB? (en este equipo: ninguno)
Get-Service | Where-Object { $_.Name -match 'mysql|maria' }

# 3) Autenticación real por TCP -> si esto responde, el servidor está bien
& 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp -e "SELECT VERSION(); SHOW DATABASES;"

# 4) Plugin y contraseña del root (pass_len = 0 significa SIN contraseña)
& 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp -e "SELECT user, host, plugin, CHAR_LENGTH(authentication_string) AS pass_len FROM mysql.user;"

# 5) Estado de la base del proyecto
& 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp -e "USE don_pan; SHOW TABLES; SELECT COUNT(*) AS productos FROM productos;"

# 6) ¿Apache sirve la app?
try { (Invoke-WebRequest 'http://localhost/don_pan/public/index.php' -UseBasicParsing -TimeoutSec 15).StatusCode } catch { $_.Exception.Message }
```

Login programático con CSRF incluido (el mismo que se usó para verificar):

```powershell
$jar = "$env:TEMP\dj.txt"
$url = 'http://127.0.0.1/don_pan'
$tok = [regex]::Match((curl.exe -s -c $jar -b $jar "$url/public/index.php"),
        'name="csrf_token"\s+value="([^"]+)"').Groups[1].Value
curl.exe -s -i -c $jar -b $jar -d "usuario=admin&password=1234&csrf_token=$tok" "$url/actions/login_action.php" | Select-Object -First 8
curl.exe -s -i -c $jar -b $jar "$url/public/ventas.php" | Select-Object -First 8
```

> [!TIP]
> **Regla de oro:** si el comando **3** responde, el servidor y las credenciales
> están bien y el problema vive solo en la ventana de conexión de Workbench
> (secciones 3.2 → 3.4). Si el **3** falla, el problema es del servidor
> (XAMPP apagado, puerto o credenciales) y Workbench no tendrá forma de conectar.



