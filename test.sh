#!/bin/bash

set -e

YELLOW="\e[33m"
GREEN="\e[32m"
ANSI_RESET="\e[0m"

print_test_case () {
    echo -e "${YELLOW}${1}${ANSI_RESET}"
}

print_success () {
    echo -e "${GREEN}${1}${ANSI_RESET}"
}

print_test_case "\nRunning smoke test..."

print_test_case "\nBuilding...\n"
./build.sh
print_success "\nBuild successful."

print_test_case "\nExecuting...\n"
(
    echo -e "1 1"; sleep 1; 
    echo -e "2 2"; sleep 1; 
    echo -e "1 2"; sleep 1; 
    echo -e "3 3"; sleep 1; 
    echo -e "1 3";
) | ./tictactoe
print_success "Execution successful.\n"

print_success "Smoke test was successful.\n"