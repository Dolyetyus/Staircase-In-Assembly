.data
.text
    prompt:                .asciz "Enter the height of the staircase: "
    formatstr:             .asciz "%lu"
    space:                 .asciz " "
    hash:                  .asciz "#"
    newlinechar:           .asciz "\n"

.global main
main:
    pushq   %rbp
    movq    %rsp, %rbp
    
    leaq    prompt(%rip), %rdi
    call    printf

	subq    $16, %rsp
    leaq    -8(%rbp), %rsi
    leaq    formatstr(%rip), %rdi
    call    scanf
    
    movq    -8(%rbp), %rdi
    call    staircase
    
    movq    $0, %rax
    popq    %rbp
    ret
    
staircase:
    pushq   %rbp
    movq    %rsp, %rbp

    movq    %rdi, %r12                      # n
    movq    $1, %r13                        # i = 1
    
outer_loop:
    cmpq    %r13, %r12
    jl      end
    
    movq    %r12, %r15                      # for spaces, n-i times
    subq    %r13, %r15
    movq    %r15, %rcx
    
spaces:
    cmpq    $0, %rcx
    je      hash_init

    pushq   %rcx                            # save rcx or it is overwritten
    pushq   %rcx                            # stack should be 16 byte aligned or printf won't work

    leaq    space(%rip), %rdi
    call    printf

    popq    %rcx                            # restore rcx
    popq    %rcx
    subq    $1, %rcx
    jmp     spaces

hash_init:   
    movq    %r13, %rcx

hashes:
    cmpq    $0, %rcx
    je      newline

    pushq   %rcx                            # save rcx or it is overwritten
    pushq   %rcx                            # stack should be 16 byte aligned or printf won't work

    leaq    hash(%rip), %rdi
    call    printf

    popq    %rcx                            # restore rcx
    popq    %rcx
    subq    $1, %rcx
    jmp     hashes

newline:
    leaq    newlinechar(%rip), %rdi
    call    printf

    incq    %r13
    jmp     outer_loop
    
end:
    popq    %rbp
    ret
