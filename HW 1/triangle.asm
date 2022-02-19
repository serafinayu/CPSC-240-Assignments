;*****************************************************************************************************************************
; Program Name: "Amazing Triangles". This program takes the lengths of 2 sides of a triangle and the degrees of 1 angle of  *
; a triangle from the user, and then calculates and prints out the area and perimeter of the triangle.                      *
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License *
; version 3 as published by the Free Software Foundation.                                                                   *
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied        *
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.    *
; A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                          *
;*****************************************************************************************************************************

;*****************************************************************************************************************************
; Author information:                                                                                                       *  
;   Author name: Serafina Yu                                                                                                *   
;   Author email: serafyu@csu.fullerton.edu                                                                                 *
;                                                                                                                           *
; Program information:                                                                                                      *
;   Program name: Amazing Triangles                                                                                         *
;   Programming languages: One modules in C++ and one in X86                                                                *
;   Date program began:     2022-Feb-4                                                                                      *
;   Date program completed: 2022-Feb                                                                                        *
;   Date comments upgraded:                                                                                                 *
;   Files in this program: triangle.asm, triangleDriver.cpp, run.sh                                                         *
;   Status: In progress                                                                                                     *     
;                                                                                                                           *
;                                                                                                                           *
; References for this program                                                                                               *
;                                                                                                                           *
;                                                                                                                           *
; Purpose                                                                                                                   *   
;                                                                                                                           *
; This file                                                                                                                 *
;   File name: triangle.asm                                                                                                 *
;   Language: X86                                                                                                           *
;                                                                                                                           *
;*****************************************************************************************************************************


extern printf
extern scanf

global triangle

segment .data

string_format db "%s", 0

welMessage db "We take care of all your triangles.", 10, 0
input1prompt db "Please enter your name: ", 0

instructions1 db "Good morning ", 0
instructions2 db ",please enter the length of side 1," 
              db "length of side 2, and size (degrees) of the included" 
              db "angle between them as real float numbers. Separate the" 
              db "numbers by white space, and be sure to press <enter> after" 
              db "the last inputted number.", 10, 0

three_float_format db "%lf %lf %lf", 0

thankYou db "Thank you ", 0
output_floats db ". You entered %1.7lf %1.7lf %1.7lf", 10, 0

output_area_float db "The area of your triangle is %1.7lf", 10, 0
output_perimeter_float db "The perimeter is %1.7lf", 10, 0
endMess db "The area will now be sent to the driver function.", 10, 0



segment .bss
;Create an empty string array that will hold the name of the user
full_name resb 32



segment .text
triangle:

;Back up the general purpose registers for the sole purpose of protecting the data of the caller.
push rbp                                                    ;Backup rbp
mov  rbp,rsp                                                ;The base pointer now points to top of stack
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
push qword -1  

;===== Output welcome message ===============================================================================

push qword 0
mov rax, 0
mov rdi, welMessage
call printf

;===== Ask user for his/her name ============================================================================

push qword 0
mov rax, 0
mov rdi, input1prompt
call printf

;===== Obtain users full name ===============================================================================

push qword 0
mov rdi, full_name
mov rsi, 32                     ;Tell rdi that full_name will have a max storage value of 32 bytes
mov rdx, [stdin]                ;Let fgets know where the data is coming from (comes from keyboard [stdin])
call fgets
;added this below from SI notes (go over what it means)
; mov rax, 0
; mov rdi, number
; call strlen
; sub rax, 1
; mov byte[full_name+rax], 0

;===== Get # of chars in full_name ==========================================================================

push qword 0
mov rax, 0
mov rdi, full_name
call strlen
mov r14, rax                    ;r14 holds the # of chars

;===== Output instructions ==================================================================================

push qword 0
mov rax, 0
mov rdi, instructions1  
call printf

;Print the name after instructions1
push qword 0
mov rax, 0                    
mov [full_name+r14-1], '\0'
mov rdi, string_format          ;"%s"
mov rsi, full_name              ;full_name = user name w/o the new line 
call printf

