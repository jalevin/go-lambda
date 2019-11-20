all: test compile compress createRole attachRole testRole uploadLambda executeLambda

AWSLambdaName :="HelloWorld"
AWSLambdaRole :="lambda-basic-execution"

aws:
	@echo $(AWSAccount)

test:
	go test

compile: 
	GOOS=linux GOARCH=amd64 go build -o main main.go

compress:
	zip main.zip main

createRole:
	aws iam create-role --role-name ${AWSLambdaRole} --assume-role-policy-document file://lambda-trust-policy.json

attachRole:
	aws iam attach-role-policy --role-name ${AWSLambdaRole} --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

testRole:
	aws iam get-role --role-name ${AWSLambdaRole}

uploadLambda:
	aws lambda create-function --function-name ${AWSLambdaName} \
	--zip-file fileb://main.zip \
	--handler main \
	--runtime go1.x \
	--role ${shell aws iam get-role --role-name ${AWSLambdaRole} --query Role.Arn --output text}

executeLambda:
	aws lambda invoke --function-name ${AWSLambdaName} request.txt
	echo `cat request.txt`

cleanup:
	rm main
	rm main.zip
	aws lambda delete-function --function-name ${AWSLambdaName}
	aws iam detach-role-policy --role-name ${AWSLambdaRole} --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
	aws iam delete-role --role-name ${AWSLambdaRole}
	
