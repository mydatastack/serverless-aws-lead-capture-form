STACK ?= dsleadform
BUCKET ?= cfn-artifacts-datastack-leadform

create_bucket:
	aws s3api create-bucket --bucket $(BUCKET) --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1

deploy: 
	@aws cloudformation package --template-file ./infra/app/template.yaml --output-template-file ./infra/app/output.yaml --s3-bucket $(BUCKET) --region eu-central-1
	@aws cloudformation deploy --template-file ./infra/app/output.yaml --stack-name $(STACK) --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --region eu-central-1

validate:
	@aws cloudformation validate-template --template-body file://infra/app/template.yaml
	@aws cloudformation validate-template --template-body file://infra/app/dynamodb.template.yaml
	@aws cloudformation validate-template --template-body file://infra/app/lambda.template.yaml
	@aws cloudformation validate-template --template-body file://infra/app/apig.template.yaml

