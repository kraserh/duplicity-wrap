#!/bin/bash

BIN=/usr/local/bin
ETC=/usr/local/etc

# Перевірка користувача root
if [ ! `whoami` = root ]; then
	echo "Цей скрипт повинен бути запущений з правами root." 1>&2
	#exit 1
fi

umask 0002
cd `dirname $0`
case $1 in
	install)
		echo УВАГА! Якщо вже існують налаштування в каталогі\
			$ETC/backup/, то вони не будуть перезаписані.
		cp duplicity-cloud $BIN
		cp duplicity-flash $BIN
		cp duplicity-local $BIN
		cp duplicity-wrap $BIN
		mkdir $ETC/backup 2>/dev/null
		cp -nr etc/* $ETC/backup
		echo -e "#!/bin/sh\n\n$BIN/duplicity-local"\
			> /etc/cron.daily/backup
		chmod a+x /etc/cron.daily/backup
		echo -e "#!/bin/sh\n\n$BIN/duplicity-cloud"\
			> /etc/cron.weekly/backup
		chmod a+x /etc/cron.weekly/backup
		;;
	uninstall)
		echo УВАГА! Каталог налаштувань $ETC/backup/ не видаляється.\
			Для його видалення введіть rm -r $ETC/backup
		rm $BIN/duplicity-cloud
		rm $BIN/duplicity-flash
		rm $BIN/duplicity-local
		rm $BIN/duplicity-wrap
		# rm -r $ETC/backup
		rm /etc/cron.daily/backup
		rm /etc/cron.weekly/backup
		;;
	*)
		echo Вкажіть параметр install чи uninstall.
		;;
esac
