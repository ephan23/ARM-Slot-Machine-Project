slotMachine: 	slotMachine.o
		g++ -nostartfiles -o slotMachine slotMachine.o

slotMachine.o:	slotMachine.s
		as -o slotMachine.o slotMachine.s

clean:
		rm *.o slotMachine
