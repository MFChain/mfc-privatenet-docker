#!/usr/bin/expect -f
set dnpath [lindex $argv 0]
set wallet [lindex $argv 1]
set password [lindex $argv 2]
set timeout -1
cd $dnpath
spawn dotnet mfc-cli.dll --rpc
expect "mfc>"
send "open wallet $wallet\n"
expect "password:"
send "$password\n"
expect "mfc>"
send "start consensus\n"
expect "OnStart"
#expect "LIVEFOREVER"
interact
