#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <fstream>
#include <array>
#include <bitset>
#include "globals.h"
#include "ALU.h"

using namespace std;

int main() {
    ALU alu;

	// You should debug using various functions!
	std::srand(0);
	uint32_t operand1;
	uint32_t operand2;
	uint32_t shamt;
	uint32_t aluop;
	uint32_t alu_result;
	uint32_t alu_result_ref;


	// I'm providing 100 reference tests!
	ifstream fin_op1_ref;
	ifstream fin_op2_ref;
	ifstream fin_shamt_ref;
	ifstream fin_funct_ref;
	ifstream fin_result_ref;
	fin_op1_ref.open("operand1.ref");
	fin_op2_ref.open("operand2.ref");
	fin_shamt_ref.open("shamt.ref");
	fin_funct_ref.open("funct.ref");
	fin_result_ref.open("alu_result.ref");

	int PASSED = 0;
	int FAILED = 0;
	for (int cycle = 0; cycle < 100; cycle++) {
		fin_op1_ref >> operand1;
		fin_op2_ref >> operand2;
		fin_shamt_ref >> shamt;
		fin_funct_ref >> aluop;
		fin_result_ref >> alu_result_ref;

		alu.compute(operand1, operand2, shamt, aluop, &alu_result);
		
		if (alu_result == alu_result_ref)
			PASSED += 1;
		else
			FAILED += 1;
			
	}
	cout << "PASSED: " << PASSED << ", FAILED: " << FAILED << endl;


	// Make a custom testbench using our cpp simulator!
	ofstream fout_op1;
	ofstream fout_op2;
	ofstream fout_shamt;
	ofstream fout_funct;
	ofstream fout_result;
	fout_op1.open("operand1.mem");
	fout_op2.open("operand2.mem");
	fout_shamt.open("shamt.mem");
	fout_funct.open("funct.mem");
	fout_result.open("alu_result.mem");


	// This is the provided example, but you can try out different cases (if you want)
	for (int cycle = 0; cycle < 1000; cycle++) {
		operand1 = ((rand() << 1) + rand());
		operand2 = ((rand() << 1) + rand());
		shamt = rand() % 32;
		aluop = rand() % 14;

		alu.compute(operand1, operand2, shamt, aluop, &alu_result);
		
		// Write down the file! (to use as testbench!)
		fout_op1 << std::setw(8) << std::setfill('0') << std::hex << operand1 << endl;
		fout_op2 << std::setw(8) << std::setfill('0') << std::hex << operand2 << endl;
		fout_shamt << std::bitset<5>(shamt) <<endl;
		fout_funct << std::bitset<4>(aluop) <<endl;
		fout_result << std::setw(8) << std::setfill('0') << std::hex << alu_result << endl;
	}

    return 0;
}

