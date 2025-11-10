NAME=nginx-test

all:
	docker build -t $(NAME) .
	docker run -d --name $(NAME) -p 8080:80 $(NAME)

stop:
	docker stop $(NAME) && docker rm $(NAME)

clean:
	docker rmi $(NAME)
