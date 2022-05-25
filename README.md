# jupyterlab

"NGC pytorch image + jupyterlab" env files

python 3.8 pytorch 1.9.0 cuda 11.2

# Features

- python 3.8
- pytorch 1.9.0
- jax 0.2.17
- cuda 11.2

# Requirement

* docker
* docker-compose

# Installation

## Make `.ssh` directory and put `authorized_keys`

```bash
mkdir .ssh && vi .ssh/authorized_keys
```

## Build image

```bash
docker-compose build
```

## Build container

```bash
docker-compose up -d
```

## Stop container

```bash
docker-compose stop
```

## Restart container

```bash
docker-compose start
```

## Remove container

```bash
docker-compose down
```

# Usage

## 1. Log in gpu machine -> jupyterlab container

- machine port : 8889
- jupuyterlab container port : 8888

### Example

i. write `.ssh/config`

```
Host jupyterlab
    User ${user1}
    HostName hoge
    Port 8889
    IdentityFile ~/.ssh/${ssh_user1}
    LocalForward   8888 localhost:8888
```

ii. Log in

```bash
ssh jupyterlab
```

## 2. Connect

# Note

Mounted items `..`:`/home/workdir/`  (Host:Container)

Change user `su user`

## VS Code接続方法

Remote Containerを利用する．

参考：https://code.visualstudio.com/docs/remote/containers-advanced#_developing-inside-a-container-on-a-remote-docker-host

1. VS Codeのsetting.jsonに追記

'''bash
    "docker.host":"ssh://your-remote-user@your-remote-machine-fqdn-or-ip-here"
'''

your-remote-machine-fqdn-or-ip-hereのところを.ssh/config上に記載された名前にする

* .ssh/config上にfugaというNameがある場合それを指定

'''bash
"docker.host":"ssh://user1@fuga"
'''

2. 接続

左下の`><`の部分を押して`Attach to running Container`を選択．接続したいコンテナを選ぶことでAttachが可能となる．

# Author

* tabata
