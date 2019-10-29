-- CREATE DATABASE "melody"
--     WITH OWNER "postgres";

CREATE SEQUENCE "valo_common"."echeancier_id_seq"
    MINVALUE 0
    MAXVALUE 32767;

ALTER SEQUENCE "valo_common"."echeancier_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_common"."payplan_id_seq"
    MAXVALUE 2147483647;

ALTER SEQUENCE "valo_common"."payplan_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_fixe"."derogation_id_seq"
    MAXVALUE 2147483647;

ALTER SEQUENCE "valo_fixe"."derogation_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_common"."ecriture_comptable_id_seq";

ALTER SEQUENCE "valo_common"."ecriture_comptable_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_fixe"."evt_option_id_seq";

ALTER SEQUENCE "valo_fixe"."evt_option_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_fixe"."prime_volu_det_id_seq"
    MINVALUE 0
    MAXVALUE 2147483647;

ALTER SEQUENCE "valo_fixe"."prime_volu_det_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_fixe"."seuil_vomumique_montant_seq"
    MINVALUE 0
    MAXVALUE 32767;

ALTER SEQUENCE "valo_fixe"."seuil_vomumique_montant_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_fixe"."valorisation_id_seq";

ALTER SEQUENCE "valo_fixe"."valorisation_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_fixe"."evt_raccordement_id_seq";

ALTER SEQUENCE "valo_fixe"."evt_raccordement_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_mobile"."derogation_id_seq"
    MAXVALUE 2147483647;

ALTER SEQUENCE "valo_mobile"."derogation_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_mobile"."valorisation_id_seq";

ALTER SEQUENCE "valo_mobile"."valorisation_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_mobile"."evt_option_id_seq";

ALTER SEQUENCE "valo_mobile"."evt_option_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_annexe"."lot_rem_annexes_id_seq";

ALTER SEQUENCE "valo_annexe"."lot_rem_annexes_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_annexe"."rem_annexe_id_seq";

ALTER SEQUENCE "valo_annexe"."rem_annexe_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_annexe"."valorisation_id_seq";

ALTER SEQUENCE "valo_annexe"."valorisation_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_ott"."valorisation_id_seq"
    MINVALUE 0;

ALTER SEQUENCE "valo_ott"."valorisation_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_ott"."evt_option_id_seq"
    MINVALUE 0;

ALTER SEQUENCE "valo_ott"."evt_option_id_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_fixe"."batch_step_execution_seq";

ALTER SEQUENCE "valo_fixe"."batch_step_execution_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_fixe"."batch_job_execution_seq";

ALTER SEQUENCE "valo_fixe"."batch_job_execution_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_fixe"."batch_job_seq";

ALTER SEQUENCE "valo_fixe"."batch_job_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_common"."batch_step_execution_seq";

ALTER SEQUENCE "valo_common"."batch_step_execution_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_common"."batch_job_execution_seq";

ALTER SEQUENCE "valo_common"."batch_job_execution_seq" OWNER TO "postgres";

CREATE SEQUENCE "valo_common"."batch_job_seq";

ALTER SEQUENCE "valo_common"."batch_job_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "valo_common"."flyway_schema_history"
(
    "installed_rank" integer                 NOT NULL
        CONSTRAINT "flyway_schema_history_pk"
            PRIMARY KEY,
    "version"        varchar(50),
    "description"    varchar(200)            NOT NULL,
    "type"           varchar(20)             NOT NULL,
    "script"         varchar(1000)           NOT NULL,
    "checksum"       integer,
    "installed_by"   varchar(100)            NOT NULL,
    "installed_on"   timestamp DEFAULT now() NOT NULL,
    "execution_time" integer                 NOT NULL,
    "success"        boolean                 NOT NULL
);

ALTER TABLE "valo_common"."flyway_schema_history"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "flyway_schema_history_s_idx"
    ON "valo_common"."flyway_schema_history" ("success");

CREATE TABLE IF NOT EXISTS "valo_common"."code_tva"
(
    "code"    char(2) NOT NULL
        CONSTRAINT "code_tva_pk"
            PRIMARY KEY,
    "libelle" varchar(50),
    "taux"    smallint
);

ALTER TABLE "valo_common"."code_tva"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."echeancier"
(
    "code" varchar(10) NOT NULL
        CONSTRAINT "echeancier_pk_1"
            PRIMARY KEY
);

ALTER TABLE "valo_common"."echeancier"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."echeancier_detail"
(
    "id"          smallint DEFAULT nextval('valo_common.echeancier_id_seq'::regclass) NOT NULL
        CONSTRAINT "echeancier_detail_pk"
            PRIMARY KEY,
    "code"        varchar(10)                                             NOT NULL
        CONSTRAINT "echeancier_code_fkey"
            REFERENCES "valo_common"."echeancier",
    "mois"        smallint                                                NOT NULL,
    "pourcentage" smallint                                                NOT NULL,
    "libelle"     text
);

