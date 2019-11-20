all: compile compress

compile: 
	GOOS=linux GOARCH=amd64 go build -o main main.go

compress:
	zip main.zip main
