# TransacciónApi

Para iniciar su servidor Phoenix:

 * Ejecute `mix setup` para instalar y configurar dependencias
 * Inicie el punto final de Phoenix con `mix phx.server` o dentro de IEx con `iex -S mix phx.server`

Ahora puedes visitar [`localhost:4000`](http://localhost:4000) desde tu navegador.

## Endpoints
* **/api/generate_csv_link**
  * Usamos este punto final para generar un archivo CSV en segundo plano y una vez que el archivo esté listo podemos descargarlo con el enlace que proporciona este punto final.

* **/api/download_csv/:request_id**
  * Usamos este punto final para descargar el archivo CSV una vez que esté listo; si el archivo no está disponible, simplemente devolvemos un código de estado 425 demasiado temprano con un mensaje adicional.

* **/api/crear**
  * Usamos este punto final para crear una nueva transacción en la base de datos, pero la cuestión es que inmediatamente devolvemos un código de estado creado 201 y procesamos la transacción en otro proceso en segundo plano, de esta manera el usuario no necesita esperar hasta que se complete la transacción. guardado, es bueno mencionar que, de hecho, esto se está procesando en un GenServer, aunque la transacción falle al guardar el supervisor, se reiniciará el proceso inmediatamente.

**Nota:** Todos estos puntos finales leen estos valores de los headers shk_usr y shk_pwd, si estos valores faltan o están vacíos simplemente devolvemos un código de estado prohibido 403 y no procesamos ninguna acción.

## Stack tecnologico
* Lenguage: Elixir
* Framework: Phoenix
* Base de datos: PostgreSQL
* ORM: Ecto

**Nota**: Todas las dependencias utilizadas se enumeran en el archivo **mix.ex**

## Detalles técnicos

* Toda la logica relacionada a los puntos tecnicos solicitados en el reto se encuentran desarrollados en un solo controlador: lib/transaction_api_web/transaction_controller.ex este file contiene los 3 endpoints requeridos para cumplir con los detalles tecnicos de la prueba.

* Para ejecutar las tareas de forma asincrona se llevo a cabo uno de los features que nos prevee elixir; GenServers, para este ejercio cree un GenServer que ejecutara todas las tareas asincronas en otro proceso haciendo uso de la concurrencia y de esta forma no tenemos que esperar un resultado para darle un respuesta al usuario, mas bien le respondemos y nos quedamos procesando las tareas en otro proceso de manera asincrona, este GenServer este en: lib/server/transaction_server.ex

* Esta aplicación fue realizada utilizando todos los estándares generales que se utilizan al programar en Elixir, tanto la convención de nomenclatura como los estándares de codificación literal.

* En términos generales la aplicación cuenta con un contexto llamado **Transacciones** que se encarga de gestionar todas las operaciones con la base de datos. Hacemos uso de esto en el único controlador que tenemos en la aplicación que contiene todos los puntos finales solicitados en el ejercicio.

* En el controlador tenemos una llamada a un **GenServer** creado para manejar las operaciones asíncronas que se solicitaron en el ejercicio, esto nos permite ejecutar las tareas solicitadas en un proceso diferente sin afectar la respuesta del usuario.

* La aplicación también cuenta con doctests integrados (Unit Test) para funciones un poco críticas o que puedan tener algún otro comportamiento, esto para asegurar la calidad de dichas funciones.

* Implementé algunas pruebas unitarias para funciones críticas, en este caso las pruebas unitarias se implementaron usando doctests, esta es una manera fácil de implementar pruebas unitarias en elixir.

* Se implementó en la capa de persistencia el punto relacionado con el campo monto que debe ser decimal hasta dos decimales, esto significa que la validación se va a realizar cuando intentemos guardar una transacción en la base de datos. Puedes consultar esto en priv/repo/migrations/20240524200822_create_transactions.ex
