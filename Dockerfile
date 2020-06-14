# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mbouzaie <mbouzaie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/06/09 01:59:58 by mbouzaie          #+#    #+#              #
#    Updated: 2020/06/14 16:23:46 by mbouzaie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster-slim

RUN apt-get -y update && apt-get -y install nginx \
					default-mysql-server \
					php7.3 php7.3-fpm php7.3-mysql \
					wordpress \
					wget
COPY ./srcs/init_container.sh ./
COPY ./srcs/monblog-nginx.conf ./tmp/
COPY ./srcs/wp-config.php ./tmp/
COPY ./srcs/config.inc.php ./tmp/

ENTRYPOINT ["bash", "init_container.sh"]

