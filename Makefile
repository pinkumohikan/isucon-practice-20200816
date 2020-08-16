.PHONY: gogo kataribe slow-log

gogo:
	sudo systemctl stop h2o
	sudo systemctl stop mariadb
	sudo truncate --size 0 /var/log/h2o/access.log
	-sudo truncate --size 0 /var/lib/mysql/mysql-slow.log
	sudo systemctl start mariadb
	sudo systemctl start h2o
	sleep 3
	./app/exec_bench.sh

kataribe:
	sudo cat /var/log/h2o/access.log | ./kataribe 

slow-log:
	sudo mysqldumpslow -s at -t 10 /var/lib/mysql/mysql-slow.log

