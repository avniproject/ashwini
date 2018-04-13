CREATE ROLE ashwini
  NOINHERIT
  NOLOGIN;

GRANT ashwini TO openchs;

GRANT ALL ON ALL TABLES IN SCHEMA public TO ashwini;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO ashwini;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO ashwini;


INSERT into organisation(name, db_user, uuid, parent_organisation_id)
    SELECT 'Ashwini', 'ashwini', '336ee5bf-2dff-49d2-9663-18e341d9ec1c', id FROM organisation WHERE name = 'OpenCHS';