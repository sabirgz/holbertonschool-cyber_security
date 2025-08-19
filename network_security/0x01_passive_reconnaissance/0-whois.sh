#!/bin/bash
whois $1 | awk -F': ' '/^(Registrant|Admin|Tech) (Organization|State\/Province|Country|Email):/ {print $1 "," $2}'
