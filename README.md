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

## ДЗ №6

```bash
testapp_IP = 35.228.59.69
testapp_port = 9292
```



## gcloud CMD

- создание ВМ с опцией startup-script

https://cloud.google.com/compute/docs/startupscript

```bash
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=cloud-testapp/startup.sh
```

- создание ВМ с опцией startup-script-url

(не стал заливать скрипт в Google Storage, аля startup-script-url=gs://bucket/startup.sh, т.к. наиболее интерено как раз из гита брать последние версии скрипов)

```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://raw.githubusercontent.com/otus-devops-2019-02/mnsold-otus_infra/cloud-testapp/cloud-testapp/startup.sh
```

- создание правила firewall

https://cloud.google.com/sdk/gcloud/reference/compute/firewall-rules/create

```bash
gcloud compute firewall-rules create default-puma-server \
	--direction=IN \
	--rules=tcp:9292 \
	--source-ranges=0.0.0.0/0 \
	--action=ALLOW \
	--priority=1000 \
	--target-tags=puma-server \
	--network=default
```

# ДЗ №8



## Задание со *

- Добавьте в веб интерфейсе ssh ключ пользователю appuser_web в метаданные проекта. Выполните terraform
  apply и проверьте результат Какие проблемы вы обнаружили? 

При добавлении ssh-keys в интерфесе GCP и применени конфигурации `terraform apply`,  все доабвленные ssh ключи удаляются. Об этом прямо говорится в документации terraform в resorce `google_compute_project_metadata` https://www.terraform.io/docs/providers/google/r/compute_project_metadata.html#project , цитата:

> **Note:**  This resource manages all project-level metadata including project-level ssh keys.
> Keys unset in config but set on the server will be removed. If you want to manage only single key/value pairs within the project metadata rather than the entire set, then use [google_compute_project_metadata_item](https://www.terraform.io/docs/providers/google/r/compute_project_metadata_item.html).

- Добавьте в код еще один terraform ресурс для нового инстанса приложения, например reddit-app2, добавьте его в
  балансировщик ... Какие проблемы вы видите в такой конфигурации приложения?

Дублирование кода, сложность поддержки, т.к. править придется во всех местах. Лучше использовать параметр conut при создании ресурса инстанса.

