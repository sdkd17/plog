# Diagnostico Automatico


## Caso de Uso Inicial

Voy a tomar como ejemplo un servicio de internet FTTH y voy a suponer que no tiene problemas comerciales (activo y con saldo).
Entonces, una evaluación podría ser (el orden puede estar equivocado):
 - Validar si está en falla mayor declarada (test falla mayor)
 - validar si esta en falla mayor no declarada (test de puerto)
 - validar si esta working y atenuacion (test de onu)
 - validar si navega (test HSI)

### Ejecución Secuencial

```yaml
en falla mayor declarada?:
    - SI -> Diagnostico=FALLA_MAYOR_DECLARADA(informacion de la falla).
    - NO -> working y atenuacion?:
        - SI -> navega?:
            - SI -> atenuacion_ok?:
                - SI -> Diagnostico= OK(datos de estado, atenuacion, sesion)
                - NO -> Diagnostico= ATENUACIN_MAL_NAVEGA(datos estado, atenuacin, sesion)
            - NO -> Diagnostico= NO_NAVEGA (datos estado, atenuacion,sesion)
        - NO -> falla_mayor_no_declarada?:
            - SI -> Diagnostico= FALLA_MAYOR_NO_DECLARADA (LOM,LON)
            - NO -> Diagnostico= LOS_INDIVIDUAL
```
 
### Ejecucion en Paralelo
De esta lista, ¿Qué cosas se pueden paralelizar? En principio el único problema es la consulta de puerto, que hay que optimizar sus invocaciones por su costo.

Teniendo eso en cuenta, puede quedar algo como (En paralelo mismo nivel de indentacion)
 - Validar si está en falla mayor declarada (test falla mayor)
 - validar si esta working y atenuacion (test de onu)
    - si no esta working y no esta en falla mayor declarada:
        - validar si esta en falla mayor no declarada (test de puerto)
 - validar si navega (test HSI)

Luego, determinar el diagnostico con reglas

```
falla_mayor_declarada(S) 
falla_mayor_no_declarada(S)
working(S)
atenuacion(S)
navega(S)

diagnostico(S,FALLA_MAYOR_DECLARADA) :- falla_mayor_delcarada(S).

diagnostico(S,OK) :- 
    \+ falla_mayor_delcarada(S), 
    working(S), 
    atenuacion(S), 
    navega(S).

diagnostico(S,NO_NAVEGA) :- 
    \+ falla_mayor_delcarada(S),
    working(S), 
    \+ navega(S).

diagnostico(S,ATENUACION_MAL_NAVEGA) :- 
    \+ falla_mayor_delcarada(S), 
    working(S), 
    \+ atenuacion(S), 
    navega(S).

diagnostico(S,FALLA_MAYOR_NO_DECLARADA) :- 
    \+ falla_mayor_delcarada(S), 
    \+ working(S), 
    falla_mayor_no_declarada(S).

diagnostico(S,LOS_INDIVIDUAL) :- 
    \+ falla_mayor_delcarada(S), 
    \+ working(S), 
    \+ falla_mayor_no_declarada(S)

```

## Implementacion

### Secuencial
El problema a resolver es como especificar el orden de ejecución de los tests.
Primero deberia ejecutarse el test de falla mayor, dependiendo del resultado de ese test se ejecutaria el resto o terminaria la ejecución devolviendo el diagnostico.

Ver en la definición de especificación de un test de la TMF si no se puede definir ahi el orden de ejecucion. Hay un atributo de la especificación que indicaba la relacion con los test hijos en el caso de un test compuesto. Quizá se pueda definir todo el arbol en la especificación del test padre.
El valor del diagnostico puede ser evaluado con reglas en la evaluación del test padre.

### Paralelo

Los test compuestos hoy en dia ejecutan los hijos en paralelo, en este caso igualmente esta el problema del test de puerto que tiene condiciones de ejecuión, si se ejecuta es depués del test de onu. 

Me parece tiene más sentido esta implementación, ejecuta todo lo que puedas en paralelo y después determiná el diagnostico. ¿Qué pasa con más niveles de dependencias?

## Observaciones

Partir el problema en dos
1. Cómo especificar de donde se obteniene la información necesaria para la base de conocimiento (Definir en el test padre que hijos se ejecutan y en que orden e insertar todas las medidas a la base de conocimiento)
2. Cómo obtener el diagnóstico a partir de lo conocido (reglas drools)