;Output instructions2
push qword 0
mov rax, 0
mov rdi, instruction2
call printf

;===== Obtain user's choice of 2 side lengths and angle in degrees ==========================================

mov rax, 3                      ;Returning a value (3 floats) to the call function scanf
mov rdi, three_float_format     ;"%lf %lf %lf"
push qword 0                    ;Push qword 0, 3 times since we're adding 3 numbers to the stack
mov rsi, rsp                    ;Moves rsp down one 
push qword 0
mov rdx, rsp
push qword 0
mov rcx, rsp
call scanf                      ;Call scanf to read in the values

movsd xmm13, [rsp]              ;Moves the third inputted number (which is the angle) into xmm13 
pop rax                         ;Get rid of this part of the stack so that rsp points to the 2nd float
movsd xmm14, [rsp]              ;Moves the second inputted float into xmm14
pop rax
movsd xmm15, [rsp]              ;Moves the first inputted float into xmm15
pop rax

;===== Output thank you message==============================================================================

push qword 0
mov rax, 0
mov rdi, thankYou
call printf

;Print name after thank you message
push qword 0 
mov rax, 0 
mov rdi, string_format
mov rsi, full_name
call printf

;Print output statement
push qword 0
mov rax, 3
mov rdi, output_floats          ;". You entered %1.7lf %1.7lf %1.7lf"
movsd xmm0, xmm15               ;Store side1 into xmm0
movsd xmm1, xmm14               ;Store side2 into xmm1
movsd xmm2, xmm13               ;Store angle into xmm2
call printf                 
pop rax 

;===== Calculate area of triangle ==========================================================================

;Formula for area = (1/2)ab(sin(C))

;xmm0 = side1, area
;xmm1 = side2
;xmm2 = angle, sin(angle)
;xmm12 = 1/2

push qword 0
mov rax, 1
mov rdi, output_area_float
movsd xmm12, 0.5
mulsd xmm2, sin(xmm2)













;************************************************************************************************************
;Obtain from user 2 side length & angle
mov rax, 3                      ;3 since we're using 3 floats
mov rdi, three_float_input      ;Tell rdi we're inputting it into the 3 float input stencil
push qword 0                    ;Push qword 0, 3 times since we're adding 3 numbers to the stack
mov rsi, rsp                    ;Moves rsp down one 
push qword 0
mov rdx, rsp
push qword 0
mov rcx, rsp
call scanf                      ;Call scanf to read in the values

movsd xmm13, [rsp]              ;Moves the third inputted number (which is the angle) into xmm13 
pop rax                         ;Get rid of this part of the stack so that rsp points to the 2nd float
movsd xmm14, [rsp]              ;Moves the second inputted float into xmm14
pop rax
movsd xmm15, [rsp]              ;Moves the first inputted float into xmm15
pop rax


;Print thank you statement
mov rax, 0
mov rdi, input2prompt

;mov rdi, three_float_format
push qword 99
push qword -700
push qword 6850
mov rsi, rspcall scanf
movsd xmm13, [rsp]
pop rax
movsd xmm14, [rsp]
pop rax
movsd xmm15, [rsp]
pop rax

; Compute cos of angle = xmm13mov rax, 1
movsd xmm0, xmm13
; When you call cos, it puts the value back into xmm0
call cos 
movsd xmm12, xmm0 

; How to compute degrees to radians
; Put pi into xmm10
mov rax, 0x400821FB54442D18
push rax
movsd xmm10, [rsp]
pop rax
; Now xmm10 = pi

; Put 180.0 into xmm9
mov rax, 180
cutsi2sd xmm9, rax
; xmm13 = angle degrees
; xmm10 = pi
; xmm9 = 180.0
; xmm12 = angle radians
movsd xmm12, xmm13
;mulsd multiplies whats already in xmm12 by pi (whats in xmm10)
mulsd xmm12, xmm10
;divsd divides whats in xmm12 by 180.0 (whats in xmm9)
divsd xmm12, xmm9
; Now xmm12 = angle radians


