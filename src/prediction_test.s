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
// Branch Prediction section of the prediction_test.s assembly program
// To advance to this section of the test, line 37, the halt statement mus be 
// commented out.
//
// The comment field includes the number of cycles to that porition of the code
// if you have branch prediction correctly implemented. At the halt statement,
// confirm that the values in the registers are correctly to verify that the
// recovery on a faile branch occurred correctly.
    nop                         // prediction cycle count = 10
    addi x3, x0, 0              // initially test register for loop count
    addi x4, x0, 0              // initially test register of recovered address
    addi x2, x0, 10             // set loop to a maximum of 10 iterations
LOOP:
    addi x3, x3, 1              // increment the number of times the loop occured
    addi x2, x2, -1             // decrement address counter
    bne x2, x0, LOOP            // predicted cycle count = 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46 (Failed prediction)
    addi x4, x4, 1              // due to the debugger, cycle count 46 where appear at the bne instead of this line
    nop
    nop
    nop
    nop                         // x3 should equal to number of loops, 10
    nop                         // x4 should equal to 1, only execute once after last bne
    halt                        // predicted cycle count = 52 cycles, if no prediction, 69 or 72 cycles
    nop
    nop
    nop
    nop
    nop
