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

org_name:=Ashwini
su:=postgres

create_org:
	psql -h localhost -U $(su) openchs < create_organisation.sql

## <refdata>
deploy_refdata: ## Creates reference data by POSTing it to the server
	curl -X POST $(server):$(port)/catchments -d @catchments.json -H "Content-Type: application/json" 	-H "ORGANISATION-NAME: $(org_name)"  -H "AUTH-TOKEN: $(token)"
	curl -X POST $(server):$(port)/concepts -d @concepts.json -H "Content-Type: application/json" 	-H "ORGANISATION-NAME: $(org_name)" -H "AUTH-TOKEN: $(token)"
	curl -X POST $(server):$(port)/forms -d @registrationForm.json -H "Content-Type: application/json" -H "ORGANISATION-NAME: $(org_name)" -H "AUTH-TOKEN: $(token)"
	curl -X POST $(server):$(port)/operationalModules -d @operationalModules.json -H "Content-Type: application/json" -H "ORGANISATION-NAME: $(org_name)" -H "AUTH-TOKEN: $(token)"
	curl -X DELETE $(server):$(port)/forms -d @mother/enrolmentDeletions.json -H "Content-Type: application/json" -H "ORGANISATION-NAME: $(org_name)" -H "AUTH-TOKEN: $(token)"
	curl -X PATCH $(server):$(port)/forms -d @mother/enrolmentAdditions.json -H "Content-Type: application/json" -H "ORGANISATION-NAME: $(org_name)" -H "AUTH-TOKEN: $(token)"
## </refdata>

deploy: deploy_refdata