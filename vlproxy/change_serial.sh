#! /usr/bin/expect -f

lassign $argv SERIAL_NUMBER

set timeout 20
debug 0
spawn ./VLProxyc -p
expect "Enter password:"
send "Admin\r"
expect "Enter number of item you wish to change or 0 to exit:"
send "2\r"
expect "Enter serial numbers separated by commas:"
send "$SERIAL_NUMBER\r"
expect "Enter number of item you wish to change or 0 to exit:"
send "0\r"
