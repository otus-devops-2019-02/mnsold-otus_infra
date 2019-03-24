# mnsold-otus_infra
mnsold-otus Infra repository

## ДЗ №5

### Входные данные

- Сервер bastion

  Внутренний IP-адрес 	10.166.0.3 (nic0)
  Внешний IP-адрес		35.228.115.102

- Сервер someinternalhost

  Внутренний IP-адрес 	10.166.0.4 (nic0)
  Внешний IP-адрес		Не задан

### Подключение по ssh одной командой

Исследовать способ подключения к someinternalhost в одну команду из вашего рабочего устройства:

```bash
ssh -Ai ~/.ssh/appuser appuser@35.228.115.102 -t ssh 10.166.0.4
```

### Подключение по ssh через через алиас

Предложить вариант решения для подключения из консоли при помощи команды вида ssh someinternalhost из локальной консоли рабочего устройства, чтобы подключение выполнялось по
алиасу someinternalhost 

```bash
cat > ~/.ssh/config << EOF
Host someinternalhost
	Hostname 35.228.115.102
	User appuser
	ForwardAgent yes
	IdentityFile ~/.ssh/appuser
	RequestTTY force
	RemoteCommand ssh 10.166.0.4 
EOF

ssh someinternalhost

```

### Pritunl VPN

```bash
bastion_IP = 35.228.115.102
someinternalhost_IP = 10.166.0.4
```

![1553376399250](/data/git/mnsold-otus_infra/assets/1553376399250.png)

### HTTPS Let’s Encrypt

С помощью сервисов sslip.io / xip.io и реализуйте использование валидного сертификата для панели управления VPN-сервера sslip.io xip.io Let’s Encrypt

Панель управления VPN-сервера доступна по адресу https://35-228-115-102.sslip.io/

![1553376486833](/data/git/mnsold-otus_infra/assets/1553376486833.png)

![1553376337665](/data/git/mnsold-otus_infra/assets/1553376337665.png)

