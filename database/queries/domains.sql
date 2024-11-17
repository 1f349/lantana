-- name: AddDomain :execresult
INSERT INTO domainMap (domain, active) VALUES (?, 'false');

-- name: RemoveDomain :execresult
DELETE FROM domainMap WHERE domain = ?;

-- name: EnableDomain :execresult
UPDATE domainMap SET active = 'true' WHERE domain = ?;

-- name: DisableDomain :execresult
UPDATE domainMap SET active = 'false' WHERE domain = ?;

-- name: GetAllDomains :many
SELECT * FROM domainMap;

-- name: GetAllActiveDomains :many
SELECT domain FROM domainMap WHERE active = 'true';

-- name: GetAllInactiveDomains :many
SELECT domain FROM domainMap WHERE active <> 'true';

-- name: GetDomain :one
SELECT * FROM domainMap WHERE domain = ? LIMIT 1;

-- name: AddSMTPSendRoute :execresult
INSERT INTO smtpIngestMap (address, start) VALUES (?, ?);

-- name: AddSMTPSendRouteDelegated :execresult
INSERT INTO smtpIngestMap (address, start) VALUES (?, NULL);

-- name: RemoveSMTPSendRoute :execresult
DELETE FROM smtpIngestMap WHERE address = ?;

-- name: GetSMTPSendRoute :one
SELECT start FROM smtpIngestMap WHERE address = ? LIMIT 1;

-- name: GetAllSMTPSendRoutes :many
SELECT * FROM smtpIngestMap;

-- name: GetAllSMTPSendRoutesDelegated :many
SELECT * FROM smtpIngestMap WHERE start IS NULL;

-- name: GetAllSMTPSendRoutesNonDelegated :many
SELECT * FROM smtpIngestMap WHERE start IS NOT NULL;

