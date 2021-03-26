# PHP8 Xdebug3 Docker PHPStorm

A repository to explain how to configure PHP8 with Xdebug, in Docker and connecting with PHPStorm.

## How to

```shell
make docker-setup
make docker-up
make run-script
make run-website
```

Other make commands available:
```shell
  help                          Show this help
  docker-setup                  Create the network for this docker-compose setup
  docker-up                     
  docker-down                   
  docker-logs                   
  docker-shell                  
  docker-test                   
  run-php-ver                   
  run-php-reload                
  run-script                    
  run-website                   
  test                           Run all tests
  open-xdebug-port      
```

## Other information, not necessarily needed

### How to get our address

#### Mac

```shell
HOST_IP=$(ipconfig getifaddr en0)
```
If you are using a MAC, you will need to change this in `Makefile.defaults.mk:4`

#### Linux

```shell
HOST_IP=$(ifconfig docker0 | grep 'inet ' | awk '{print $2}')
```

### Linux firewall 

In linux, it might be needed to open port 9003 for xdebug to connect to PHPStorm:

```shell
# To open the port:
sudo iptables -A INPUT -p tcp -d 0/0 -s 0/0 --dport 9003 -j ACCEPT
# To make it stick through reboots:
sudo netfilter-persistent save
sudo netfilter-persistent reload
```

### How to get our user ID in the host

This is so that the guest writes files using this user ID and we don't have permissions issues editing those files in the host.

```shell
HOST_USER_ID=`id -u`
```
