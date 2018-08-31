clean-terra:
	rm -rf .terraform
clean-config:
	rm -f backend.ini
	rm -f terraform.tfvars
	rm -f data.tf
config-us: clean-config
	cp config/us-west-1/template.data data.tf
	cp config/us-west-1/template.tfvars terraform.tfvars
	cp config/us-west-1/template.ini backend.ini
init: clean-terra
	terraform init -backend-config=backend.ini
plan:
	terraform plan
apply:
	TF_WARN_OUTPUT_ERRORS=1 terraform apply
destroy:
	TF_WARN_OUTPUT_ERRORS=1 terraform destroy
