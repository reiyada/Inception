NAME=hello
all:
#Use the Dockerfile in this folder to build a new image named hello.
	docker build -t $(NAME) . 
	docker run --rm $(NAME)

clean:
	docker rmi $(NAME)
