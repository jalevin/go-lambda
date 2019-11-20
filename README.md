# Basic Lambda example
This repo shows a basic working examples of a pipeline for building and uploading a lambda function to AWS.
I assume you have an AWS account and have your credentials setup properly to use the aws cli. 

1. main.go - basic go code
2. main_test.go - a simple test file for "ci/cd"
3. makefile - all of our build steps

## resources:
* makefile - https://opensource.com/article/18/8/what-how-makefile
* getting value from aws cli - https://stackoverflow.com/questions/33791069/quick-way-to-get-aws-account-number-from-the-aws-cli-tools/40121084#40121084
