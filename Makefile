# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rjeong <rjeong@student.42seoul.kr>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/07/19 14:46:01 by rjeong            #+#    #+#              #
#    Updated: 2024/07/19 16:54:37 by rjeong           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all: up

up:
	docker-compose -f srcs/docker-compose.yml up --build

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker-compose -f srcs/docker-compose.yml down -v

re: clean
	make up

debug:
	COMPOSE_HTTP_TIMEOUT=200 DEBUG=1 docker-compose -f srcs/docker-compose.yml up --build

.PHONY: all up down clean re debug
