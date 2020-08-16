.PHONY: gogo kataribe

gogo:
	sudo systemctl stop h2o
	sudo truncate --size 0 /var/log/h2o/access.log
	sudo systemctl start h2o
	sleep 3
	./app/exec_bench.sh
	$(MAKE) kataribe

kataribe:
	sudo cat /var/log/h2o/access.log | ./kataribe 

