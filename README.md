# docker-php

### How to run

	docker run -d --restart always \
	  -p 127.0.0.1:9000:9000 \
	  -v /etc/localtime:/etc/localtime:ro \
	  -v /data/wwwroot:/data/wwwroot \
	  --name php tonysamaaaa/php

#### or

	curl -L "https://raw.githubusercontent.com/TonySamaaaa/docker-php/master/php/php.ini" \
	  -o /data/docker/php/php.ini
	docker run -d --restart always \
	  -p 127.0.0.1:9000:9000 \
	  -v /etc/localtime:/etc/localtime:ro \
	  -v /data/docker/php/php.ini:/usr/local/etc/php/php.ini:ro \
	  -v /data/wwwroot:/data/wwwroot \
	  --name php tonysamaaaa/php