ALTER TABLE "valo_common"."echeancier_detail"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."grp_plancom"
(
    "code"    varchar(15) NOT NULL
        CONSTRAINT "grp_plancom_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_common"."grp_plancom"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."mois"
(
    "code"        char(6) NOT NULL
        CONSTRAINT "mois_pk"
            PRIMARY KEY,
    "mois_ouvert" boolean NOT NULL
);

ALTER TABLE "valo_common"."mois"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."param_melody"
(
    "code"    varchar(30) NOT NULL
        CONSTRAINT "param_melody_pk"
            PRIMARY KEY,
    "valeur"  varchar(30),
    "libelle" text
);

ALTER TABLE "valo_common"."param_melody"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."partenaire"
(
    "code"            char(10) NOT NULL
        CONSTRAINT "partenaire_pk"
            PRIMARY KEY,
    "nom"             text,
    "code_postal"     varchar(10),
    "canal"           char(2),
    "sous_canal"      char(2),
    "nom_siege"       varchar(35),
    "adresse_siege_1" varchar(60),
    "localite_siege"  varchar(30),
    "forme_juridique" varchar(60),
    "capital"         varchar(20),
    "rcs"             varchar(50),
    "info_comp"       varchar(60)
);

ALTER TABLE "valo_common"."partenaire"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."acompte"
(
    "reference"                     varchar(16) NOT NULL
        CONSTRAINT "reference_pk"
            PRIMARY KEY,
    "date_comptabilisation_acompte" date,
    "texte_entete"                  varchar(25),
    "code_paiement_partenaire"      char(10)
        CONSTRAINT "acompte_code_paiement_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_partenaire"               char(10)
        CONSTRAINT "acompte_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "libelle_poste"                 varchar(50),
    "code_mois"                     char(6)
        CONSTRAINT "acompte_code_mois_fkey"
            REFERENCES "valo_common"."mois",
    "nom_fichier_acompte"           varchar(50),
    "montant_ttc"                   numeric,
    "montant_ht"                    numeric,
    "montant_tva"                   numeric,
    "code_tva"                      char(2)
        CONSTRAINT "acompte_code_tva_fkey"
            REFERENCES "valo_common"."code_tva"
);

ALTER TABLE "valo_common"."acompte"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."param_code_tva_partenaire"
(
    "code_partenaire"  char(10)
        CONSTRAINT "code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_tva_facture" char(2)
        CONSTRAINT "code_tva_facture_fkey"
            REFERENCES "valo_common"."code_tva"
);

ALTER TABLE "valo_common"."param_code_tva_partenaire"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."pivot_payplan"
(
    "id" integer DEFAULT nextval('valo_common.payplan_id_seq'::regclass) NOT NULL
        CONSTRAINT "payplan_pk"
            PRIMARY KEY
);

ALTER TABLE "valo_common"."pivot_payplan"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."plancom"
(
    "code"    varchar(12) NOT NULL
        CONSTRAINT "plancom_pk"
            PRIMARY KEY,
    "libelle" varchar(30)
);

ALTER TABLE "valo_common"."plancom"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."lien_partenaire_plancom"
(
    "code_partenaire" char(10)    NOT NULL
        CONSTRAINT "lien_partenaire_plancom_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_plancom"    varchar(12) NOT NULL
        CONSTRAINT "lien_partenaire_plancom_code_plancom_fkey"
            REFERENCES "valo_common"."plancom",
    "date_debut"      date,
    "date_fin"        date
);

ALTER TABLE "valo_common"."lien_partenaire_plancom"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."lien_plancom_grp_plancom"
(
    "code_plancom"     varchar(12) NOT NULL
        CONSTRAINT "lien_plancom_grp_plancom_code_plancom_fkey"
            REFERENCES "valo_common"."plancom",
    "code_grp_plancom" varchar(15) NOT NULL
        CONSTRAINT "lien_plancom_grp_plancom_code_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "date_debut"       date,
    "date_fin"         date
);

ALTER TABLE "valo_common"."lien_plancom_grp_plancom"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."point_paiement"
(
    "code_partenaire"          char(10) NOT NULL
        CONSTRAINT "point_paiement_partenaire"
            REFERENCES "valo_common"."partenaire",
    "code_paiement_partenaire" char(10) NOT NULL
        CONSTRAINT "point_paiement_partenaire_paiement"
            REFERENCES "valo_common"."partenaire",
    "date_debut"               date,
    "date_fin"                 date
);

ALTER TABLE "valo_common"."point_paiement"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."ref_nature_comptable"
(
    "code"    char(8) NOT NULL
        CONSTRAINT "ref_nature_comptable_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_common"."ref_nature_comptable"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."param_code_tva_ref_comptable"
(
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "code_ref_nature_comptable"
            REFERENCES "valo_common"."ref_nature_comptable",
    "code_tva_facture"          char(2)
        CONSTRAINT "code_tva_facture_fkey"
            REFERENCES "valo_common"."code_tva",
    "code_tva_provision"        char(2)
        CONSTRAINT "code_tva_provision_fkey"
            REFERENCES "valo_common"."code_tva"
);

ALTER TABLE "valo_common"."param_code_tva_ref_comptable"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."type_rem"
(
    "code"    varchar(20) NOT NULL
        CONSTRAINT "type_rem_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_common"."type_rem"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."ordre_analytique"
(
    "code"    varchar(12) NOT NULL
        CONSTRAINT "ordre_analytique_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_common"."ordre_analytique"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."canal"
(
    "code"    varchar(20) NOT NULL
        CONSTRAINT "canal_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_common"."canal"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."param_sous_canal"
(
    "code"       char(2) NOT NULL
        CONSTRAINT "param_sous_canal_pkey"
            PRIMARY KEY,
    "libelle"    text,
    "code_canal" varchar(20)
        CONSTRAINT "param_sous_canal_code_canal_fkey"
            REFERENCES "valo_common"."canal"
);

ALTER TABLE "valo_common"."param_sous_canal"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."param_pdv_non_remunerable"
(
    "code_partenaire" char(10)
        CONSTRAINT "param_pdv_non_remunerable_code_partenaire_key"
            UNIQUE
        CONSTRAINT "param_pdv_non_remunerable_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire"
);

ALTER TABLE "valo_common"."param_pdv_non_remunerable"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."param_exclusion_point_paiement"
(
    "code_partenaire" char(10) NOT NULL
        CONSTRAINT "param_exclusion_point_paiement_pk"
            PRIMARY KEY
        CONSTRAINT "param_exclusion_point_paiement_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire"
);

COMMENT ON TABLE "valo_common"."param_exclusion_point_paiement" IS 'Partenaires à exclure lors de la génération des écritures comptables';

ALTER TABLE "valo_common"."param_exclusion_point_paiement"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."flyway_schema_history"
(
    "installed_rank" integer                 NOT NULL
        CONSTRAINT "flyway_schema_history_pk"
            PRIMARY KEY,
    "version"        varchar(50),
    "description"    varchar(200)            NOT NULL,
    "type"           varchar(20)             NOT NULL,
    "script"         varchar(1000)           NOT NULL,
    "checksum"       integer,
    "installed_by"   varchar(100)            NOT NULL,
    "installed_on"   timestamp DEFAULT now() NOT NULL,
    "execution_time" integer                 NOT NULL,
    "success"        boolean                 NOT NULL
);

ALTER TABLE "valo_fixe"."flyway_schema_history"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "flyway_schema_history_s_idx"
    ON "valo_fixe"."flyway_schema_history" ("success");

CREATE TABLE IF NOT EXISTS "valo_common"."facture"
(
    "reference"                char(16) NOT NULL
        CONSTRAINT "facture_pk"
            PRIMARY KEY,
    "date_generation"          timestamp,
    "code_paiement_partenaire" char(10),
    "montant_ttc"              numeric,
    "montant_tva"              numeric,
    "code_mois"                char(6)
        CONSTRAINT "facture_code_mois_mois_fkey"
            REFERENCES "valo_common"."mois"
);

ALTER TABLE "valo_common"."facture"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."ecriture_comptable"
(
    "id"                        bigint  DEFAULT nextval('valo_common.ecriture_comptable_id_seq'::regclass) NOT NULL
        CONSTRAINT "ecriture_comptable_pk"
            PRIMARY KEY,
    "type_ecriture"             char(3),
    "ordre_analytique"          char(12),
    "code_ref_nature_comptable" char(8),
    "montant_ttc"               numeric,
    "montant_tva"               numeric,
    "reference_facture"         char(16)
        CONSTRAINT "reference_facture_fkey"
            REFERENCES "valo_common"."facture",
    "derniere_generation"       boolean DEFAULT TRUE                                           NOT NULL
);

ALTER TABLE "valo_common"."ecriture_comptable"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."grp_option"
(
    "code"    varchar(50) NOT NULL
        CONSTRAINT "grp_option_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."grp_option"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."grp_pta"
(
    "code"    varchar(15) NOT NULL
        CONSTRAINT "grp_pta_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."grp_pta"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."grp_signup_type"
(
    "code"    varchar(20) NOT NULL
        CONSTRAINT "grp_signup_type_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."grp_signup_type"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."motif_non_raccordement"
(
    "code"    varchar(30) NOT NULL
        CONSTRAINT "motif_non_raccordement_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."motif_non_raccordement"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."option"
(
    "code"        varchar(100) NOT NULL
        CONSTRAINT "option_pk"
            PRIMARY KEY,
    "libelle"     text,
    "remunerable" boolean
);

ALTER TABLE "valo_fixe"."option"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."lien_option_grp"
(
    "code_option"     varchar(100)
        CONSTRAINT "lien_option_grp_option_fkey"
            REFERENCES "valo_fixe"."option",
    "code_grp_option" varchar(50)
        CONSTRAINT "lien_option_grp_code_grp_option"
            REFERENCES "valo_fixe"."grp_option",
    "date_debut"      date,
    "date_fin"        date
);

ALTER TABLE "valo_fixe"."lien_option_grp"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."payplan_provision_prime_volumique"
(
    "id"                                   integer DEFAULT nextval('valo_common.payplan_id_seq'::regclass) NOT NULL
        CONSTRAINT "payplan_provision_prime_volumique_pk"
            PRIMARY KEY
        CONSTRAINT "payplan_provision_prime_volumique_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "periode_reference_inf"                smallint,
    "periode_reference_sup"                smallint,
    "somme_prime_volumique_versee_periode" numeric,
    "nb_rem_offre_versee_periode"          integer,
    "euro_ligne_moyen_calcule"             numeric,
    "euro_ligne_moyen_force"               numeric,
    "code_mois"                            char(6)
        CONSTRAINT "payplan_provision_prime_volumique_code_mois_fkey"
            REFERENCES "valo_common"."mois"
);

ALTER TABLE "valo_fixe"."payplan_provision_prime_volumique"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."payplan_reprise_rembooster"
(
    "id"                        integer DEFAULT nextval('valo_common.payplan_id_seq'::regclass) NOT NULL
        CONSTRAINT "payplan_reprise_rembooster_pk"
            PRIMARY KEY
        CONSTRAINT "payplan_reprise_rembooster_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "date_debut"                date,
    "date_fin"                  date,
    "delai"                     smallint,
    "delai_unite"               char,
    "pourcentage"               smallint,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_reprise_rembooster_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."payplan_reprise_rembooster"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."payplan_reprise_remoffre"
(
    "id"                        integer DEFAULT nextval('valo_common.payplan_id_seq'::regclass) NOT NULL
        CONSTRAINT "payplan_reprise_remoffre_pk"
            PRIMARY KEY
        CONSTRAINT "payplan_reprise_remoffre_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "date_debut"                date,
    "date_fin"                  date,
    "delai"                     smallint,
    "delai_unite"               char,
    "pourcentage"               smallint,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_reprise_remoffre_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."payplan_reprise_remoffre"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."prime_volumique_code"
(
    "code"    varchar(20) NOT NULL
        CONSTRAINT "prime_volumique_code_pk_1"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."prime_volumique_code"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."pta"
(
    "code"        varchar(100) NOT NULL
        CONSTRAINT "pta_pk"
            PRIMARY KEY,
    "libelle"     text,
    "remunerable" boolean
);

ALTER TABLE "valo_fixe"."pta"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."lien_pta_grp"
(
    "code_pta"     varchar(100)
        CONSTRAINT "lien_pta_grp_code_pta_fkey"
            REFERENCES "valo_fixe"."pta",
    "code_grp_pta" varchar(15)
        CONSTRAINT "lien_pta_grp_code_grp_pta_fkey"
            REFERENCES "valo_fixe"."grp_pta",
    "date_debut"   date,
    "date_fin"     date
);

ALTER TABLE "valo_fixe"."lien_pta_grp"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."referentiel_insee"
(
    "code"    varchar(15) NOT NULL
        CONSTRAINT "referentiel_insee_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."referentiel_insee"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."code_postal"
(
    "code"       varchar(15) NOT NULL,
    "code_insee" varchar(15) NOT NULL
        CONSTRAINT "code_postal_code_insee_fkey"
            REFERENCES "valo_fixe"."referentiel_insee",
    "libelle"    text,
    CONSTRAINT "code_postal_pk"
        PRIMARY KEY ("code", "code_insee")
);

ALTER TABLE "valo_fixe"."code_postal"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."sequence_facture"
(
    "code_point_paiement" char(10) NOT NULL
        CONSTRAINT "sequence_facture_pk"
            PRIMARY KEY
        CONSTRAINT "sequence_facture_code_point_paiement_fkey"
            REFERENCES "valo_common"."partenaire",
    "sequence_provision"  bigint,
    "sequence_facture"    bigint
);

ALTER TABLE "valo_common"."sequence_facture"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."signup_type"
(
    "code"    varchar(20) NOT NULL
        CONSTRAINT "signup_type_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."signup_type"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."lien_signup_type_grp"
(
    "code_signup_type"     varchar(20)
        CONSTRAINT "lien_signup_type_code_fkey"
            REFERENCES "valo_fixe"."signup_type",
    "code_grp_signup_type" varchar(20)
        CONSTRAINT "lien_signup_type_grp_fkey"
            REFERENCES "valo_fixe"."grp_signup_type"
);

ALTER TABLE "valo_fixe"."lien_signup_type_grp"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."techno"
(
    "code"    varchar(15) NOT NULL
        CONSTRAINT "techno_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."techno"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."payplan_prime_volumique"
(
    "id"                        integer DEFAULT nextval('valo_common.payplan_id_seq'::regclass) NOT NULL
        CONSTRAINT "payplan_prime_volumique_pk"
            PRIMARY KEY
        CONSTRAINT "payplan_prime_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_grp_plancom"          varchar(15)
        CONSTRAINT "payplan_prime_volu_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "code_grp_signup_type"      varchar(20)
        CONSTRAINT "payplan_prime_volu_code_grp_signup_type_fkey"
            REFERENCES "valo_fixe"."grp_signup_type",
    "code_techno"               varchar(15)
        CONSTRAINT "payplan_prime_volu_code_techno_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_grp_pta"              varchar(15)
        CONSTRAINT "payplan_prime_volu_grp_pta_fkey"
            REFERENCES "valo_fixe"."grp_pta",
    "date_debut"                date,
    "date_fin"                  date,
    "palier"                    smallint,
    "montant"                   numeric,
    "code_techno_source"        varchar(15)
        CONSTRAINT "payplan_prime_volu_code_techno_source_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_ref_nature_comptable" char(8)
);

ALTER TABLE "valo_fixe"."payplan_prime_volumique"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."payplan_rembooster"
(
    "id"                        integer DEFAULT nextval('valo_common.payplan_id_seq'::regclass) NOT NULL
        CONSTRAINT "payplan_rembooster_pk"
            PRIMARY KEY
        CONSTRAINT "payplan_rembooster_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_grp_plancom"          varchar(15)
        CONSTRAINT "payplan_rembooster_code_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "code_techno"               varchar(15)
        CONSTRAINT "payplan_rembooster_code_techno_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_grp_pta"              varchar(15)
        CONSTRAINT "payplan_rembooster_code_grp_pta_fkey"
            REFERENCES "valo_fixe"."grp_pta",
    "date_debut"                date,
    "date_fin"                  date,
    "montant"                   numeric,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_rembooster_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."payplan_rembooster"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."payplan_remoffre"
(
    "id"                        integer DEFAULT nextval('valo_common.payplan_id_seq'::regclass) NOT NULL
        CONSTRAINT "payplan_remoffre_pk"
            PRIMARY KEY
        CONSTRAINT "payplan_remoffre_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_techno"               varchar(15)                                                     NOT NULL
        CONSTRAINT "payplan_remoffre_code_techno_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_grp_pta"              varchar(15)                                                     NOT NULL
        CONSTRAINT "payplan_remoffre_code_grp_pta_fkey"
            REFERENCES "valo_fixe"."grp_pta",
    "code_grp_plancom"          varchar(15)                                                     NOT NULL
        CONSTRAINT "payplan_remoffre_code_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "date_debut"                date,
    "date_fin"                  date,
    "montant"                   numeric,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_remoffre_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."payplan_remoffre"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."payplan_remoffre_mig"
(
    "id"                        integer DEFAULT nextval('valo_common.payplan_id_seq'::regclass) NOT NULL
        CONSTRAINT "payplan_remoffre_mig_pk"
            PRIMARY KEY
        CONSTRAINT "id_payplan_remmig_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_grp_plancom"          varchar(15)
        CONSTRAINT "payplan_remoffre_mig_code_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "code_techno_source"        varchar(15)
        CONSTRAINT "payplan_remoffre_mig_code_techno_source_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_techno"               varchar(15)
        CONSTRAINT "payplan_remoffre_mig_code_techno_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_grp_pta"              varchar(15)
        CONSTRAINT "payplan_remoffre_mig_code_grp_pta_fkey"
            REFERENCES "valo_fixe"."grp_pta",
    "date_debut"                date,
    "date_fin"                  date,
    "montant"                   numeric,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_remoffre_mig_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."payplan_remoffre_mig"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."payplan_remoption"
(
    "id"                        integer DEFAULT nextval('valo_common.payplan_id_seq'::regclass) NOT NULL
        CONSTRAINT "payplan_remoption_pk"
            PRIMARY KEY
        CONSTRAINT "payplan_remoption_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_techno"               varchar(15)                                                     NOT NULL
        CONSTRAINT "payplan_remoption_code_techno_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_grp_pta"              varchar(15)                                                     NOT NULL
        CONSTRAINT "payplan_remoption_code_grp_pta_fkey"
            REFERENCES "valo_fixe"."grp_pta",
    "code_grp_plancom"          varchar(15)                                                     NOT NULL
        CONSTRAINT "payplan_remoption_code_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "code_grp_option"           varchar(50)
        CONSTRAINT "payplan_remoption_code_grp_option_fkey"
            REFERENCES "valo_fixe"."grp_option",
    "code_echeancier"           varchar(10)
        CONSTRAINT "payplan_remoption_echeancier_code_fkey"
            REFERENCES "valo_common"."echeancier",
    "date_debut"                date,
    "date_fin"                  date,
    "montant"                   numeric,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_remoffre_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."payplan_remoption"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."payplan_remoption_mig"
(
    "id"                        integer NOT NULL
        CONSTRAINT "payplan_remoption_mig_pk"
            PRIMARY KEY
        CONSTRAINT "id_payplan_remoptionmig_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_grp_plancom"          varchar(15)
        CONSTRAINT "payplan_remoption_mig_code_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "code_techno_source"        varchar(15)
        CONSTRAINT "payplan_remoption_mig_code_techno_source_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_techno"               varchar(15)
        CONSTRAINT "payplan_remoption_mig_code_techno_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_grp_pta"              varchar(15)
        CONSTRAINT "payplan_remoption_mig_code_grp_pta_fkey"
            REFERENCES "valo_fixe"."grp_pta",
    "code_grp_option"           varchar(50)
        CONSTRAINT "payplan_remoption_mig_code_grp_option_fkey"
            REFERENCES "valo_fixe"."grp_option",
    "code_echeancier"           varchar(10)
        CONSTRAINT "payplan_remoption_mig_code_echeancier_fkey"
            REFERENCES "valo_common"."echeancier",
    "date_debut"                date,
    "date_fin"                  date,
    "montant"                   numeric,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_remoption_mig_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."payplan_remoption_mig"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."type_derogation"
(
    "code"    varchar(20) NOT NULL
        CONSTRAINT "type_derogation_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."type_derogation"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."valorisation_remoption"
(
    "id"                        bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valorisation_remoption_pk"
            PRIMARY KEY,
    "id_evt_option"             char(36),
    "code_evt_option"           varchar(50),
    "id_payplan_remoption"      integer
        CONSTRAINT "valo_remoption_id_payplan_remoption_fkey"
            REFERENCES "valo_fixe"."payplan_remoption",
    "id_echeancier"             smallint
        CONSTRAINT "valo_remoption_id_echeancier_fkey"
            REFERENCES "valo_common"."echeancier_detail",
    "code_type_rem"             varchar(20)
        CONSTRAINT "valo_remoption_code_type_rem"
            REFERENCES "valo_common"."type_rem",
    "dans_zone_de_vente"        boolean,
    "raccorde"                  boolean,
    "ordre_analytique"          char(12),
    "montant"                   real,
    "code_mois"                 char(6)
        CONSTRAINT "valo_remoption_code_mois"
            REFERENCES "valo_common"."mois",
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "valo_remoption_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."valorisation_remoption"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."zone_booster"
(
    "code_mois"  char(6)
        CONSTRAINT "zone_booster_code_mois_fkey"
            REFERENCES "valo_common"."mois",
    "code_insee" varchar(15)
        CONSTRAINT "zone_booster_code_insee_fkey"
            REFERENCES "valo_fixe"."referentiel_insee"
);

ALTER TABLE "valo_fixe"."zone_booster"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."zone_de_vente"
(
    "code"    varchar(20) NOT NULL
        CONSTRAINT "zone_de_vente_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_fixe"."zone_de_vente"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."lien_partenaire_zdv"
(
    "code_partenaire" char(10)
        CONSTRAINT "lien_partenaire_zdv_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_zdv"        varchar(20)
        CONSTRAINT "lien_partenaire_zdv_code_cluster_fkey"
            REFERENCES "valo_fixe"."zone_de_vente",
    "date_debut"      date,
    "date_fin"        date
);

ALTER TABLE "valo_fixe"."lien_partenaire_zdv"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."lien_zdv_insee"
(
    "code_zdv"   varchar(20) NOT NULL
        CONSTRAINT "lien_zdv_insee_code_zdv"
            REFERENCES "valo_fixe"."zone_de_vente",
    "code_insee" varchar(15) NOT NULL
        CONSTRAINT "lien_zdv_insee_code_ref_insee"
            REFERENCES "valo_fixe"."referentiel_insee",
    "date_debut" date,
    "date_fin"   date
);

ALTER TABLE "valo_fixe"."lien_zdv_insee"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "idx_lien_zdv_insee_code_insee_dd_df"
    ON "valo_fixe"."lien_zdv_insee" ("code_insee", "date_debut", "date_fin");

CREATE TABLE IF NOT EXISTS "valo_fixe"."prime_volumique"
(
    "id"                  smallint DEFAULT nextval('valo_fixe.prime_volu_det_id_seq'::regclass) NOT NULL
        CONSTRAINT "prime_volumique_pk"
            PRIMARY KEY,
    "code_prime_volu"     varchar(20)
        CONSTRAINT "prime_volu_code_prime_volu_fkey"
            REFERENCES "valo_fixe"."prime_volumique_code",
    "code_partenaire"     char(10)                                                    NOT NULL
        CONSTRAINT "prime_volu_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_zdv"            varchar(20)
        CONSTRAINT "prime_volu_code_zdv_fkey"
            REFERENCES "valo_fixe"."zone_de_vente",
    "date_debut_cumul"    date,
    "date_fin_cumul"      date,
    "seuil_declenchement" smallint,
    "resultat_cumul"      smallint,
    "mois_versement"      char(6)  DEFAULT '201901'::bpchar                           NOT NULL
        CONSTRAINT "prime_volu_mois_vers_fkey"
            REFERENCES "valo_common"."mois"
);

ALTER TABLE "valo_fixe"."prime_volumique"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."ciblage_valo"
(
    "id"        char(36) NOT NULL
        CONSTRAINT "ciblage_valo_pkey"
            PRIMARY KEY,
    "date_acte" timestamp
);

ALTER TABLE "valo_fixe"."ciblage_valo"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."csu"
(
    "id_siebel" char(15) NOT NULL
        CONSTRAINT "csu_pk"
            PRIMARY KEY
);

ALTER TABLE "valo_fixe"."csu"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."evenement"
(
    "id"                             char(36)    NOT NULL
        CONSTRAINT "evenement_pk"
            PRIMARY KEY,
    "signup_type"                    varchar(20) NOT NULL,
    "code_techno"                    varchar(15)
        CONSTRAINT "evenement_code_techno_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_partenaire_initialisateur" char(10)
        CONSTRAINT "evenement_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_pta"                       varchar(100)
        CONSTRAINT "evenement_code_pta_fkey"
            REFERENCES "valo_fixe"."pta",
    "date_acte"                      timestamp,
    "code_insee"                     varchar(15),
    "ref_dossier"                    varchar(30),
    "id_siebel"                      varchar(15)
        CONSTRAINT "evenement_id_siebel_fk"
            REFERENCES "valo_fixe"."csu",
    "a_cibler"                       boolean     NOT NULL,
    "code_partenaire_finalisateur"   char(10)
        CONSTRAINT "evenement_code_partenaire_finalisateur_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_techno_source"             varchar(15)
        CONSTRAINT "evenement_code_techno_source_fkey"
            REFERENCES "valo_fixe"."techno",
    "code_pta_source"                varchar(100)
        CONSTRAINT "evenement_code_pta_source_fkey"
            REFERENCES "valo_fixe"."pta"
);

ALTER TABLE "valo_fixe"."evenement"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."derogation"
(
    "id"                     integer DEFAULT nextval('valo_fixe.derogation_id_seq'::regclass) NOT NULL
        CONSTRAINT "derogation_pk"
            PRIMARY KEY,
    "code_mois"              char(6)                                                NOT NULL
        CONSTRAINT "derogation_code_mois"
            REFERENCES "valo_common"."mois",
    "code_type_derogation"   varchar(20)                                            NOT NULL
        CONSTRAINT "derogation_code_type_derogation"
            REFERENCES "valo_fixe"."type_derogation",
    "id_evt"                 char(36)
        CONSTRAINT "derogation_id_evt"
            REFERENCES "valo_fixe"."evenement",
    "id_prime_volumique"     smallint
        CONSTRAINT "derogation_id_prime_volumique"
            REFERENCES "valo_fixe"."prime_volumique",
    "impact_prime_volumique" boolean                                                NOT NULL,
    "motif_interne"          text,
    "motif_visible"          text,
    "partenaire_old"         char(10)
        CONSTRAINT "derogation_partenaire_old_code"
            REFERENCES "valo_common"."partenaire",
    "partenaire_new"         char(10)
        CONSTRAINT "derogation_partenaire_new_code"
            REFERENCES "valo_common"."partenaire",
    "ref_dossier"            varchar(30),
    "suspension_levee"       boolean,
    "demandeur"              varchar(50),
    "date_saisie"            timestamp,
    "code_insee_old"         varchar(15)
        CONSTRAINT "derogation_code_insee_old_fkey"
            REFERENCES "valo_fixe"."referentiel_insee",
    "code_insee_new"         varchar(15)
        CONSTRAINT "derogation_code_insee_new_fkey"
            REFERENCES "valo_fixe"."referentiel_insee"
);

ALTER TABLE "valo_fixe"."derogation"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "idx_evenement_part_init_date_acte"
    ON "valo_fixe"."evenement" ("code_partenaire_initialisateur", "date_acte");

CREATE TABLE IF NOT EXISTS "valo_fixe"."evenement_annulation"
(
    "id"              char(36) NOT NULL
        CONSTRAINT "new_table_pk"
            PRIMARY KEY,
    "date_annulation" timestamp,
    "id_evt_origine"  char(36)
        CONSTRAINT "id_evt_origine_fkey"
            REFERENCES "valo_fixe"."evenement"
);

COMMENT ON TABLE "valo_fixe"."evenement_annulation" IS 'Table contenant l’ensemble des événements d’annulation de commandes provenant d’eCOM';

ALTER TABLE "valo_fixe"."evenement_annulation"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."evenement_option"
(
    "id_evt"                     char(36)                                              NOT NULL
        CONSTRAINT "evt_option_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "code_option"                varchar(100)                                          NOT NULL
        CONSTRAINT "evt_option_code_option_fkey"
            REFERENCES "valo_fixe"."option",
    "id"                         bigint DEFAULT nextval('valo_fixe.evt_option_id_seq'::regclass) NOT NULL
        CONSTRAINT "evenement_option_pk"
            PRIMARY KEY,
    "date_resiliation"           timestamp,
    "id_evt_option_souscription" bigint
        CONSTRAINT "evenement_option_vers_fkey"
            REFERENCES "valo_fixe"."evenement_option"
);

ALTER TABLE "valo_fixe"."evenement_option"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "idx_evenement_option_id_evt"
    ON "valo_fixe"."evenement_option" ("id_evt");

CREATE TABLE IF NOT EXISTS "valo_fixe"."evenement_raccordement"
(
    "id_evenement"    char(36)
        CONSTRAINT "evt_racco_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "statut_racco"    char(2),
    "date"            date,
    "motif_non_racco" varchar(30),
    "id"              bigint DEFAULT nextval('valo_fixe.evt_raccordement_id_seq'::regclass) NOT NULL
        CONSTRAINT "evt_raccordement_pk"
            PRIMARY KEY
);

ALTER TABLE "valo_fixe"."evenement_raccordement"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."evenement_statut"
(
    "id"          char(36) NOT NULL
        CONSTRAINT "evenement_statut_pk"
            PRIMARY KEY,
    "statut"      varchar(10),
    "date_statut" date,
    "id_siebel"   varchar(15)
        CONSTRAINT "evenement_statut_id_siebel_fk"
            REFERENCES "valo_fixe"."csu"
);

ALTER TABLE "valo_fixe"."evenement_statut"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."information_titulaire"
(
    "id_evt"             char(36) NOT NULL
        CONSTRAINT "information_titulaire_pk"
            PRIMARY KEY
        CONSTRAINT "info_titu_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "nom_raison_sociale" varchar(50),
    "prenom"             varchar(50),
    "adresse"            varchar(50),
    "code_postal"        varchar(8),
    "ville"              varchar(50)
);

ALTER TABLE "valo_fixe"."information_titulaire"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."valorisation"
(
    "id"                        bigint      NOT NULL
        CONSTRAINT "valorisation_pk"
            PRIMARY KEY,
    "code_mois"                 char(6)     NOT NULL
        CONSTRAINT "valo_code_mois_fkey"
            REFERENCES "valo_common"."mois",
    "id_evt"                    char(36)
        CONSTRAINT "valo_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "id_payplan"                integer
        CONSTRAINT "valo_id_payplan_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_type_rem"             varchar(20) NOT NULL
        CONSTRAINT "valo_code_type_rem_fkey"
            REFERENCES "valo_common"."type_rem",
    "dans_zone_de_vente"        boolean,
    "raccorde"                  boolean,
    "ordre_analytique"          char(12),
    "montant"                   numeric,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "valo_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable",
    "id_prime_volu"             smallint
        CONSTRAINT "valo_id_prime_volu_fkey"
            REFERENCES "valo_fixe"."prime_volumique",
    "id_evt_option"             bigint
        CONSTRAINT "valo_id_evt_option_fkey"
            REFERENCES "valo_fixe"."evenement_option",
    "id_echeancier_detail"      smallint
        CONSTRAINT "valo_id_echeancier_fkey"
            REFERENCES "valo_common"."echeancier_detail",
    "statut"                    varchar(12),
    "code_point_paiement"       char(10)
        CONSTRAINT "valo_code_point_paiement_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_partenaire"           char(10)
        CONSTRAINT "valo_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_tva_facture"          char(2)
        CONSTRAINT "valo_code_tva_facture_fkey"
            REFERENCES "valo_common"."code_tva",
    "code_tva_provision"        char(2)
        CONSTRAINT "valo_code_tva_privision_fkey"
            REFERENCES "valo_common"."code_tva",
    "date_creation"             timestamp,
    "id_ecriture_comptable"     bigint
        CONSTRAINT "valo_id_ecriture_comptable_fkey"
            REFERENCES "valo_common"."ecriture_comptable",
    "id_evt_raccordement"       bigint
        CONSTRAINT "valorisation_evt_raccordement_fkey"
            REFERENCES "valo_fixe"."evenement_raccordement"
);

ALTER TABLE "valo_fixe"."valorisation"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."lien_valo_ecriture_comptable"
(
    "id_ecriture_comptable" bigint
        CONSTRAINT "id_ecriture_comptable_fkey"
            REFERENCES "valo_common"."ecriture_comptable",
    "id_valo"               bigint
        CONSTRAINT "id_valo_fkey"
            REFERENCES "valo_fixe"."valorisation"
);

ALTER TABLE "valo_fixe"."lien_valo_ecriture_comptable"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."valorisation_prime_volumique"
(
    "id"                        bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valo_prime_volu_pk"
            PRIMARY KEY,
    "id_evt"                    char(36)
        CONSTRAINT "valo_prime_volu_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "id_payplan_prime_volu"     integer
        CONSTRAINT "valo_prime_volu_id_payplan_prime_volu_fkey"
            REFERENCES "valo_fixe"."payplan_prime_volumique",
    "id_prime_volu"             smallint
        CONSTRAINT "valo_prime_volu_id_prime_volu_fkey"
            REFERENCES "valo_fixe"."prime_volumique",
    "code_type_rem"             varchar(20)
        CONSTRAINT "valo_prime_volu_code_type_rem_fkey"
            REFERENCES "valo_common"."type_rem",
    "ordre_analytique"          char(12),
    "montant"                   real,
    "code_mois"                 char(6),
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "valo_prime_volumique_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."valorisation_prime_volumique"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."valorisation_rembooster"
(
    "id"                        bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valorisation_rembooster_pk"
            PRIMARY KEY,
    "id_evt"                    char(36)
        CONSTRAINT "valo_rembooster_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "id_payplan_rembooster"     integer
        CONSTRAINT "valo_rembooster_id_payplan_remoffre_fkey"
            REFERENCES "valo_fixe"."payplan_rembooster",
    "code_type_rem"             varchar(20)
        CONSTRAINT "valo_rembooster_code_type_rem"
            REFERENCES "valo_common"."type_rem",
    "dans_zone_de_vente"        boolean,
    "raccorde"                  boolean,
    "ordre_analytique"          char(12),
    "montant"                   real,
    "code_mois"                 char(6)
        CONSTRAINT "valo_rembooster_code_mois"
            REFERENCES "valo_common"."mois",
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "valo_rembooster_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."valorisation_rembooster"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."valorisation_remoffre"
(
    "id"                        bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valorisation_remoffre_pk"
            PRIMARY KEY,
    "id_evt"                    char(36)
        CONSTRAINT "valorisation_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "id_payplan_remoffre"       integer
        CONSTRAINT "valorisation_id_payplan_remoffre_fkey"
            REFERENCES "valo_fixe"."payplan_remoffre",
    "code_type_rem"             varchar(20)
        CONSTRAINT "valorisation_code_type_rem"
            REFERENCES "valo_common"."type_rem",
    "dans_zone_de_vente"        boolean,
    "raccorde"                  boolean,
    "ordre_analytique"          char(12),
    "montant"                   real,
    "code_mois"                 char(6)
        CONSTRAINT "valorisation_code_mois"
            REFERENCES "valo_common"."mois",
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "valorisation_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."valorisation_remoffre"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."valorisation_remoffre_mig"
(
    "id"                        bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valorisation_remoffre_mig_pk"
            PRIMARY KEY,
    "id_evt"                    char(36)
        CONSTRAINT "valo_remoffre_mig_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "id_payplan_remoffre_mig"   integer
        CONSTRAINT "valo_remoffre_mig_id_payplan_remoffre_mig_fkey"
            REFERENCES "valo_fixe"."payplan_remoffre_mig",
    "code_type_rem"             varchar(20)
        CONSTRAINT "valo_remoffre_mig_code_type_rem"
            REFERENCES "valo_common"."type_rem",
    "dans_zone_de_vente"        boolean,
    "raccorde"                  boolean,
    "ordre_analytique"          char(20),
    "montant"                   real,
    "code_mois"                 char(6)
        CONSTRAINT "valo_remoffre_mig_code_mois"
            REFERENCES "valo_common"."mois",
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "valo_remoffre_mig_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."valorisation_remoffre_mig"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."valorisation_reprise_rembooster"
(
    "id"                            bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valorisation_reprise_rembooster_pk"
            PRIMARY KEY,
    "id_evt"                        char(36)
        CONSTRAINT "valo_repremboost_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "id_payplan_reprise_rembooster" integer
        CONSTRAINT "valo_repremboost_id_payplan_reprise_rembooster_fkey"
            REFERENCES "valo_fixe"."payplan_reprise_rembooster",
    "code_type_rem"                 varchar(20),
    "ordre_analytique"              char(12),
    "montant"                       real,
    "code_mois"                     char(6)
        CONSTRAINT "valo_repremboost_code_mois"
            REFERENCES "valo_common"."mois",
    "code_ref_nature_comptable"     char(8)
        CONSTRAINT "valo_remboost_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."valorisation_reprise_rembooster"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."valorisation_reprise_remoffre"
(
    "id"                          bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valorisation_reprise_remoffre_pk"
            PRIMARY KEY,
    "id_evt"                      char(36)
        CONSTRAINT "valo_id_evt_fkey"
            REFERENCES "valo_fixe"."evenement",
    "id_payplan_reprise_remoffre" integer
        CONSTRAINT "valo_id_payplan_reprise_remoffre_fkey"
            REFERENCES "valo_fixe"."payplan_reprise_remoffre",
    "code_type_rem"               varchar(20),
    "ordre_analytique"            char(12),
    "montant"                     real,
    "code_mois"                   char(6)
        CONSTRAINT "valo_code_mois"
            REFERENCES "valo_common"."mois",
    "code_ref_nature_comptable"   char(8)
        CONSTRAINT "valo_remoffre_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_fixe"."valorisation_reprise_remoffre"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."flyway_schema_history"
(
    "installed_rank" integer                 NOT NULL
        CONSTRAINT "flyway_schema_history_pk"
            PRIMARY KEY,
    "version"        varchar(50),
    "description"    varchar(200)            NOT NULL,
    "type"           varchar(20)             NOT NULL,
    "script"         varchar(1000)           NOT NULL,
    "checksum"       integer,
    "installed_by"   varchar(100)            NOT NULL,
    "installed_on"   timestamp DEFAULT now() NOT NULL,
    "execution_time" integer                 NOT NULL,
    "success"        boolean                 NOT NULL
);

ALTER TABLE "valo_mobile"."flyway_schema_history"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "flyway_schema_history_s_idx"
    ON "valo_mobile"."flyway_schema_history" ("success");

CREATE TABLE IF NOT EXISTS "valo_mobile"."pta"
(
    "code"        varchar(100) NOT NULL
        CONSTRAINT "pta_pkey"
            PRIMARY KEY,
    "libelle"     text,
    "remunerable" boolean
);

ALTER TABLE "valo_mobile"."pta"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."grp_pta"
(
    "code"    varchar(15) NOT NULL
        CONSTRAINT "grp_pta_pkey"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_mobile"."grp_pta"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."lien_pta_grp"
(
    "code_pta"     varchar(100)
        CONSTRAINT "lien_pta_grp_code_pta_fkey"
            REFERENCES "valo_mobile"."pta",
    "code_grp_pta" varchar(15)
        CONSTRAINT "lien_pta_grp_code_grp_pta_fkey"
            REFERENCES "valo_mobile"."grp_pta",
    "date_debut"   date,
    "date_fin"     date
);

ALTER TABLE "valo_mobile"."lien_pta_grp"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."payplan_remoffre"
(
    "id"                        integer     NOT NULL
        CONSTRAINT "payplan_remoffre_pkey"
            PRIMARY KEY
        CONSTRAINT "payplan_remoffre_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_grp_plancom"          varchar(15) NOT NULL
        CONSTRAINT "payplan_remoffre_code_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "code_grp_pta"              varchar(15) NOT NULL
        CONSTRAINT "payplan_remoffre_code_grp_pta_fkey"
            REFERENCES "valo_mobile"."grp_pta",
    "date_debut"                date,
    "date_fin"                  date,
    "montant"                   numeric,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_remoffre_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_mobile"."payplan_remoffre"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."option"
(
    "code"        varchar(100) NOT NULL
        CONSTRAINT "option_pk"
            PRIMARY KEY,
    "libelle"     text,
    "remunerable" boolean
);

ALTER TABLE "valo_mobile"."option"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."grp_option"
(
    "code"    varchar(100) NOT NULL
        CONSTRAINT "grp_option_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_mobile"."grp_option"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."lien_option_grp"
(
    "code_option"     varchar(50)
        CONSTRAINT "lien_option_grp_option_fkey"
            REFERENCES "valo_mobile"."option",
    "code_grp_option" varchar(50)
        CONSTRAINT "lien_option_grp_code_grp_option"
            REFERENCES "valo_mobile"."grp_option",
    "date_debut"      date,
    "date_fin"        date
);

ALTER TABLE "valo_mobile"."lien_option_grp"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."payplan_remoption"
(
    "id"                        integer     NOT NULL
        CONSTRAINT "payplan_remoption_pkey"
            PRIMARY KEY
        CONSTRAINT "payplan_remoption_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_grp_plancom"          varchar(15) NOT NULL
        CONSTRAINT "payplan_remoption_code_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "code_grp_pta"              varchar(15) NOT NULL
        CONSTRAINT "payplan_remoption_code_grp_pta_fkey"
            REFERENCES "valo_mobile"."grp_pta",
    "code_grp_option"           varchar(50)
        CONSTRAINT "payplan_remoption_code_grp_option_fkey"
            REFERENCES "valo_mobile"."grp_option",
    "code_echeancier"           varchar(10)
        CONSTRAINT "payplan_remoption_echeancier_code_fkey"
            REFERENCES "valo_common"."echeancier",
    "date_debut"                date,
    "date_fin"                  date,
    "montant"                   numeric,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_remoption_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_mobile"."payplan_remoption"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."type_derogation"
(
    "code"    varchar(20) NOT NULL
        CONSTRAINT "type_derogation_pk"
            PRIMARY KEY,
    "libelle" text
);

ALTER TABLE "valo_mobile"."type_derogation"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."sequence_facture"
(
    "code_point_paiement" char(10) NOT NULL
        CONSTRAINT "sequence_facture_pk"
            PRIMARY KEY,
    "sequence_provision"  bigint,
    "sequence_facture"    bigint
);

ALTER TABLE "valo_mobile"."sequence_facture"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."ciblage_valo"
(
    "id"        char(36) NOT NULL
        CONSTRAINT "ciblage_valo_pkey"
            PRIMARY KEY,
    "date_acte" timestamp
);

ALTER TABLE "valo_mobile"."ciblage_valo"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."csu"
(
    "id" char(8) NOT NULL
        CONSTRAINT "csu_pk"
            PRIMARY KEY
);

ALTER TABLE "valo_mobile"."csu"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."evenement"
(
    "id"                             char(36)             NOT NULL
        CONSTRAINT "evenement_pkey"
            PRIMARY KEY,
    "signup_type"                    varchar(20)          NOT NULL,
    "code_partenaire_initialisateur" char(10)
        CONSTRAINT "evenement_code_partenaire_initialisateur_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_partenaire_finalisateur"   char(10)
        CONSTRAINT "evenement_code_partenaire_finalisateur_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_pta"                       varchar(100)
        CONSTRAINT "evenement_code_pta_fkey"
            REFERENCES "valo_mobile"."pta",
    "date_acte"                      timestamp,
    "a_cibler"                       boolean DEFAULT TRUE NOT NULL,
    "order_number"                   varchar(10),
    "id_csu"                         char(8)
        CONSTRAINT "evenement_id_csu_fkey"
            REFERENCES "valo_mobile"."csu",
    "id_acte"                        char(11),
    "code_pta_source"                varchar(100)
        CONSTRAINT "evenement_code_pta_source_fkey"
            REFERENCES "valo_mobile"."pta"
);

ALTER TABLE "valo_mobile"."evenement"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."derogation"
(
    "id"                   integer DEFAULT nextval('valo_fixe.derogation_id_seq'::regclass) NOT NULL
        CONSTRAINT "derogation_pk"
            PRIMARY KEY,
    "code_mois"            char(6)                                                NOT NULL
        CONSTRAINT "derogation_code_mois"
            REFERENCES "valo_common"."mois",
    "demandeur"            varchar(50),
    "date_saisie"          timestamp,
    "code_type_derogation" varchar(20)                                            NOT NULL
        CONSTRAINT "derogation_code_type_derogation"
            REFERENCES "valo_mobile"."type_derogation",
    "id_evt"               char(36)
        CONSTRAINT "derogation_id_evt"
            REFERENCES "valo_mobile"."evenement",
    "motif_interne"        text,
    "motif_visible"        text,
    "partenaire_old"       char(10)
        CONSTRAINT "derogation_partenaire_old_code"
            REFERENCES "valo_common"."partenaire",
    "partenaire_new"       char(10)
        CONSTRAINT "derogation_partenaire_new_code"
            REFERENCES "valo_common"."partenaire",
    "ref_dossier"          varchar(30),
    "suspension_levee"     boolean
);

ALTER TABLE "valo_mobile"."derogation"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."evenement_option"
(
    "id"                      bigint DEFAULT nextval('valo_fixe.evt_option_id_seq'::regclass) NOT NULL
        CONSTRAINT "evenement_option_pk"
            PRIMARY KEY,
    "id_evt"                  char(36)
        CONSTRAINT "evt_option_id_evt_fkey"
            REFERENCES "valo_mobile"."evenement",
    "code_option"             varchar(100)
        CONSTRAINT "evt_option_code_option_fkey"
            REFERENCES "valo_mobile"."option",
    "id_produit_installe"     char(10),
    "date_resiliation"        timestamp,
    "id_evt_opt_souscription" bigint
        CONSTRAINT "evenement_option_evenement_option_fkey"
            REFERENCES "valo_mobile"."evenement_option"
);

ALTER TABLE "valo_mobile"."evenement_option"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."valorisation"
(
    "id"                        bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valorisation_pk"
            PRIMARY KEY,
    "code_mois"                 char(6)                                                 NOT NULL
        CONSTRAINT "valo_code_mois_fkey"
            REFERENCES "valo_common"."mois",
    "id_evt"                    char(36)
        CONSTRAINT "valo_id_evt_fkey"
            REFERENCES "valo_mobile"."evenement",
    "id_payplan"                integer
        CONSTRAINT "valo_id_payplan_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_type_rem"             varchar(20)                                             NOT NULL
        CONSTRAINT "valo_code_type_rem_fkey"
            REFERENCES "valo_common"."type_rem",
    "activee"                   boolean,
    "ordre_analytique"          char(12),
    "montant"                   numeric,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "valo_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable",
    "id_evt_option"             bigint
        CONSTRAINT "valo_id_evt_option_fkey"
            REFERENCES "valo_mobile"."evenement_option",
    "id_echeancier_detail"      smallint
        CONSTRAINT "echeancier_detail"
            REFERENCES "valo_common"."echeancier_detail",
    "statut"                    varchar(12),
    "code_point_paiement"       char(10)
        CONSTRAINT "valo_point_paiement_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_tva_facture"          char(2)
        CONSTRAINT "valo_code_tva_facture_fkey"
            REFERENCES "valo_common"."code_tva",
    "code_tva_provision"        char(2)
        CONSTRAINT "valo_code_tva_provision_fkey"
            REFERENCES "valo_common"."code_tva",
    "code_partenaire"           char(10)
        CONSTRAINT "valo_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "date_creation"             timestamp,
    "id_ecriture_comptable"     bigint
        CONSTRAINT "valo_id_ecriture_comptable_fkey"
            REFERENCES "valo_common"."ecriture_comptable"
);

ALTER TABLE "valo_mobile"."valorisation"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "idx_evenement_option_id_evt"
    ON "valo_mobile"."evenement_option" ("id_evt");

CREATE INDEX IF NOT EXISTS "idx_evenement_option_id_produit_installe"
    ON "valo_mobile"."evenement_option" ("id_produit_installe");

CREATE INDEX IF NOT EXISTS "idx_evenement_option_date_resiliation"
    ON "valo_mobile"."evenement_option" ("date_resiliation");

CREATE TABLE IF NOT EXISTS "valo_mobile"."information_titulaire"
(
    "id_evt"             char(36) NOT NULL
        CONSTRAINT "information_titulaire_pk"
            PRIMARY KEY
        CONSTRAINT "info_titu_id_evt_fkey"
            REFERENCES "valo_mobile"."evenement",
    "nom_raison_sociale" varchar(50),
    "prenom"             varchar(50),
    "adresse"            varchar(50),
    "code_postal"        varchar(8),
    "ville"              varchar(50)
);

ALTER TABLE "valo_mobile"."information_titulaire"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "idx_evenement_part_init_date_acte"
    ON "valo_mobile"."evenement" ("code_partenaire_initialisateur", "date_acte");

CREATE TABLE IF NOT EXISTS "valo_mobile"."evenement_activation"
(
    "id_evt"          char(36) NOT NULL
        CONSTRAINT "evenement_activation_pk"
            PRIMARY KEY
        CONSTRAINT "evenement_activation_id_evenement_fkey"
            REFERENCES "valo_mobile"."evenement",
    "id_acte"         char(11) NOT NULL,
    "id_csu"          char(8)  NOT NULL,
    "date_activation" date
);

ALTER TABLE "valo_mobile"."evenement_activation"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_mobile"."evenement_cycle_vie_csu"
(
    "id"                    char(36)    NOT NULL
        CONSTRAINT "evenement_cycle_vie_csu_pk"
            PRIMARY KEY,
    "id_acte"               char(11)    NOT NULL
        CONSTRAINT "evenement_cycle_vie_csu_id_acte_key"
            UNIQUE,
    "id_csu"                char(8)     NOT NULL
        CONSTRAINT "evenement_cycle_vie_csu_id_csu_fkey"
            REFERENCES "valo_mobile"."csu",
    "type_acte"             varchar(30) NOT NULL,
    "date_creation"         timestamp   NOT NULL,
    "date_execution_prevue" timestamp   NOT NULL,
    "motif"                 varchar(50),
    "etat_csu_source"       varchar(30),
    "etat_csu_cible"        varchar(30) NOT NULL,
    "id_acte_annulation"    char(11)
        CONSTRAINT "evenement_cycle_vie_csu_id_acte_annulation_fkey"
            REFERENCES "valo_mobile"."evenement_cycle_vie_csu" ("id_acte"),
    "date_annulation"       timestamp
);

ALTER TABLE "valo_mobile"."evenement_cycle_vie_csu"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "idx_evenement_cycle_vie_csu_id_acte"
    ON "valo_mobile"."evenement_cycle_vie_csu" ("id_acte");

CREATE TABLE IF NOT EXISTS "valo_mobile"."evenement_annulation"
(
    "id"              char(36) NOT NULL
        CONSTRAINT "evenement_annulation_pk"
            PRIMARY KEY,
    "id_evt_origine"  char(36) NOT NULL
        CONSTRAINT "evenement_annulation_id_evt_origine_fkey"
            REFERENCES "valo_mobile"."evenement",
    "date_annulation" date     NOT NULL,
    "id_acte"         char(11),
    "motif"           varchar(50)
);

ALTER TABLE "valo_mobile"."evenement_annulation"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_annexe"."flyway_schema_history"
(
    "installed_rank" integer                 NOT NULL
        CONSTRAINT "flyway_schema_history_pk"
            PRIMARY KEY,
    "version"        varchar(50),
    "description"    varchar(200)            NOT NULL,
    "type"           varchar(20)             NOT NULL,
    "script"         varchar(1000)           NOT NULL,
    "checksum"       integer,
    "installed_by"   varchar(100)            NOT NULL,
    "installed_on"   timestamp DEFAULT now() NOT NULL,
    "execution_time" integer                 NOT NULL,
    "success"        boolean                 NOT NULL
);

ALTER TABLE "valo_annexe"."flyway_schema_history"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "flyway_schema_history_s_idx"
    ON "valo_annexe"."flyway_schema_history" ("success");

CREATE TABLE IF NOT EXISTS "valo_annexe"."lot_rem_annexes"
(
    "id"          bigint DEFAULT nextval('valo_annexe.lot_rem_annexes_id_seq'::regclass) NOT NULL
        CONSTRAINT "lot_rem_annexes_pk"
            PRIMARY KEY,
    "nom_fichier" text,
    "date"        timestamp                                                  NOT NULL,
    "code_canal"  varchar(20)                                                NOT NULL
        CONSTRAINT "lot_rem_annexes_code_canal_fkey"
            REFERENCES "valo_common"."canal",
    "code_mois"   varchar(6)                                                 NOT NULL
        CONSTRAINT "lot_rem_annexes_code_mois_fkey"
            REFERENCES "valo_common"."mois"
);

ALTER TABLE "valo_annexe"."lot_rem_annexes"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_annexe"."rem_annexe"
(
    "id"                        bigint DEFAULT nextval('valo_annexe.rem_annexe_id_seq'::regclass) NOT NULL
        CONSTRAINT "rem_annexe_pk"
            PRIMARY KEY,
    "type_rem_annexe"           varchar(255),
    "code_partenaire"           varchar(10)                                           NOT NULL
        CONSTRAINT "rem_annexe_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "libelle_partenaire"        varchar(50),
    "plan_rem"                  varchar(50),
    "volume"                    varchar(255),
    "prix_unitaire"             varchar(255),
    "montant"                   numeric                                               NOT NULL,
    "ordre_analytique"          varchar(12)                                           NOT NULL
        CONSTRAINT "rem_annexe_ordre_analytique_fkey"
            REFERENCES "valo_common"."ordre_analytique",
    "code_ref_nature_comptable" varchar(8)                                            NOT NULL
        CONSTRAINT "rem_annexe_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable",
    "commentaire"               varchar(255),
    "id_lot_rem_annexes"        bigint
        CONSTRAINT "lot_rem_annexes_fkey"
            REFERENCES "valo_annexe"."lot_rem_annexes",
    "site"                      varchar(255),
    "sous_type_rem_annexe"      varchar(255)
);

ALTER TABLE "valo_annexe"."rem_annexe"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_annexe"."valorisation"
(
    "id"                        bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valorisation_pk"
            PRIMARY KEY,
    "code_mois"                 varchar(6)                                              NOT NULL
        CONSTRAINT "valo_code_mois_fkey"
            REFERENCES "valo_common"."mois",
    "montant"                   numeric                                                 NOT NULL,
    "code_tva_facture"          char(2)
        CONSTRAINT "valo_code_tva_facture_fkey"
            REFERENCES "valo_common"."code_tva",
    "code_tva_provision"        char(2)
        CONSTRAINT "valo_code_tva_provision"
            REFERENCES "valo_common"."code_tva",
    "date_creation"             timestamp,
    "code_point_paiement"       char(10)
        CONSTRAINT "valo_code_point_paiement_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_partenaire"           char(10)
        CONSTRAINT "valo_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "id_ecriture_comptable"     bigint
        CONSTRAINT "valo_id_ecriture_comptable_fkey"
            REFERENCES "valo_common"."ecriture_comptable",
    "statut"                    varchar(12),
    "code_type_rem"             varchar(20)                                             NOT NULL
        CONSTRAINT "valo_code_type_rem_fkey"
            REFERENCES "valo_common"."type_rem",
    "ordre_analytique"          varchar(12)                                             NOT NULL
        CONSTRAINT "valo_ordre_analytique_fkey"
            REFERENCES "valo_common"."ordre_analytique",
    "code_ref_nature_comptable" varchar(8)
        CONSTRAINT "valo_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable",
    "id_rem_annexe"             bigint                                                  NOT NULL
        CONSTRAINT "valo_rem_annexe_fkey"
            REFERENCES "valo_annexe"."rem_annexe"
);

ALTER TABLE "valo_annexe"."valorisation"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_ott"."flyway_schema_history"
(
    "installed_rank" integer                 NOT NULL
        CONSTRAINT "flyway_schema_history_pk"
            PRIMARY KEY,
    "version"        varchar(50),
    "description"    varchar(200)            NOT NULL,
    "type"           varchar(20)             NOT NULL,
    "script"         varchar(1000)           NOT NULL,
    "checksum"       integer,
    "installed_by"   varchar(100)            NOT NULL,
    "installed_on"   timestamp DEFAULT now() NOT NULL,
    "execution_time" integer                 NOT NULL,
    "success"        boolean                 NOT NULL
);

ALTER TABLE "valo_ott"."flyway_schema_history"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "flyway_schema_history_s_idx"
    ON "valo_ott"."flyway_schema_history" ("success");

CREATE TABLE IF NOT EXISTS "valo_ott"."ciblage_valo"
(
    "id"        char(36) NOT NULL
        CONSTRAINT "ciblage_valo_pk"
            PRIMARY KEY,
    "date_acte" timestamp
);

ALTER TABLE "valo_ott"."ciblage_valo"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_ott"."catalogue_option_ott"
(
    "code_service" varchar(30) NOT NULL,
    "code_produit" varchar(50) NOT NULL,
    "libelle"      varchar(50),
    CONSTRAINT "referentiel_ott_pk"
        PRIMARY KEY ("code_service", "code_produit")
);

ALTER TABLE "valo_ott"."catalogue_option_ott"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_ott"."evenement_option"
(
    "id"                bigint DEFAULT nextval('valo_fixe.evt_option_id_seq'::regclass) NOT NULL
        CONSTRAINT "evenement_option_pk"
            PRIMARY KEY,
    "code_service"      varchar(30)                                           NOT NULL,
    "code_produit"      varchar(50)                                           NOT NULL,
    "date_souscription" timestamp,
    "date_resiliation"  timestamp,
    CONSTRAINT "evenement_option_code_service_code_produit_fkey"
        FOREIGN KEY ("code_service", "code_produit") REFERENCES "valo_ott"."catalogue_option_ott"
);

ALTER TABLE "valo_ott"."evenement_option"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_ott"."evenement"
(
    "id"                             char(36)             NOT NULL
        CONSTRAINT "evenement_pk"
            PRIMARY KEY,
    "code_partenaire_initialisateur" char(10)
        CONSTRAINT "evenement_code_partenaire_init_fkey"
            REFERENCES "valo_common"."partenaire",
    "signup_type"                    varchar(20)          NOT NULL,
    "date_acte"                      timestamp            NOT NULL,
    "a_cibler"                       boolean DEFAULT TRUE NOT NULL,
    "id_ott"                         char(36)             NOT NULL,
    "subscription_id"                char(36)             NOT NULL,
    "email"                          varchar(255),
    "id_option_souscription"         bigint
        CONSTRAINT "evenement_option_souscription_fkey"
            REFERENCES "valo_ott"."evenement_option",
    "id_option_resiliation"          bigint
        CONSTRAINT "evenement_option_resiliation_fkey"
            REFERENCES "valo_ott"."evenement_option"
);

ALTER TABLE "valo_ott"."evenement"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_ott"."valorisation"
(
    "id"                        bigint DEFAULT nextval('valo_fixe.valorisation_id_seq'::regclass) NOT NULL
        CONSTRAINT "valorisation_pk"
            PRIMARY KEY,
    "code_mois"                 char(6)                                                 NOT NULL
        CONSTRAINT "valo_code_mois_fkey"
            REFERENCES "valo_common"."mois",
    "code_type_rem"             varchar(20)                                             NOT NULL
        CONSTRAINT "valo_code_type_rem_fkey"
            REFERENCES "valo_common"."type_rem",
    "id_evt"                    char(36)                                                NOT NULL
        CONSTRAINT "valo_id_evt_fkey"
            REFERENCES "valo_ott"."evenement",
    "id_evt_option"             bigint                                                  NOT NULL
        CONSTRAINT "valorisation_id_evt_option"
            REFERENCES "valo_ott"."evenement_option",
    "id_payplan"                integer
        CONSTRAINT "valo_id_payplan_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "id_echeancier_detail"      smallint                                                NOT NULL
        CONSTRAINT "valo_id_echeancier_detail_fkey"
            REFERENCES "valo_common"."echeancier_detail",
    "ordre_analytique"          char(12)                                                NOT NULL,
    "montant"                   numeric                                                 NOT NULL,
    "code_ref_nature_comptable" char(8)                                                 NOT NULL
        CONSTRAINT "valo_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable",
    "statut"                    varchar(12)                                             NOT NULL,
    "code_point_paiement"       char(10)
        CONSTRAINT "valo_point_paiement_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_partenaire"           char(10)                                                NOT NULL
        CONSTRAINT "valo_code_partenaire_fkey"
            REFERENCES "valo_common"."partenaire",
    "code_tva_facture"          char(2)
        CONSTRAINT "valo_code_tva_facture_fkey"
            REFERENCES "valo_common"."code_tva",
    "code_tva_provision"        char(2)
        CONSTRAINT "valo_code_tva_provision_fkey"
            REFERENCES "valo_common"."code_tva",
    "date_creation"             timestamp,
    "id_ecriture_comptable"     bigint
);

ALTER TABLE "valo_ott"."valorisation"
    OWNER TO "postgres";

CREATE INDEX IF NOT EXISTS "evenement_subscription_id_idx"
    ON "valo_ott"."evenement" ("subscription_id");

CREATE TABLE IF NOT EXISTS "valo_ott"."grp_option"
(
    "code"    varchar(100) NOT NULL
        CONSTRAINT "grp_option_pk"
            PRIMARY KEY,
    "libelle" varchar(50)
);

ALTER TABLE "valo_ott"."grp_option"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_ott"."payplan_remott"
(
    "id"                        integer     NOT NULL
        CONSTRAINT "payplan_remott_pkey"
            PRIMARY KEY
        CONSTRAINT "payplan_remott_id_fkey"
            REFERENCES "valo_common"."pivot_payplan",
    "code_grp_plancom"          varchar(15) NOT NULL
        CONSTRAINT "payplan_remott_code_grp_plancom_fkey"
            REFERENCES "valo_common"."grp_plancom",
    "code_grp_option"           varchar(50)
        CONSTRAINT "payplan_remott_code_grp_option_fkey"
            REFERENCES "valo_ott"."grp_option",
    "code_echeancier"           varchar(10)
        CONSTRAINT "payplan_remott_echeancier_code_fkey"
            REFERENCES "valo_common"."echeancier",
    "date_debut"                date,
    "date_fin"                  date,
    "montant"                   numeric     NOT NULL,
    "code_ref_nature_comptable" char(8)
        CONSTRAINT "payplan_remott_code_ref_nature_comptable_fkey"
            REFERENCES "valo_common"."ref_nature_comptable"
);

ALTER TABLE "valo_ott"."payplan_remott"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_ott"."lien_option_grp"
(
    "code_produit"    varchar(50)  NOT NULL,
    "code_service"    varchar(50)  NOT NULL,
    "code_grp_option" varchar(100) NOT NULL
        CONSTRAINT "lien_option_grp_code_grp_option_fkey"
            REFERENCES "valo_ott"."grp_option",
    "date_debut"      date         NOT NULL,
    "date_fin"        date,
    CONSTRAINT "lien_option_grp_code_service_code_produit_fkey"
        FOREIGN KEY ("code_service", "code_produit") REFERENCES "valo_ott"."catalogue_option_ott"
);

ALTER TABLE "valo_ott"."lien_option_grp"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."batch_job_instance"
(
    "job_instance_id" bigint       NOT NULL
        CONSTRAINT "batch_job_instance_pkey"
            PRIMARY KEY,
    "version"         bigint,
    "job_name"        varchar(100) NOT NULL,
    "job_key"         varchar(32)  NOT NULL,
    CONSTRAINT "job_inst_un"
        UNIQUE ("job_name", "job_key")
);

ALTER TABLE "valo_fixe"."batch_job_instance"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."batch_job_execution"
(
    "job_execution_id"           bigint    NOT NULL
        CONSTRAINT "batch_job_execution_pkey"
            PRIMARY KEY,
    "version"                    bigint,
    "job_instance_id"            bigint    NOT NULL
        CONSTRAINT "job_inst_exec_fk"
            REFERENCES "valo_fixe"."batch_job_instance",
    "create_time"                timestamp NOT NULL,
    "start_time"                 timestamp,
    "end_time"                   timestamp,
    "status"                     varchar(10),
    "exit_code"                  varchar(2500),
    "exit_message"               varchar(2500),
    "last_updated"               timestamp,
    "job_configuration_location" varchar(2500)
);

ALTER TABLE "valo_fixe"."batch_job_execution"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."batch_job_execution_params"
(
    "job_execution_id" bigint       NOT NULL
        CONSTRAINT "job_exec_params_fk"
            REFERENCES "valo_fixe"."batch_job_execution",
    "type_cd"          varchar(6)   NOT NULL,
    "key_name"         varchar(100) NOT NULL,
    "string_val"       varchar(250),
    "date_val"         timestamp,
    "long_val"         bigint,
    "double_val"       double precision,
    "identifying"      char         NOT NULL
);

ALTER TABLE "valo_fixe"."batch_job_execution_params"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."batch_step_execution"
(
    "step_execution_id"  bigint       NOT NULL
        CONSTRAINT "batch_step_execution_pkey"
            PRIMARY KEY,
    "version"            bigint       NOT NULL,
    "step_name"          varchar(100) NOT NULL,
    "job_execution_id"   bigint       NOT NULL
        CONSTRAINT "job_exec_step_fk"
            REFERENCES "valo_fixe"."batch_job_execution",
    "start_time"         timestamp    NOT NULL,
    "end_time"           timestamp,
    "status"             varchar(10),
    "commit_count"       bigint,
    "read_count"         bigint,
    "filter_count"       bigint,
    "write_count"        bigint,
    "read_skip_count"    bigint,
    "write_skip_count"   bigint,
    "process_skip_count" bigint,
    "rollback_count"     bigint,
    "exit_code"          varchar(2500),
    "exit_message"       varchar(2500),
    "last_updated"       timestamp
);

ALTER TABLE "valo_fixe"."batch_step_execution"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."batch_step_execution_context"
(
    "step_execution_id"  bigint        NOT NULL
        CONSTRAINT "batch_step_execution_context_pkey"
            PRIMARY KEY
        CONSTRAINT "step_exec_ctx_fk"
            REFERENCES "valo_fixe"."batch_step_execution",
    "short_context"      varchar(2500) NOT NULL,
    "serialized_context" text
);

ALTER TABLE "valo_fixe"."batch_step_execution_context"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_fixe"."batch_job_execution_context"
(
    "job_execution_id"   bigint        NOT NULL
        CONSTRAINT "batch_job_execution_context_pkey"
            PRIMARY KEY
        CONSTRAINT "job_exec_ctx_fk"
            REFERENCES "valo_fixe"."batch_job_execution",
    "short_context"      varchar(2500) NOT NULL,
    "serialized_context" text
);

ALTER TABLE "valo_fixe"."batch_job_execution_context"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."batch_job_instance"
(
    "job_instance_id" bigint       NOT NULL
        CONSTRAINT "batch_job_instance_pkey"
            PRIMARY KEY,
    "version"         bigint,
    "job_name"        varchar(100) NOT NULL,
    "job_key"         varchar(32)  NOT NULL,
    CONSTRAINT "job_inst_un"
        UNIQUE ("job_name", "job_key")
);

ALTER TABLE "valo_common"."batch_job_instance"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."batch_job_execution"
(
    "job_execution_id"           bigint    NOT NULL
        CONSTRAINT "batch_job_execution_pkey"
            PRIMARY KEY,
    "version"                    bigint,
    "job_instance_id"            bigint    NOT NULL
        CONSTRAINT "job_inst_exec_fk"
            REFERENCES "valo_common"."batch_job_instance",
    "create_time"                timestamp NOT NULL,
    "start_time"                 timestamp,
    "end_time"                   timestamp,
    "status"                     varchar(10),
    "exit_code"                  varchar(2500),
    "exit_message"               varchar(2500),
    "last_updated"               timestamp,
    "job_configuration_location" varchar(2500)
);

ALTER TABLE "valo_common"."batch_job_execution"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."batch_job_execution_params"
(
    "job_execution_id" bigint       NOT NULL
        CONSTRAINT "job_exec_params_fk"
            REFERENCES "valo_common"."batch_job_execution",
    "type_cd"          varchar(6)   NOT NULL,
    "key_name"         varchar(100) NOT NULL,
    "string_val"       varchar(250),
    "date_val"         timestamp,
    "long_val"         bigint,
    "double_val"       double precision,
    "identifying"      char         NOT NULL
);

ALTER TABLE "valo_common"."batch_job_execution_params"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."batch_step_execution"
(
    "step_execution_id"  bigint       NOT NULL
        CONSTRAINT "batch_step_execution_pkey"
            PRIMARY KEY,
    "version"            bigint       NOT NULL,
    "step_name"          varchar(100) NOT NULL,
    "job_execution_id"   bigint       NOT NULL
        CONSTRAINT "job_exec_step_fk"
            REFERENCES "valo_common"."batch_job_execution",
    "start_time"         timestamp    NOT NULL,
    "end_time"           timestamp,
    "status"             varchar(10),
    "commit_count"       bigint,
    "read_count"         bigint,
    "filter_count"       bigint,
    "write_count"        bigint,
    "read_skip_count"    bigint,
    "write_skip_count"   bigint,
    "process_skip_count" bigint,
    "rollback_count"     bigint,
    "exit_code"          varchar(2500),
    "exit_message"       varchar(2500),
    "last_updated"       timestamp
);

ALTER TABLE "valo_common"."batch_step_execution"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."batch_step_execution_context"
(
    "step_execution_id"  bigint        NOT NULL
        CONSTRAINT "batch_step_execution_context_pkey"
            PRIMARY KEY
        CONSTRAINT "step_exec_ctx_fk"
            REFERENCES "valo_common"."batch_step_execution",
    "short_context"      varchar(2500) NOT NULL,
    "serialized_context" text
);

ALTER TABLE "valo_common"."batch_step_execution_context"
    OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "valo_common"."batch_job_execution_context"
(
    "job_execution_id"   bigint        NOT NULL
        CONSTRAINT "batch_job_execution_context_pkey"
            PRIMARY KEY
        CONSTRAINT "job_exec_ctx_fk"
            REFERENCES "valo_common"."batch_job_execution",
    "short_context"      varchar(2500) NOT NULL,
    "serialized_context" text
);

ALTER TABLE "valo_common"."batch_job_execution_context"
    OWNER TO "postgres";