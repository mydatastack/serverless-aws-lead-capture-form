STACK ?= leadform-datastack
BUCKET ?= cfn-artifacts-leadform

create_bucket:
	aws s3api create-bucket --bucket $(BUCKET) --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1

deploy: 
	@aws cloudformation package --template-file ./infra/app/template.yaml --output-template-file ./infra/app/output.yaml --s3-bucket $(BUCKET) --region eu-central-1
	@aws cloudformation deploy --template-file ./infra/app/output.yaml --stack-name $(STACK) --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --region eu-central-1
