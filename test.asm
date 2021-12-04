segment .text

;; stolen from https://gitlab.com/tsoding/porth/-/blob/master/porth.py
;; function was generated from C using https://godbolt.org/
;; during this video: https://www.youtube.com/watch?v=8QP2fDBIxjM
;; function which i will use to print ints since i still
;; cant compile the standard C library.
puti: ;; void puti(int edi) { printf("%d", edi); } // approximately
    mov     r9, -3689348814741910323
    sub     rsp, 40
    mov     BYTE [rsp+31], 10
    lea     rcx, [rsp+30]
.L2:
    mov     rax, rdi
    lea     r8, [rsp+32]
    mul     r9
    mov     rax, rdi
    sub     r8, rcx
    shr     rdx, 3
    lea     rsi, [rdx+rdx*4]
    add     rsi, rsi
    sub     rax, rsi
    add     eax, 48
    mov     BYTE [rcx], al
    mov     rax, rdi
    mov     rdi, rdx
    mov     rdx, rcx
    sub     rcx, 1
    cmp     rax, 9
    ja      .L2
    lea     rax, [rsp+32]
    mov     edi, 1
    sub     rdx, rax
    xor     eax, eax
    lea     rsi, [rsp+32+rdx]
    mov     rdx, r8
    mov     rax, 1
    syscall
    add     rsp, 40
    ret


global _start
_start:
    mov    edi, 111231 ;; <-- this is the number to print
    call   puti
    mov    rax, 60
    mov    rdi, 0
    syscall
