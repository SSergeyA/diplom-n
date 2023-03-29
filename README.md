## Sokolov Sergey
# Дипломный практикум в Yandex.Cloud
<details><summary> Задание</summary>  
  
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
- Следует использовать последнюю стабильную версию [Terraform](https://www.terraform.io/).

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: [Terraform Cloud](https://app.terraform.io/)  
   б. Альтернативный вариант: S3 bucket в созданном ЯО аккаунте
3. Настройте [workspaces](https://www.terraform.io/docs/language/state/workspaces.html)  
   а. Рекомендуемый вариант: создайте два workspace: *stage* и *prod*. В случае выбора этого варианта все последующие шаги должны учитывать факт существования нескольких workspace.  
   б. Альтернативный вариант: используйте один workspace, назвав его *stage*. Пожалуйста, не используйте workspace, создаваемый Terraform-ом по-умолчанию (*default*).
4. Создайте VPC с подсетями в разных зонах доступности.
5. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
6. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать региональный мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистр с собранным docker image. В качестве регистра может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Рекомендуемый способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте в кластер [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры.

Альтернативный вариант:
1. Для организации конфигурации можно использовать [helm charts](https://helm.sh/)

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/) либо [gitlab ci](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистр, а также деплой соответствующего Docker образа в кластер Kubernetes.

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)

---
## Как правильно задавать вопросы дипломному руководителю?

Что поможет решить большинство частых проблем:

1. Попробовать найти ответ сначала самостоятельно в интернете или в 
  материалах курса и ДЗ и только после этого спрашивать у дипломного 
  руководителя. Скилл поиска ответов пригодится вам в профессиональной 
  деятельности.
2. Если вопросов больше одного, то присылайте их в виде нумерованного 
  списка. Так дипломному руководителю будет проще отвечать на каждый из 
  них.
3. При необходимости прикрепите к вопросу скриншоты и стрелочкой 
  покажите, где не получается.

Что может стать источником проблем:

1. Вопросы вида «Ничего не работает. Не запускается. Всё сломалось». 
  Дипломный руководитель не сможет ответить на такой вопрос без 
  дополнительных уточнений. Цените своё время и время других.
2. Откладывание выполнения курсового проекта на последний момент.
3. Ожидание моментального ответа на свой вопрос. Дипломные руководители работающие разработчики, которые занимаются, кроме преподавания, 
  своими проектами. Их время ограничено, поэтому постарайтесь задавать правильные вопросы, чтобы получать быстрые ответы :)  
</details>

## Необходимые ссылки для сдачи задания.

Репозиторий с конфигурационными [файлами Terraform.](https://github.com/SSergeyA/diplom-n/tree/main/terraform)  
Репозиторий с [Dockerfile](https://github.com/SSergeyA/dp_app/blob/main/Dockerfile) тестового приложения и ссылка на собранный [docker image.](https://hub.docker.com/r/ssergeya/dp_app/tags)  
Репозиторий с [конфигурацией Kubernetes кластера.](https://github.com/SSergeyA/diplom-n/tree/main/Kubernetes)  
[Ссылка на тестовое приложение](http://130.193.38.198:30033/) и [веб интерфейс Grafana](http://130.193.38.198:30003) (admin/netology) с данными доступа.  
[Jenkins.](http://130.193.38.198:32000) (admin/netology)  
    

## Этапы выполнения:
### Создание облачной инфраструктуры
1. Создал сервисный аккаунт и назначил ему необходимые [права](https://cloud.yandex.ru/docs/iam/concepts/access-control/roles).
 ![image](https://user-images.githubusercontent.com/93119897/225690778-659600e3-cc69-4eec-86d7-73e26971bd48.png)   
 
 Создал и добавил [авторизованный ключ](https://cloud.yandex.ru/docs/cli/operations/authentication/service-account) сервисного аккаунта в профиль CLI.
![image](https://user-images.githubusercontent.com/93119897/225693442-977cd46f-21eb-47aa-9b0c-6a4f1856c2b7.png)  

2. В  [Terraform Cloud](https://app.terraform.io/app/SSergeyA/workspaces/stage) создал workspace *stage*.  

![image](https://user-images.githubusercontent.com/93119897/228467028-a2cdfcfe-dd1a-4852-b4d0-74ffe82af75c.png)
![image](https://user-images.githubusercontent.com/93119897/228473129-7df3bdb7-758d-44bf-be67-e59483344629.png)

3. Создал VPC с подсетями в разных зонах доступности. Убедился, что  команды `terraform destroy` и `terraform apply` выполняются без дополнительных ручных действий.  

![image](https://user-images.githubusercontent.com/93119897/228467743-29c0a2cd-d805-401a-a2fe-1c6f1b6a8bb9.png)
![image](https://user-images.githubusercontent.com/93119897/228467785-0022ac3b-93ba-420c-b291-859ff8791228.png)


#### Ожидаемые результаты:

Terraform сконфигурирован и создана инфраструктура посредством Terraform без дополнительных ручных действий. [Манифесты Terraform](https://github.com/SSergeyA/diplom-n/tree/main/terraform)  

### Создание Kubernetes кластера

1. При помощи Terraform подготовил 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера.  

![image](https://user-images.githubusercontent.com/93119897/228468627-622cd797-f839-4c13-acdf-679f46b6e66a.png)
![image](https://user-images.githubusercontent.com/93119897/228468744-8e8bf8a4-61fc-451b-b1d5-19d27576c80c.png)
![image](https://user-images.githubusercontent.com/93119897/228468553-dfe93528-d7ac-491d-b0ce-7d20c1fbc29c.png)

2. Подготовил свои конфигурации Kubespray.  Указал конфигурацию кластера в hosts.yaml для билдера. Для доступа к кластеру извне добавил параметр
`supplementary_addresses_in_ssl_keys:` в файл k8s-cluster.yml.  

![image](https://user-images.githubusercontent.com/93119897/228469277-7833dfd8-e46a-47f9-a7d7-d3fa065b29f2.png)
![image](https://user-images.githubusercontent.com/93119897/228470191-4f26f986-4e2b-4910-9264-1370772cad66.png)  

3. Задеплоил Kubernetes на подготовленные ранее инстансы.  

![image](https://user-images.githubusercontent.com/93119897/228470492-6859a195-1892-40cc-bc5a-76fad96d087e.png)
![image](https://user-images.githubusercontent.com/93119897/228470591-0b582a25-ad11-43d3-9093-8ba6fdc509a7.png)
![image](https://user-images.githubusercontent.com/93119897/228470740-d37f89f8-c121-483a-9a57-c94aae2903fd.png)  

4. Скопировал конфиг и создал контекст на своей машине. Проверил команду `kubectl get pods --all-namespaces` .

![image](https://user-images.githubusercontent.com/93119897/228471132-cc6179b7-7261-46b4-b787-0ac859e4278d.png)


  
#### Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле [`~/.kube/config`](https://github.com/SSergeyA/diplom-n/blob/main/Kubernetes/config)  находятся данные для доступа к кластеру. 
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.
### Создание тестового приложения

1. Создал отдельный [git репозиторий](https://github.com/SSergeyA/dp_app/) с простым nginx конфигом, который отдает статические данные.  
2. Подготовил  [Dockerfile](https://github.com/SSergeyA/dp_app/blob/main/Dockerfile) для создания образа приложения.  

![image](https://user-images.githubusercontent.com/93119897/228477958-8403596a-91f1-40b2-8401-41b3d71235c7.png)
![image](https://user-images.githubusercontent.com/93119897/228478013-bd2a1907-dd63-4407-9313-8dda0cf053df.png)
![image](https://user-images.githubusercontent.com/93119897/228478129-be12ef9a-59ab-4114-b3c2-5433cd20b615.png)

#### Ожидаемый результат:

1. Git репозиторий с тестовым приложением и [Dockerfile](https://github.com/SSergeyA/dp_app/blob/main/Dockerfile).
2. Регистр с собранным docker image.  [DockerHub](https://hub.docker.com/r/ssergeya/dp_app/tags)

### Подготовка cистемы мониторинга и деплой приложения

1. Задеплоил в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter). Воспользовался пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus)
Склонировал к себе репозиторий. В файле `grafana-service.yaml` настроил  nodePort для доступа извне и в `grafana-networkPolicy.yaml` - настроил ingress  

![image](https://user-images.githubusercontent.com/93119897/228479672-b573dfdb-c901-4ecb-81f0-2119bf415014.png)
![image](https://user-images.githubusercontent.com/93119897/228480988-2905c1d8-65c0-4c4e-929a-79552ea78e13.png)
![image](https://user-images.githubusercontent.com/93119897/228481433-e7ac1788-3e9e-4842-8f56-693887c2963b.png)
![image](https://user-images.githubusercontent.com/93119897/228484321-981dcbce-78f0-4672-9bd3-1c435cf90f46.png)
![image](https://user-images.githubusercontent.com/93119897/228494875-8414829b-7a87-4775-b885-1f6b681290f6.png)

2. Задеплоил тестовое приложение [nginx](https://www.nginx.com/) сервер отдающий статическую страницу [index.html](https://github.com/SSergeyA/dp_app/blob/main/index.html). Для организации конфигурации использовал [helm charts](https://github.com/SSergeyA/dp_app/tree/main/dp_app_helm)  

![image](https://user-images.githubusercontent.com/93119897/228486631-196935fb-ef8f-49ec-a54c-fa476a49d500.png)
![image](https://user-images.githubusercontent.com/93119897/228486697-50561e6c-69fe-43cc-a723-ce6ead9d408a.png)

#### Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки [Kubernetes](https://github.com/SSergeyA/diplom-n/tree/main/Kubernetes).
2. Http доступ к [web интерфейсу grafana](http://130.193.38.198:30003) (admin/netology).
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к [тестовому приложению](http://130.193.38.198:30033/) .

### Установка и настройка CI/CD

В качестве CI/CD выбрал Jenkins. 

Общая идея - чтобы не использовать дополнительные ресурсы, решил развернуть один экземпляр Jenkins в  Kubernetes кластере. Далее он при запуске job, при помощи модуля Kubernetes, будет запускать отдельный pod 'inbound-agent', в котором будет происходить процесс сборки. По окончании - pod удалится.

Деплой приложения происходит по следующей схеме(описанной в [pipeline.jenkinsfile](https://github.com/SSergeyA/dp_app/blob/main/pipeline.jenkinsfile)):
  - в поде агента Jenkins запускаются 2 контейнера, с образами kaniko (с примонтированным секретом для доступа к DockerHub) и helm-cli
  - задается переменная окружения TAG_NAME со значением равным тегу коммита
  - в зависимости от тега, kaniko собирает образ приложения: если есть тег, то происходит сборка и отправка с соответствующим label в регистр, а также деплой в контейнере helm-cli соответствующего Docker образа в кластер Kubernetes; если тега нет, то образу присваивается номер сборки и  он отправляется в регистр.
   
1. Деплой Jenkins производится с использованием [манифестов Kubernetes](https://github.com/SSergeyA/diplom-n/tree/main/Kubernetes/jenkins).  
В манифестах: создается неймпейс, задаются лимиты накладываемы на поды; создается сервис аккаунт jenkins-account и роль( ClusterRole для доступа к API  Kubernetes за пределами своего нейспейса), чтобы создавать приложения внутри Kubernetes; создается StatefulSet (поскольку Jenkins сохраняет состояние) и сервисы.  
 
![image](https://user-images.githubusercontent.com/93119897/228502909-5b0bc0de-e4b1-4bfc-b2d4-057fc69bc8e0.png)

2. Создаем секрет для подключения к DockerHub для того, чтобы потом его пробросить в под, для подключения к DockerHub.
'''
docker login -u docker-user -p password ssergeya/dp_app
cp ~/.docker/config.json ~
kubectl -n jenkins create secret generic sergey-local \
--from-file=.dockerconfigjson=config.json \
--type=kubernetes.io/dockerconfigjson
'''
3. В логах пода Jenkins находим пароль для первоначальной конфигурации.  

![image](https://user-images.githubusercontent.com/93119897/228522168-d8e8ca95-33a6-4b20-96d4-9db65c2ca44d.png)  

4. В конфигурации Jenkins удаляем встроенные executors и настраиваем плагин Kubernetes.  

![image](https://user-images.githubusercontent.com/93119897/228523670-26eed341-252e-4e60-9a53-af84625e4907.png)
![image](https://user-images.githubusercontent.com/93119897/228523715-b92ece6c-eddf-401f-891a-b915579300d1.png)
![image](https://user-images.githubusercontent.com/93119897/228523746-171b457e-534f-4ee2-a944-bc6591091566.png)

5. Устанавливаем GitHub Integration и создаем pipeline job.   

![image](https://user-images.githubusercontent.com/93119897/228533511-455ebd8a-e7cf-4076-8478-5b3ba7c40968.png)
![image](https://user-images.githubusercontent.com/93119897/228533652-cfce6545-b583-48ab-a2ea-145e40739f02.png)
![image](https://user-images.githubusercontent.com/93119897/228533537-31f6c9ba-a096-4867-b7a4-b017a351b759.png)
![image](https://user-images.githubusercontent.com/93119897/228533743-6725fbac-4fad-4147-85f7-b46e3657f83a.png)

6. В GitHub создаем Webhook для сборки приложения по коммиту.  

![image](https://user-images.githubusercontent.com/93119897/228533428-8637cfd2-b6d8-416d-8838-2945f465547a.png)

#### Ожидаемый результат:

##### 1. Интерфейс ci/cd сервиса доступен по http . [Jenkins](http://130.193.38.198:32000) (admin/netology)
##### 2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.  

 Создаю коммит без тега и отправляю его в репозиторий.   
 
![image](https://user-images.githubusercontent.com/93119897/228536764-e976bcaf-3c70-4f9a-8cce-2b4c8966cf6f.png)

Запускается job.  

![image](https://user-images.githubusercontent.com/93119897/228536972-a899f5bc-3e19-41f5-b4cf-5a7686dc5b11.png)  

Создается образ.  

![image](https://user-images.githubusercontent.com/93119897/228537143-0f1e39fe-7ed1-4aa9-940b-c45370dccbfc.png) 

##### 3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистр, а также деплой соответствующего Docker образа в кластер Kubernetes.  

Создаю коммит с тегом и отправляю его в репозиторий.  

![image](https://user-images.githubusercontent.com/93119897/228537781-e17ebe87-3c68-459c-abb2-03aabeffdd52.png)  

Запускается job.  

![image](https://user-images.githubusercontent.com/93119897/228537894-e379e3fa-215b-4f28-bde3-a0f1bc2f40a2.png)  

Создается образ с тегом и деплоится.  

![image](https://user-images.githubusercontent.com/93119897/228538030-b4e41544-38bb-4db7-8df1-2f20c6c91a57.png)  

Работает новая версия приложения.  

![image](https://user-images.githubusercontent.com/93119897/228538181-2854fa57-426c-4aa8-ac44-53e2ed95862e.png)


