-- name: AddJTIEntry :execresult
INSERT INTO jtiIAT (jti, min_iat, min_refresh_iat) VALUES (?, ? ,?);

-- name: RemoveJTIEntry :execresult
DELETE FROM jtiIAT WHERE jti = ?;

-- name: UpdateJTIMinIAT :execresult
UPDATE jtiIAT SET min_iat = ? WHERE jti = ?;

-- name: UpdateJTIMinRefreshIAT :execresult
UPDATE jtiIAT SET min_iat = ?, min_refresh_iat = ?  WHERE jti = ?;

-- name: GetMinJTIIAT :one
SELECT min_iat FROM jtiIAT WHERE jti = ? LIMIT 1;

-- name: GetMinRefreshJTIIAT :one
SELECT min_refresh_iat FROM jtiIAT WHERE jti = ? LIMIT 1;

-- name: GetMinIATRefreshJTIIAT :one
SELECT min_iat, min_refresh_iat FROM jtiIAT WHERE jti = ? LIMIT 1;