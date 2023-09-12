# PruebaBancolombia

Ejecutar los scripts en orden 

## Base de datos
- Nombre: datos.db
- Tipo de BD: SQLite3
- Herramienta recomendada: DB browser for sqlite 

Para ejecutar funciones matematicas asegurarse de tener la ultima version de SQLite3

### Actializar tipo de datos
1_ActualizarTipoDato.sql

### Crear tabla con el resultado y calculo de las tasas 
2_CrearTablaResultados.sql

## Configuracion env - librerias

### Paso 1 crear ambiente
- cd PruebaBancolombia
- pip install virtualenv
- virtualenv env 
- source env/bin/activate 

### Paso 2 librerias
- pip3 install pandas
- pip3 install sqlalchemy

## Ejecutar proyecto
- abrir la terminar desde la carpeta src
- python3 conexion_sql.py