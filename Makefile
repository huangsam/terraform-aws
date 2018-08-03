clean:
	rm -rf .terraform
	rm -f backend.ini
	rm -f terraform.tfvars
config: clean
	cp config/template.tfvars terraform.tfvars
	cp config/template.ini backend.ini
init:
	terraform init -backend-config=backend.ini
deploy: init
	terraform apply
destroy: init
	terraform destroy
