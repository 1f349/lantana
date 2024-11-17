CREATE TABLE IF NOT EXISTS domainMap (
    domain varchar(253) NOT NULL PRIMARY KEY,
    active ENUM('false', 'true') NOT NULL
);

CREATE TABLE IF NOT EXISTS mailmaster (
    username varchar(254) NOT NULL PRIMARY KEY,
    password varchar(256) NOT NULL,
    active ENUM('false', 'true') NOT NULL
);

CREATE TABLE IF NOT EXISTS mailbox (
    username varchar(254) NOT NULL PRIMARY KEY,
    maildir varchar(513) NOT NULL,
    quota bigint NOT NULL,
    active ENUM('false', 'disabled', 'true') NOT NULL
);

CREATE TABLE IF NOT EXISTS mailshadow (
    username varchar(254) NOT NULL PRIMARY KEY,
    password varchar(256) NOT NULL,
    allow_pwd_chng ENUM('false', 'true') NOT NULL,
    FOREIGN KEY (username) REFERENCES mailbox(username) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS aliasMap (
    address varchar(254) NOT NULL PRIMARY KEY,
    goto varchar(254) NOT NULL,
    active ENUM('false', 'true') NOT NULL,
    etype ENUM('plain', 'pattern', 'regex') NOT NULL,
    FOREIGN KEY (goto) REFERENCES mailbox(username) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS senderaliasMap (
    address varchar(254) NOT NULL,
    allowed varchar(254) NOT NULL,
    active ENUM('false', 'true') NOT NULL,
    PRIMARY KEY (address, allowed),
    FOREIGN KEY (allowed) REFERENCES mailbox(username) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS aliasdomainMap (
    domain varchar(253) NOT NULL PRIMARY KEY,
    goto varchar(253) NOT NULL,
    active ENUM('false', 'true', 'catch_all') NOT NULL,
    etype ENUM('plain', 'pattern', 'regex') NOT NULL
);

CREATE TABLE IF NOT EXISTS aliasuserMap (
    user varchar(253) NOT NULL PRIMARY KEY,
    goto varchar(253) NOT NULL,
    active ENUM('false', 'true', 'catch_all') NOT NULL,
    etype ENUM('plain', 'pattern', 'regex') NOT NULL
);

CREATE TABLE IF NOT EXISTS wildcardaliasMap (
    address varchar(253) NOT NULL PRIMARY KEY,
    goto varchar(253) NOT NULL,
    active ENUM('false', 'true') NOT NULL
);

CREATE TABLE IF NOT EXISTS receiveBlockReports (
    address varchar(254) NOT NULL,
    reporter varchar(254) NOT NULL,
    report text NOT NULL,
    PRIMARY KEY (address, reporter),
    FOREIGN KEY (reporter) REFERENCES mailbox(username) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS receiveBlockMap (
    address varchar(254) NOT NULL PRIMARY KEY,
    access varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS receiveProtectMap (
    address varchar(254) NOT NULL PRIMARY KEY,
    access varchar(128) NOT NULL,
    active ENUM('false', 'true') NOT NULL
);

CREATE TABLE IF NOT EXISTS smtpIngestMap (
    address varchar(254) NOT NULL PRIMARY KEY,
    start varchar(254)
);

CREATE TABLE IF NOT EXISTS delegateMap (
    address varchar(254) NOT NULL PRIMARY KEY,
    owner varchar(254) NOT NULL,
    auth text NOT NULL,
    active ENUM('false', 'true') NOT NULL,
    FOREIGN KEY (owner) REFERENCES mailbox(username) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS delegateRouteMap (
    address varchar(254) NOT NULL,
    delegate varchar(254) NOT NULL,
    PRIMARY KEY (address, delegate),
    FOREIGN KEY (delegate) REFERENCES delegateMap(address) ON UPDATE CASCADE ON DELETE CASCADE
);