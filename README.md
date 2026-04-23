# Asignación de variantes para Mini Cloud Log Analyzer

Este documento está dirigido al profesorado para organizar la práctica tipo **GitHub Classroom**.

## Resumen de variantes

- **Variante A**: contar códigos **2xx, 4xx y 5xx**.
- **Variante B**: encontrar el **código más frecuente**.
- **Variante C**: detectar la **primera aparición de 503**.
- **Variante D**: detectar **3 errores consecutivos** (4xx/5xx).
- **Variante E**: calcular un **health score** del servicio.

---

# Portada del proyecto: Mini Cloud Log Analyzer (Bash Script + ARM64 Assembly)

## Nombre de la práctica
**Implementación de un Mini Cloud Log Analyzer en Bash Script + ARM64 Assembly**

## Variante asignada
**Variante D: detectar 3 errores consecutivos (4xx/5xx)**

## Objetivo general
Desarrollar un analizador simple de logs de servidor que procese códigos HTTP desde la entrada estándar o desde un archivo de texto, utilizando una combinación de:

- **Bash Script** para automatización,
- **ARM64 Assembly** para la lógica principal,
- **GNU Make** para compilación y ejecución,
- y ejecución final en un entorno **AWS Ubuntu 24 ARM64**.

## Propósito de la práctica
Esta práctica busca que el estudiante:

- comprenda el flujo de entrada de datos desde consola o archivo,
- implemente lógica de análisis en ensamblador ARM64,
- use syscalls Linux sin depender de libc,
- automatice compilación y pruebas con Bash y Make,
- y ejecute su solución en un entorno real de AWS ARM64.

## Qué se va a hacer
En esta variante se implementará un programa que lea una secuencia de códigos HTTP y determine si existen **3 errores consecutivos**, considerando como error cualquier código de las familias:

- **4xx**
- **5xx**

Si el programa encuentra tres errores seguidos, debe reportarlo.  
Si no los encuentra, debe indicar que no existe esa condición en el log.

---

# Enunciado específico de la Variante D

## Regla de análisis
Se debe detectar si en la secuencia de entrada aparecen **tres códigos de error consecutivos**, donde cada uno pertenezca a:

- 400 a 499, o
- 500 a 599.

## Ejemplo de log de entrada
```txt
200 404 500 503 200 201 404 405 406 204
```

## Interpretación del ejemplo
Analizando la secuencia:

- `200` → no es error
- `404` → error
- `500` → error
- `503` → error

Aquí ya aparecen **3 errores consecutivos**:

```txt
404 500 503
```

Más adelante también aparece otra secuencia válida:

```txt
404 405 406
```

## Resultado esperado
El programa debe indicar que:

```txt
Se detectaron 3 errores consecutivos.
```

Opcionalmente, puede mostrar la primera secuencia encontrada o su posición.

---

# Lógica que se implementará

## Idea general del algoritmo
El analizador recorrerá cada código HTTP de la entrada y mantendrá un contador de errores consecutivos.

### Reglas:
1. Si el código está en rango **4xx** o **5xx**, el contador aumenta en 1.
2. Si el código **no** es error, el contador vuelve a 0.
3. Si el contador llega a **3**, el programa reporta éxito y termina.

## Pseudocódigo
```txt
contador = 0

para cada codigo en la entrada:
    si codigo es 4xx o 5xx:
        contador = contador + 1
    si no:
        contador = 0

    si contador == 3:
        imprimir "Se detectaron 3 errores consecutivos"
        terminar

imprimir "No se detectaron 3 errores consecutivos"
```

---

# Estructura sugerida del proyecto

```txt
cloud-log-analyzer/
├── README.md
├── Makefile
├── run.sh
├── src/
│   └── analyzer.s
├── data/
│   └── logs_D.txt
├── tests/
│   └── test.sh
└── instructor/
    └── VARIANTES.md
```

## Descripción de archivos

### `README.md`
Documento principal con explicación del proyecto, requisitos, compilación y uso.

### `Makefile`
Automatiza:
- compilación,
- ejecución,
- pruebas,
- limpieza de artefactos.

### `run.sh`
Script Bash para facilitar la ejecución del analizador con un archivo de logs.

### `src/analyzer.s`
Código principal en **ARM64 Assembly**.  
Aquí se implementa la lógica para detectar los **3 errores consecutivos**.

### `data/logs_D.txt`
Archivo de prueba con el log de ejemplo:

```txt
200 404 500 503 200 201 404 405 406 204
```

### `tests/test.sh`
Script de validación automática para revisar si el programa responde correctamente.

---

# Flujo de trabajo recomendado

## 1. Crear el repositorio
Primero se crea el proyecto base en GitHub Classroom o en un repositorio normal.

## 2. Preparar archivos base
Se crean los archivos:
- `README.md`
- `Makefile`
- `run.sh`
- `src/analyzer.s`
- `data/logs_D.txt`

## 3. Implementar la lógica en Assembly
En `src/analyzer.s` se programa la detección de errores consecutivos.

## 4. Probar localmente
Se compila y ejecuta en Linux ARM64 o en un entorno compatible.

## 5. Subir a GitHub
Se documenta el proyecto y se suben avances al repositorio.

## 6. Ejecutar en AWS ARM64
Se despliega el proyecto en una instancia Ubuntu ARM64 y se valida su ejecución real.

---

# Cómo tenerlo listo para correr en AWS

## Requisitos previos
Se necesita una instancia con:

- **Ubuntu 24 ARM64**
- acceso por SSH,
- `git`,
- `make`,
- `binutils`,
- `gcc` o ensamblador compatible.

## Instalación de herramientas en AWS
Una vez dentro de la instancia, ejecutar:

```bash
sudo apt update
sudo apt install -y build-essential make gcc binutils git
```

## Clonar el repositorio
```bash
git clone TU_REPOSITORIO.git
cd cloud-log-analyzer
```

## Compilar
```bash
make
```

## Ejecutar con archivo de prueba
```bash
cat data/logs_D.txt | ./analyzer
```

o bien:

```bash
make run
```

## Ejecutar pruebas
```bash
make test
```

## Limpiar artefactos
```bash
make clean
```

---

# Ejemplo de contenido para `logs_D.txt`

```txt
200 404 500 503 200 201 404 405 406 204
```

---

# Salida esperada para el log dado

```txt
Se detectaron 3 errores consecutivos.
```
