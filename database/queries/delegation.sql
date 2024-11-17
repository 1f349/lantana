-- name: CreateDelegateAccount :execresult
INSERT INTO delegateMap (address, owner, auth, active) VALUES (?, ? , ?, 'false');

-- name: DeleteDelegateAccount :execresult
DELETE FROM delegateMap WHERE address = ?;

-- name: UpdateDelegateAccountAuth :execresult
UPDATE delegateMap SET auth = $2 WHERE address = $1;

-- name: EnableDelegateAccount :execresult
UPDATE delegateMap SET active = 'true' WHERE address = ?;

-- name: DisableDelegateAccount :execresult
UPDATE delegateMap SET active = 'false' WHERE address = ?;

-- name: GetAllDelegateAccounts :many
SELECT * FROM delegateMap;

-- name: GetAllDelegateAccountsFor :many
SELECT * FROM delegateMap WHERE owner = ?;

-- name: GetDelegateAccountAuth :one
SELECT auth FROM delegateMap WHERE address = ? AND active = 'true' LIMIT 1;

-- name: GetDelegateAccount :one
SELECT * FROM delegateMap WHERE address = ? LIMIT 1;

-- name: AddDelegateRoute :execresult
INSERT INTO delegateRouteMap (address, delegate) VALUES (? , ?);

-- name: RemoveDelegateRoute :execresult
DELETE FROM delegateRouteMap WHERE address = ?;

-- name: GetDelegateRoute :one
SELECT delegate FROM delegateRouteMap WHERE address = ? LIMIT 1;

-- name: GetAllDelegateRoutes :many
SELECT * FROM delegateRouteMap;