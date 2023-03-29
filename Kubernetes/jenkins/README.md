# Jenkins

Деплой одного экземпляра Jenkins 


## Добавляем namespace

    # kubectl apply 00-ns.yaml

## Создаем secret docker registry

    # docker login -u docker-user -p password ssergeya/dp_app
    # cp ~/.docker/config.json ~
    # kubectl -n jenkins create secret generic ssergeya/dp_app \
     --from-file=.dockerconfigjson=config.json \
     --type=kubernetes.io/dockerconfigjson

## Деплоим приложения

    # kubectl apply -f 01-rbac.yaml
    # kubectl apply -f 02-deployment.yaml

Смотрим логи jenkins, ищем первоначальный пароль админа.

После установки, удаляем внутренние executors и конфигурируем модуль kubernetes


