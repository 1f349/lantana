-- name: AddSenderAlias :execresult
INSERT INTO senderaliasMap (address, allowed, active) VALUES (? , ?, 'true');

-- name: RemoveSenderAlias :execresult
DELETE FROM senderaliasMap WHERE address = $1 AND allowed = $2;

-- name: GetActiveSenderAliases :many
SELECT allowed FROM senderaliasMap WHERE address = ? AND active = 'true';

-- name: GetSenderAliases :many
SELECT allowed, active FROM senderaliasMap WHERE address = ?;

-- name: GetAllSenderAliases :many
SELECT allowed, active FROM senderaliasMap;

-- name: EnableSenderAlias :execresult
UPDATE senderaliasMap SET active = 'true' WHERE address = $1 AND allowed = $2;

-- name: DisableSenderAlias :execresult
UPDATE senderaliasMap SET active = 'true' WHERE address = $1 AND allowed = $2;

-- name: AddWildcardAlias :execresult
INSERT INTO wildcardaliasMap (address, goto, active) VALUES (? , ?, 'true');

-- name: RemoveWildcardAlias :execresult
DELETE FROM wildcardaliasMap WHERE address = $1;

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
UPDATE wildcardaliasMap SET goto = $2 WHERE address = $1;

-- name: AddAlias :execresult
INSERT INTO aliasMap (address, goto, active, etype) VALUES (? , ?, 'true', 'plain');

-- name: AddAliasLike :execresult
INSERT INTO aliasMap (address, goto, active, etype) VALUES (? , ?, 'true', 'like');

-- name: AddAliasRegex :execresult
INSERT INTO aliasMap (address, goto, active, etype) VALUES (? , ?, 'true', 'regex');

-- name: RemoveAlias :execresult
DELETE FROM aliasMap WHERE address = $1;

-- name: GetAllActiveAliases :many
SELECT address, goto, etype FROM aliasMap WHERE active = 'true';

-- name: GetAllAliases :many
SELECT * FROM aliasMap;

-- name: GetAliasRedirect :one
SELECT goto FROM aliasMap WHERE ((address = ? AND etype = 'plain') OR (? LIKE address AND etype = 'pattern') OR (? REGEXP address AND etype = 'regex')) AND active = 'true' LIMIT 1;

-- name: EnableAlias :execresult
UPDATE aliasMap SET active = 'true' WHERE address = ?;

-- name: DisableAlias :execresult
UPDATE aliasMap SET active = 'true' WHERE address = ?;

-- name: ChangeAliasRedirect :execresult
UPDATE aliasMap SET goto = $2 WHERE address = $1;

-- name: AddDomainAlias :execresult
INSERT INTO aliasdomainMap (domain, goto, active, etype) VALUES (? , ?, 'true', 'plain');

-- name: AddDomainAliasLike :execresult
INSERT INTO aliasdomainMap (domain, goto, active, etype) VALUES (? , ?, 'true', 'like');

-- name: AddDomainAliasRegex :execresult
INSERT INTO aliasdomainMap (domain, goto, active, etype) VALUES (? , ?, 'true', 'regex');

-- name: RemoveDomainAlias :execresult
DELETE FROM aliasdomainMap WHERE domain = $1;

-- name: GetAllActiveDomainAliases :many
SELECT domain, goto, etype FROM aliasdomainMap WHERE active = 'true';

-- name: GetAllDomainAliases :many
SELECT * FROM aliasdomainMap;

-- name: GetDomainAliasRedirect :one
SELECT goto FROM aliasdomainMap WHERE ((domain = ? AND etype = 'plain') OR (? LIKE domain AND etype = 'pattern') OR (? REGEXP domain AND etype = 'regex')) AND active = 'true' LIMIT 1;

-- name: EnableDomainAlias :execresult
UPDATE aliasdomainMap SET active = 'true' WHERE domain = ?;

-- name: DisableDomainAlias :execresult
UPDATE aliasdomainMap SET active = 'true' WHERE domain = ?;

-- name: ChangeDomainAliasRedirect :execresult
UPDATE aliasdomainMap SET goto = $2 WHERE domain = $1;

-- name: AddUserAlias :execresult
INSERT INTO aliasuserMap (user, goto, active, etype) VALUES (? , ?, 'true', 'plain');

-- name: AddUserAliasLike :execresult
INSERT INTO aliasuserMap (user, goto, active, etype) VALUES (? , ?, 'true', 'like');

-- name: AddUserAliasRegex :execresult
INSERT INTO aliasuserMap (user, goto, active, etype) VALUES (? , ?, 'true', 'regex');

-- name: RemoveUserAlias :execresult
DELETE FROM aliasuserMap WHERE user = $1;

-- name: GetAllActiveUserAliases :many
SELECT user, goto, etype FROM aliasuserMap WHERE active = 'true';

-- name: GetAllUserAliases :many
SELECT * FROM aliasuserMap;

-- name: GetUserAliasRedirect :one
SELECT goto FROM aliasuserMap WHERE ((user = ? AND etype = 'plain') OR (? LIKE user AND etype = 'pattern') OR (? REGEXP user AND etype = 'regex')) AND active = 'true' LIMIT 1;

-- name: EnableUserAlias :execresult
UPDATE aliasuserMap SET active = 'true' WHERE user = ?;

-- name: DisableUserAlias :execresult
UPDATE aliasuserMap SET active = 'true' WHERE user = ?;

-- name: ChangeUserAliasRedirect :execresult
UPDATE aliasuserMap SET goto = $2 WHERE user = $1;
