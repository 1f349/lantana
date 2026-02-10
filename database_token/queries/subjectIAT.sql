-- name: AddSubjectEntry :execresult
INSERT INTO subjectIAT (subject, min_iat, min_refresh_iat) VALUES (?, ? ,?);

-- name: RemoveSubjectEntry :execresult
DELETE FROM subjectIAT WHERE subject = ?;

-- name: UpdateSubjectMinIAT :execresult
UPDATE subjectIAT SET min_iat = ? WHERE subject = ?;

-- name: UpdateSubjectMinRefreshIAT :execresult
UPDATE subjectIAT SET min_iat = ?, min_refresh_iat = ?  WHERE subject = ?;

-- name: GetMinSubjectIAT :one
SELECT min_iat FROM subjectIAT WHERE subject = ? LIMIT 1;

-- name: GetMinRefreshSubjectIAT :one
SELECT min_refresh_iat FROM subjectIAT WHERE subject = ? LIMIT 1;

-- name: GetMinIATRefreshSubjectIAT :one
SELECT min_iat, min_refresh_iat FROM subjectIAT WHERE subject = ? LIMIT 1;

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