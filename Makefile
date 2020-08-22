.PHONY: gogo kataribe slow-log

gogo:
	sudo systemctl stop nginx
	sudo systemctl stop torb.go
	ssh isucon-app-1 sudo systemctl stop torb.go
	ssh isucon-app-3 sudo systemctl stop mariadb.service
	sudo truncate --size 0 /var/log/nginx/access.log
	ssh isucon-app-3 sudo truncate --size 0 /var/lib/mysql/mysql-slow.log
	make -C app/webapp/go build
	ssh isucon-app-1 rm /home/isucon/isucon-practice-20200816/app/webapp/go/torb
	scp app/webapp/go/torb isucon-app-1:/home/isucon/isucon-practice-20200816/app/webapp/go/
	sleep 2
	sudo systemctl start torb.go
	ssh isucon-app-3 sudo systemctl start mariadb.service
	ssh isucon-app-1 sudo systemctl start torb.go
	sudo systemctl start nginx
	sleep 2
	./app/exec_bench.sh

kataribe:
	sudo cat /var/log/nginx/access.log | ./kataribe

slow-log:
	sudo mysqldumpslow -s at -t 10 /var/lib/mysql/mysql-slow.log

