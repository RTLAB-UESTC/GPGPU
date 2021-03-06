; 
; Copyright 2013 Jeff Bush
; 
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
; 
;     http://www.apache.org/licenses/LICENSE-2.0
; 
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
; 

;
; When the processor boots, only one hardware thread will be enabled.  This will
; begin execution at address 0, which will jump immediately to _start.
; This thread will perform static initialization (for example, calling global
; constructors).  When it has completed, it will set a control register to enable 
; the other threads, which will also branch through _start. However, they will branch 
; over the initialization routine and go to main directly.
;

					.text
					.globl _start
					.align 4
					.type _start,@function
_start:				
					; Set up stack
					getcr s0, 0			; get my strand ID
					shl s0, s0, 14		; 16k bytes per stack
					load_32 sp, stacks_base
					sub_i sp, sp, s0	; Compute stack address

					; Only thread 0 does initialization.  Skip for 
					; other threads (note that other threads will only
					; arrive here after thread 0 has completed initialization
					; and started them).
					btrue s0, skip_init

					; Call global initializers
					load_32 s24, init_array_start
					load_32 s25, init_array_end
init_loop:			seteq_i s0, s24, s25
					btrue s0, init_done
					load_32 s0, (s24)
					add_i s24, s24, 4
					call s0
					goto init_loop
init_done:			

					; Set the strand enable mask to the other threads will start.
					move s0, 0xffffffff
					setcr s0, 30

skip_init:			call main
					setcr s0, 29 ; Stop thread, mostly for simulation
done:				goto done

stacks_base:		.long 0x100000
init_array_start:	.long __init_array_start
init_array_end:		.long __init_array_end
