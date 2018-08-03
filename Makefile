clean-terra:
	rm -rf .terraform
clean-config:
	rm -f backend.ini
	rm -f terraform.tfvars
config: clean-config
	cp config/template.tfvars terraform.tfvars
	cp config/template.ini backend.ini
init: clean-terra
	terraform init -backend-config=backend.ini
deploy:
	terraform apply
destroy:
	terraform destroy
