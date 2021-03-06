/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function
	
	int i;
	int round;
	unsigned char state[4*4];
	unsigned char Key[4*4];
	unsigned long w[4*(10+1)];
	// assign the words for state and key
	for (i=0;i<16;i++){
		state[(i%4)*4 + i/4] = charsToHex(msg_ascii[2*i],msg_ascii[2*i+1]);
		Key[(i%4)*4 + i/4] = charsToHex(key_ascii[2*i],key_ascii[2*i+1]);
	}

	// create words by KeyExpansion
	KeyExpansion(Key,w,4);
	for (i=0; i<4; i++){
		key [i] =Key[i]<<24 | Key[i+4]<<16 | Key[i+8]<<8 | Key[i+12];
	}

	//Initial Round by AddRoundKey
	AddRoundKey(state,w);

	//9 Encryption rounds
	for (round = 1; round <= 9; round = round + 1){
		SubBytes(state);
		ShiftRows(state);
		MixColumns(state);
		AddRoundKey(state,w+round*4);
	}

	//Last round
	SubBytes(state);
	ShiftRows(state);
	AddRoundKey(state,w+10*4);

	//Encrypted message output
	for (i=0; i<4; i++){
		msg_enc[i]= state[i]<<24 | state[i+4]<<16 | state[i+8]<<8 | state[i+12];
	}
}

// Some help functions

/*
 * KeyExpansion
 * Functionality: Takes the Cipher Key and performs a Key Expansion to generate a 
 * series of Round Keys (4-Word matrix) and store them into Key Schedule
 *
 * Input: three arrays -- unsigned char* key, unsigned long* w, unsigned Nk
 * Output: None
 * Side Effect: Change the value of w
 */
void KeyExpansion(unsigned char* key, unsigned long* w, unsigned int Nk)
{
	unsigned char temp;
	unsigned int i = 0;
	while (i < Nk) {
		unsigned long word = (key[4*i]<<24) + (key[4*i + 1]<<16) + (key[4*i + 2]<<8) + key[4*i + 3];
		w[i] = word;
		i = i + 1???
	}
	i = Nk;
	while (i < 4 * (10 + 1)) {
		temp = w[i-1];
		if ( (i % 4)== 0) {
			temp = SubWord(RotWord(temp)) ^ Rcon[i/Nk];
		}
		w[i] = w[i-Nk] ^ temp;
		i = i + 1;
	}
}


/*
 * RotWord
 * Functionality: Get a 4-byte word, Convert it from [b0,b1,b2,b3] -> [b1,b2,b3,b0].
 *
 * Input: unsigned long word
 * Output: unsigned long word
 * Side Effect: None 
 */
 unsigned long RotWord(unsigned long word)
 {
	unsigned long temp = (word>>24) & 0x000000FF;
	return ((word<<8) & 0xFFFFFF00) | temp; 
 }


/*
 * SubWord
 * Functionality: Get a word, Convert it into sbox form.
 *
 * Input: unsigned long word
 * Output: substituted word
 * Side Effect: None
 */
 unsigned long SubWord(unsigned long word)
 {
	unsigned long result = 0x00000000;
	unsigned long word1 = word & 0x000000FF;
	unsigned long word2 = (word>>8) & 0x000000FF;
	unsigned long word3 = (word>>16) & 0x000000FF;
	unsigned long word4 = (word>>24) & 0x000000FF;
	unsigned long temp;
	temp = aes_sbox[(int)word1] | 0x00000000;
	result = result | temp;
	temp = (aes_sbox[(int)word2] | 0x00000000)<<8;
	result = result | temp;
	temp = (aes_sbox[(int)word3] | 0x00000000)<<16;
	result = result | temp;
	temp = (aes_sbox[(int)word4] | 0x00000000)<<24;
	result = result | temp;
	return result;

	// unsigned char* temp = (unsigned char*)&word;
	// unsigned char out[4];
	// int i = 0;
	// for (;i<4;i++){
	// 	out[i] = aes_sbox[(int)temp[i]];
	// }
	// return *((unsigned long*)out);
 }


/*
 * AddRoundKey
 * Functionality: XOR each char of state with corresponding round key.
 *
 * Input: unsigned char* state, unsigned long* w
 * Output: None
 * Side Effect: XOR each char of state
 */
 void AddRoundKey(unsigned char* state, unsigned long* w)
 {
	int i;  //row of state
	int j;  //column of state
	for (i = 0; i < 4; i = i + 1){   
		for (j=0;j<4;j = j + 1){    
			state[i*4+j] = state[i*4+j] ^ ((w[j]>>((3-i)*8)) & 0xFF);   
		}  
	}
 }
 

/* 
 * SubBytes
 * Functionality: Look up the sbox table and map .
 *
 * Input: array state
 * Output: None
 * Side Effect: map each element of state into corresponding 
 *
 */
void SubBytes(unsigned char* state)
{
	int i = 0;
	for (i = 0; i < 16; i = i + 1){
		state[i] = aes_sbox[(int)state[i]];
	}
}


/* 
 * ShiftRows
 * Functionality: S
 *
 * Input: array state
 * Output: None
 * Side Effect: map each element of state into corresponding 
 *
 */
void ShiftRows(unsigned char* state)
{
	unsigned char temp1;
	unsigned char temp2;
	unsigned char temp3;
	temp1 = state[4];
	state[4] = state[5];
	state[5] = state[6];
	state[6] = state[7]
	state[7] = temp1;

	temp1 = state[8];
	temp2 = state[9];
	state[8] = state[10];
	state[9] = state[11];
	state[10] = temp1;
	state[11] = temp2;

	temp1 = state[12];
	temp2 = state[13];
	temp3 = state[14];
	state[12] = state[15];
	state[13] = temp1;
	state[14] = temp2;
	state[15] = temp3;
}


/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
