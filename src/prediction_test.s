/*
 * prediction_test.s
 *
 *  Created on: February 10th, 2023
 *      Author: kgraham
 */

 // Section .crt0 is always placed from address 0
	.section .crt0, "ax"

/********************************
 * Basic store instruction tests
 ********************************/

_start:
	.global _start

// Jump Prediction section of the prediction_test.s assembly program
//
// The commment field includes the number of cycles to that portion of the code
// if you have prediction or no prediction. The x5 register is initialized to 0
// before the jump test and should remain 0 whether prediction or no prediction
// is being performed.  The addi operations after the jump instruction must 
// be voided due to the control hazard of the jal instruction

    addi x5, x0, 0              // cycle 1
    jal x1, FIRST_TEST          // cycle 2
    addi x5, x0, 1              // no prediction = cycle 3
    addi x5, x5, 1              // no prediction = cycle 4
    addi x5, x5, 1
    addi x5, x5, 1
    addi x5, x5, 1
FIRST_TEST:
    nop                         // prediction = cycle 3, no prediction = cycle 5
    nop                         // prediction = cycle 4, no prediction = cycle 6
    nop                         // prediction = cycle 5, no prediction = cycle 7
    halt                        // prediction = cycle 6, no prediction = cycle 8, x5 = 0
    nop
    nop
    nop
    nop
