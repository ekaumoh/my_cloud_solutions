.PHONY: fmt validate

fmt:
	cd terraform && terraform fmt -recursive

validate:
	cd terraform && terraform init -backend=false && terraform validate
