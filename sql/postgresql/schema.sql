
CREATE SEQUENCE itfacet_search_s
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;


CREATE TABLE itfacet_search
(
  id integer NOT NULL DEFAULT nextval(('itfacet_search_s'::text)::regclass),
  contentclass_id integer NOT NULL,
  type integer NOT NULL,
  export boolean,
  single_res character varying(50),
  multiple_res character varying(50),
  search_cols integer,
  remote_site_import_url character varying(250),
  CONSTRAINT itfacet_search_pkey PRIMARY KEY (id),
  CONSTRAINT itfacet_search_classid_unique UNIQUE (contentclass_id)
)
WITH (
  OIDS=FALSE
);

CREATE SEQUENCE itfacet_search_attribute_s
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;


CREATE TABLE itfacet_search_attribute
(
  id integer NOT NULL DEFAULT nextval(('itfacet_search_attribute_s'::text)::regclass),
  facet_search_id integer NOT NULL,
  type integer NOT NULL,
  attribute_id integer NOT NULL,
  attribute_label character varying(250) NOT NULL,
  attribute_datatype integer,
  attribute_cols integer,
  attribute_identifier character varying(250) NOT NULL,
  attribute_dependency character varying(250),
  attribute_full_link integer,
  sort_order integer,
  CONSTRAINT itfacet_search_attribute_pkey PRIMARY KEY (id),
  CONSTRAINT itfacet_search_attribute_unique UNIQUE (facet_search_id, attribute_id, type)
)
WITH (
  OIDS=FALSE
);
