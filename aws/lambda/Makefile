version := $(shell awk -F= '/^lambda_version/{print $$2}' ../tf/terraform.auto.tfvars | tr -d '" ')
bucket := $(shell cd ../tf && make bucket)

HOST:=$(shell hostname)
ifeq ($(HOST), C62W6K1696)
	PREFIX=gk e -p pro-services-dev --
else
	PREFIX=
endif

function_name=first-party-set
bundle=lambda-$(function_name)-$(version).zip
region=us-east-1

lambda: $(bundle)

js=./dist/app.js
ts=./src/fps.ts

%.js: $(ts) tsconfig.json
	npm run build


%.zip: $(js)
	rm -f $@
	cd dist && zip -Xr ../$@ . -x *.LICENSE.txt

#%.zip: src node_modules
#	zip -qr $(bundle) src node_modules/
#	@echo "files list:"
#	@unzip -t $(bundle) |  grep -v node_modules

node_modules: package.json
	npm ci

upload: .$(bundle)-uploaded
	$(PREFIX) aws --region $(region)s3 cp $(bundle) s3://$(bucket)
	touch $@

.%-uploaded: $(bundle)
	$(PREFIX) aws --region $(region) s3 cp $< s3://$(bucket)
	touch $@

.%-released: .%-uploaded
	$(PREFIX) aws --region $(region) lambda update-function-code --function-name $(function_name) --s3-bucket $(bucket) --s3-key $(bundle) --publish 1>/dev/null
	touch $@

release: .$(bundle)-released

logs:
	$(PREFIX) aws --region $(region) logs tail --follow /aws/lambda/$(function_name)


clean:
	rm $(bundle)
	rm -rf dist
	rm -f .*-uploaded
	rm -f .*-released

.PHONY: clean logs

