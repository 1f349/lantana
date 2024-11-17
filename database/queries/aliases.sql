-- name: AddSenderAlias :execresult
INSERT INTO senderaliasMap (address, allowed, active) VALUES (? , ?, 'true');

-- name: RemoveSenderAlias :execresult
DELETE FROM senderaliasMap WHERE address = sqlc.arg(address) AND allowed = sqlc.arg(allowed);

-- name: GetActiveSenderAliases :many
SELECT allowed FROM senderaliasMap WHERE address = ? AND active = 'true';

-- name: GetSenderAliases :many
SELECT allowed, active FROM senderaliasMap WHERE address = ?;

-- name: GetAllSenderAliases :many
SELECT allowed, active FROM senderaliasMap;

-- name: EnableSenderAlias :execresult
UPDATE senderaliasMap SET active = 'true' WHERE sqlc.arg(address) AND allowed = sqlc.arg(allowed);

-- name: DisableSenderAlias :execresult
UPDATE senderaliasMap SET active = 'true' WHERE sqlc.arg(address) AND allowed = sqlc.arg(allowed);

-- name: AddWildcardAlias :execresult
INSERT INTO wildcardaliasMap (address, goto, active) VALUES (? , ?, 'true');

-- name: RemoveWildcardAlias :execresult
DELETE FROM wildcardaliasMap WHERE address = sqlc.arg(address);

-- name: GetAllActiveWildcardAliases :many
SELECT address, goto FROM wildcardaliasMap WHERE active = 'true';

-- name: GetAllWildcardAliases :many
SELECT * FROM wildcardaliasMap;

-- name: GetWildcardAliasRedirect :one
SELECT goto FROM wildcardaliasMap WHERE address = ? AND active = 'true' LIMIT 1;

-- name: EnableWildcardAlias :execresult
UPDATE wildcardaliasMap SET active = 'true' WHERE address = ?;

-- name: DisableWildcardAlias :execresult
UPDATE wildcardaliasMap SET active = 'true' WHERE address = ?;

-- name: ChangeWildcardAliasRedirect :execresult
UPDATE wildcardaliasMap SET goto = sqlc.arg(allowed) WHERE address = sqlc.arg(address);

-- name: AddAlias :execresult
INSERT INTO aliasMap (address, goto, active, etype) VALUES (? , ?, 'true', 'plain');

-- name: AddAliasLike :execresult
INSERT INTO aliasMap (address, goto, active, etype) VALUES (? , ?, 'true', 'like');

-- name: AddAliasRegex :execresult
INSERT INTO aliasMap (address, goto, active, etype) VALUES (? , ?, 'true', 'regex');

-- name: RemoveAlias :execresult
DELETE FROM aliasMap WHERE address = sqlc.arg(address);

-- name: GetAllActiveAliases :many
SELECT address, goto, etype FROM aliasMap WHERE active = 'true';

-- name: GetAllAliases :many
SELECT * FROM aliasMap;

-- name: GetAliasRedirect :one
SELECT goto FROM aliasMap WHERE ((address = sqlc.arg(address) AND etype = 'plain') OR (sqlc.arg(address) LIKE address AND etype = 'pattern') OR (sqlc.arg(address) RLIKE address AND etype = 'regex')) AND active = 'true' LIMIT 1;

-- name: EnableAlias :execresult
UPDATE aliasMap SET active = 'true' WHERE address = ?;

-- name: DisableAlias :execresult
UPDATE aliasMap SET active = 'true' WHERE address = ?;

-- name: ChangeAliasRedirect :execresult
UPDATE aliasMap SET goto = sqlc.arg(goto) WHERE address = sqlc.arg(address);

-- name: AddDomainAlias :execresult
INSERT INTO aliasdomainMap (domain, goto, active, etype) VALUES (? , ?, 'true', 'plain');

-- name: AddDomainAliasLike :execresult
INSERT INTO aliasdomainMap (domain, goto, active, etype) VALUES (? , ?, 'true', 'like');

-- name: AddDomainAliasRegex :execresult
INSERT INTO aliasdomainMap (domain, goto, active, etype) VALUES (? , ?, 'true', 'regex');

-- name: RemoveDomainAlias :execresult
DELETE FROM aliasdomainMap WHERE domain = sqlc.arg(domain);

-- name: GetAllActiveDomainAliases :many
SELECT domain, goto, etype FROM aliasdomainMap WHERE active = 'true';

-- name: GetAllDomainAliases :many
SELECT * FROM aliasdomainMap;

-- name: GetDomainAliasRedirect :one
SELECT goto FROM aliasdomainMap WHERE ((domain = sqlc.arg(domain) AND etype = 'plain') OR (sqlc.arg(domain) LIKE domain AND etype = 'pattern') OR (sqlc.arg(domain) RLIKE domain AND etype = 'regex')) AND active = 'true' LIMIT 1;

-- name: EnableDomainAlias :execresult
UPDATE aliasdomainMap SET active = 'true' WHERE domain = ?;

-- name: DisableDomainAlias :execresult
UPDATE aliasdomainMap SET active = 'true' WHERE domain = ?;

-- name: ChangeDomainAliasRedirect :execresult
UPDATE aliasdomainMap SET goto = sqlc.arg(goto) WHERE domain = sqlc.arg(domain);

-- name: AddUserAlias :execresult
INSERT INTO aliasuserMap (user, goto, active, etype) VALUES (? , ?, 'true', 'plain');

-- name: AddUserAliasLike :execresult
INSERT INTO aliasuserMap (user, goto, active, etype) VALUES (? , ?, 'true', 'like');

-- name: AddUserAliasRegex :execresult
INSERT INTO aliasuserMap (user, goto, active, etype) VALUES (? , ?, 'true', 'regex');

-- name: RemoveUserAlias :execresult
DELETE FROM aliasuserMap WHERE user = sqlc.arg(user);

-- name: GetAllActiveUserAliases :many
SELECT user, goto, etype FROM aliasuserMap WHERE active = 'true';

-- name: GetAllUserAliases :many
SELECT * FROM aliasuserMap;

-- name: GetUserAliasRedirect :one
SELECT goto FROM aliasuserMap WHERE ((user = sqlc.arg(user) AND etype = 'plain') OR (sqlc.arg(user) LIKE user AND etype = 'pattern') OR (sqlc.arg(user) RLIKE user AND etype = 'regex')) AND active = 'true' LIMIT 1;

-- name: EnableUserAlias :execresult
UPDATE aliasuserMap SET active = 'true' WHERE user = ?;

-- name: DisableUserAlias :execresult
UPDATE aliasuserMap SET active = 'true' WHERE user = ?;

-- name: ChangeUserAliasRedirect :execresult
UPDATE aliasuserMap SET goto = sqlc.arg(goto) WHERE user = sqlc.arg(user);
