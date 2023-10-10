CREATE TABLE IF NOT EXISTS dictionary.release_forms
(
    release_form_id SMALLSERIAL  NOT NULL
        CONSTRAINT pk_releaseforms PRIMARY KEY,
    name    VARCHAR(64) NOT NULL
)