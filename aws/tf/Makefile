PLAN_FILE=fps-aws.plan
report=".html"

HOST:=$(shell hostname)
ifeq ($(HOST), C62W6K1696)
	PREFIX=gk e -p pro-services-dev --
else
	PREFIX=
endif

main: plan

plan:
	$(PREFIX) terraform plan -out $(PLAN_FILE)

apply:
	$(PREFIX) terraform apply $(PLAN_FILE)

show:
	$(PREFIX) terraform show

init:
	$(PREFIX) terraform init -upgrade

clean:
	rm $(PLAN_FILE)

cost:
	infracost breakdown --path . --show-skipped --format html > $(report)

graph:
	$(PREFIX) terraform graph | dot -Tsvg > graph.svg

.PHONY: clean plan
