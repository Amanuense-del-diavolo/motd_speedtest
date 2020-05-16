# motd_speedtest

generate in tmp a motd file with speedtest data color coded

it comes with a systemd timer and unit, the timer is setted to a 30 min timer

for make it work you have to set a pointer from /etc/motd to /tmp/motd

the "Ram_usage_motd.sh" script can be added to the .bashrc or equivalent (dependo on the shell you'r using" or can be added on the /etc/profile.d folder "as is", in the first case it will be printed every time you log with the specific user, in the second it will appear every time you change user.
It can be added to the motd_generator.sh but it will not be in real time when printed
