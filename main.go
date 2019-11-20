package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-lambda-go/lambda"
)

func hello() string {
	return "Lambda!"
}

func HandleRequest(ctx context.Context) (string, error) {
	return fmt.Sprintf(hello()), nil
}

func main() {
	lambda.Start(HandleRequest)
}
