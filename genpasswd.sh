#!/bin/sh

SYMBOL_SET="A-Za-z0-9\-"
PASSWORD_LENGTH="8"

tr -dc "$SYMBOL_SET" < /dev/random | head -c "$PASSWORD_LENGTH"

echo
