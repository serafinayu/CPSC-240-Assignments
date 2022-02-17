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

welMessage db "We take care of all your triangles.", 10

input1prompt db "Please enter your name: "

instructions1 db "Good morning "
string_format db "%s"
instruction2 db ", please enter the length of side 1, length of side 2, and size (degrees) of the included angle between them as real float numbers. Separate the numbers by white space, and be sure to press <enter> after the last inputted number.", 10

input2prompt db 

one_float_format db "%lf", 0

output_floats_inputted db "You entered %.10lf  %.10lf  %.10lf", 10, 0
output_area_float db "The area of your triangle is %.10lf", 10, 0
output_perimeter_float db "The perimeter is %.10lf", 10, 0



segment .bss
; Empty segmentL there are no un-initialized arrays.


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

;Output welcome message
mov rax

mov rax,3
mov rdi, three_float_format
mov rsi, rspP
call scanf
movsd xmm10, [rsp]
pop rax
movsd xmm11, [rsp]
pop rax
movsd xmm12, [rsp]
pop rax


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


