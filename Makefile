# <makefile>
# Objects: refdata, package
# Actions: clean, build, deploy
help:
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
	    IFS=$$'#' ; \
	    help_split=($$help_line) ; \
	    help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
	    help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
	    printf "%-30s %s\n" $$help_command $$help_info ; \
	done
# </makefile>


port:= $(if $(port),$(port),8021)
server:= $(if $(server),$(server),http://localhost)
server_url:=$(server):$(port)
org_name:=Ashwini
su:=$(shell id -un)

define _curl
	curl -X $(1) $(server):$(port)/$(2) -d $(3)  \
		-H "Content-Type: application/json"  \
		-H "ORGANISATION-NAME: $(org_name)"  \
		-H "AUTH-TOKEN: $(token)"
	@echo
	@echo
endef

create_org:
	psql -h localhost -U $(su) openchs < create_organisation.sql


deploy_checklists:
	$(call _curl,POST,forms,@child/checklistForm.json)
	$(call _curl,POST,checklistDetail,@child/checklist.json)

# <refdata>
deploy_refdata: ## Creates reference data by POSTing it to the server
	$(call _curl,POST,locations,@locations.json)
	$(call _curl,POST,catchments,@catchments.json)
	$(call _curl,POST,concepts,@concepts.json)
	$(call _curl,POST,forms,@registrationForm.json)
	$(call _curl,DELETE,forms,@mother/ancDeletions.json)
	$(call _curl,DELETE,forms,@mother/deliveryDeletions.json)
	$(call _curl,DELETE,forms,@mother/enrolmentDeletions.json)
	$(call _curl,DELETE,forms,@child/birthDeletions.json)
	$(call _curl,PATCH,forms,@mother/ancAdditions.json)
	$(call _curl,PATCH,forms,@mother/deliveryAdditions.json)
	$(call _curl,PATCH,forms,@mother/enrolmentAdditions.json)
	$(call _curl,POST,operationalEncounterTypes,@operationalModules/operationalEncounterTypes.json)
	$(call _curl,POST,operationalPrograms,@operationalModules/operationalPrograms.json)
# </refdata>

# <deploy>
auth:
	$(if $(poolId),$(eval token:=$(shell node scripts/token.js $(poolId) $(clientId) $(username) $(password))))
	echo $(token)

auth_live:
	make auth poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) username=admin password=$(OPENCHS_PROD_ADMIN_USER_PASSWORD)

deploy: deploy_refdata deploy_checklists deploy_rules##
# </deploy>

# <deploy>
deploy_rules: ##
	node index.js "$(server_url)" "$(token)"

deploy_rules_live:
	make auth deploy_rules poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) username=admin password=$(OPENCHS_PROD_ADMIN_USER_PASSWORD) server=https://server.openchs.org port=443
# </deploy>

# <c_d>
create_deploy: create_org deploy ##
# </c_d>

deps:
	npm i
