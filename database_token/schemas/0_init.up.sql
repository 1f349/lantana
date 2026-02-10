CREATE TABLE IF NOT EXISTS subjectIAT (
    subject varchar(2048) NOT NULL PRIMARY KEY,
    min_iat bigint NOT NULL,
    min_refresh_iat bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS jtiIAT (
    jti varchar(2048) NOT NULL PRIMARY KEY,
    min_iat bigint NOT NULL,
    min_refresh_iat bigint NOT NULL
);