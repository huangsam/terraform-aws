clean-terra:
	rm -rf .terraform
clean-config:
	rm -f backend.ini
	rm -f terraform.tfvars
config: clean-config clean-terra
	cp config/template.tfvars terraform.tfvars
	cp config/template.ini backend.ini
init: clean-terra
	terraform init -backend-config=backend.ini
apply:
	terraform apply
destroy:
	terraform destroy
