all: aws test compile compress createRole attachRole testRole uploadLambda executeLambda

AWSLambdaName :="HelloWorld"
AWSLambdaRole :="lambda-basic-execution"

# verify we have a legit AWS account we can use
aws:
	@echo $(AWSAccount)

# run tests on go code
test:
	go test

# compile code for aws lambda context
compile: 
	GOOS=linux GOARCH=amd64 go build -o main main.go

# put binary in a zip file
compress:
	zip main.zip main

# create execution role for lambda
createRole:
	aws iam create-role --role-name ${AWSLambdaRole} --assume-role-policy-document file://lambda-trust-policy.json

# attach execution role
attachRole:
	aws iam attach-role-policy --role-name ${AWSLambdaRole} --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# verify the role got uploaded
testRole:
	aws iam get-role --role-name ${AWSLambdaRole}

# upload the lambda function
uploadLambda:
	aws lambda create-function --function-name ${AWSLambdaName} \
	--zip-file fileb://main.zip \
	--handler main \
	--runtime go1.x \
	--role ${shell aws iam get-role --role-name ${AWSLambdaRole} --query Role.Arn --output text}

# execute the function and output results
executeLambda:
	aws lambda invoke --function-name ${AWSLambdaName} request.txt
	echo `cat request.txt`

# delete all files
cleanup:
	rm main
	rm main.zip
	aws lambda delete-function --function-name ${AWSLambdaName}
	aws iam detach-role-policy --role-name ${AWSLambdaRole} --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
	aws iam delete-role --role-name ${AWSLambdaRole}
	
