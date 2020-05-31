# ARM Slot Machine Simulator

A CISC211 ARM program that simulates gambling through the use of randomly generated numbers.

## Requirements

- Raspberry Pi 3B+ (or higher)
- Raspberry Pi OS (Debian Buster was used for this project)

## Setup

- Install OS image onto Raspberry Pi
- Open Terminal and type the following:

```bash
cd Documents
mkdir "Slot Machine"
cd "Slot Machine"
```

- Move files "slotMachine.s" and "makefile" into the directory
- In the terminal, type:

```bash
make
```

- After the program is assembled, type the following to run the program:

```bash
./slotMachine
```

## Example Output

```
Welcome to the slot machine simulator!

You have 1000 coins. How much would you like to bet?
>2000
Your bet is invalid. Please try again.

You have 1000 coins. How much would you like to bet?
>1000
Rolling!
You rolled: 1 2 2
Two of your numbers matched! You win 1500 coins! New balance: 1500 coins
Would you like to play again? (1-Yes/0-No)
>1

You have 1500 coins. How much would you like to bet?
>1500
Rolling!
You rolled: 3 1 2
None of your numbers matched. You win nothing. New balance: 0 coins
Thank you for playing! You stopped with 0 coins.
```
