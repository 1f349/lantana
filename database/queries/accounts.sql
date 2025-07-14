-- name: AddMasterAccount :execresult
INSERT INTO mailmaster (username, password, active) VALUES (?, ?, 'false');

-- name: RemoveMasterAccount :execresult
DELETE FROM mailmaster WHERE username = ?;

-- name: EnableMasterAccount :execresult
UPDATE mailmaster SET active = 'true' WHERE username = ?;

-- name: DisableMasterAccount :execresult
UPDATE mailmaster SET active = 'false' WHERE username = ?;

-- name: GetAllMasterAccounts :many
SELECT * FROM mailmaster;

-- name: GetAllActiveMasterAccounts :many
SELECT username, password FROM mailmaster WHERE active = 'true';

-- name: GetAllInactiveMasterAccounts :many
SELECT username, password FROM mailmaster WHERE active <> 'true';

-- name: GetMasterAccount :one
SELECT * FROM mailmaster WHERE username = ? LIMIT 1;

-- name: AddProtectedReceive :execresult
INSERT INTO receiveProtectMap (address, access, active) VALUES (?, ?, 'false');

-- name: RemoveProtectedReceive :execresult
DELETE FROM receiveProtectMap WHERE address = ?;

-- name: EnableProtectedReceive :execresult
UPDATE receiveProtectMap SET active = 'true' WHERE address = ?;

-- name: DisableProtectedReceive :execresult
UPDATE receiveProtectMap SET active = 'false' WHERE address = ?;

-- name: GetAllProtectedReceives :many
SELECT * FROM receiveProtectMap;

-- name: GetAllActiveProtectedReceives :many
SELECT address, access FROM receiveProtectMap WHERE active = 'true';

-- name: GetAllInactiveProtectedReceives :many
SELECT address, access FROM receiveProtectMap WHERE active <> 'true';

-- name: GetProtectedReceive :one
SELECT * FROM receiveProtectMap WHERE address = ? LIMIT 1;

-- name: AddAccount :execresult
INSERT INTO mailshadow (username, password, allow_pwd_chng) VALUES (?, ?, 'true');

-- name: RemoveAccount :execresult
DELETE FROM mailshadow WHERE username = ?;

-- name: EnableAccountPasswordChange :execresult
UPDATE mailshadow SET allow_pwd_chng = 'true' WHERE username = ?;

-- name: DisableAccountPasswordChange :execresult
UPDATE mailshadow SET allow_pwd_chng = 'false' WHERE username = ?;

-- name: GetAllAccounts :many
SELECT * FROM mailshadow;

-- name: GetAccount :one
SELECT * FROM mailshadow WHERE username = ? LIMIT 1;

-- name: GetAccountAllowPasswordChange :one
SELECT allow_pwd_chng FROM mailshadow WHERE username = ? LIMIT 1;

-- name: ChangePassword :execresult
UPDATE mailshadow SET password = ? WHERE username = ? AND allow_pwd_chng = 'true';

-- name: GetPassword :one
SELECT password FROM mailshadow WHERE username = ? LIMIT 1;