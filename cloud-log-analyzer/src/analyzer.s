.section .data

msg_found:
    .ascii "Se detectaron 3 errores consecutivos.\n"
msg_found_len = . - msg_found

msg_not_found:
    .ascii "No se detectaron 3 errores consecutivos.\n"
msg_not_found_len = . - msg_not_found

.section .bss
    .align 3
buffer:
    .skip 4096

.section .text
.global _start

/*
    Mini Cloud Log Analyzer - Variante D

    Objetivo:
    Leer códigos HTTP desde stdin y detectar si existen
    3 errores consecutivos.

    Error HTTP:
    - 4xx: 400 a 499
    - 5xx: 500 a 599

    Entrada ejemplo:
    200 404 500 503 200 201 404 405 406 204
*/

_start:
    // read(0, buffer, 4096)
    mov x0, #0
    ldr x1, =buffer
    mov x2, #4096
    mov x8, #63
    svc #0

    cmp x0, #0
    ble not_found

    ldr x19, =buffer
    add x20, x19, x0

    mov x21, #0      // número actual
    mov x22, #0      // contador de errores consecutivos
    mov x23, #0      // bandera: se está leyendo número

parse_loop:
    cmp x19, x20
    b.ge end_of_input

    ldrb w24, [x19], #1

    cmp w24, #'0'
    b.lt separator

    cmp w24, #'9'
    b.gt separator

    // numero = numero * 10 + digito
    mov x23, #1
    sub w24, w24, #'0'

    mov x25, #10
    mul x21, x21, x25
    add x21, x21, x24

    b parse_loop

separator:
    cmp x23, #1
    b.ne parse_loop

    bl process_number

    mov x21, #0
    mov x23, #0

    b parse_loop

end_of_input:
    cmp x23, #1
    b.ne not_found

    bl process_number

    b not_found

process_number:
    // Error si 400 <= codigo <= 599
    cmp x21, #400
    b.lt reset_counter

    cmp x21, #599
    b.gt reset_counter

    add x22, x22, #1

    cmp x22, #3
    b.ge found

    ret

reset_counter:
    mov x22, #0
    ret

found:
    // write(1, msg_found, msg_found_len)
    mov x0, #1
    ldr x1, =msg_found
    mov x2, msg_found_len
    mov x8, #64
    svc #0

    // exit(0)
    mov x0, #0
    mov x8, #93
    svc #0

not_found:
    // write(1, msg_not_found, msg_not_found_len)
    mov x0, #1
    ldr x1, =msg_not_found
    mov x2, msg_not_found_len
    mov x8, #64
    svc #0

    // exit(1)
    mov x0, #1
    mov x8, #93
    svc #0
