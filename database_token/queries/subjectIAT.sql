-- name: AddSubjectEntry :execresult
INSERT INTO subjectIAT (subject, min_iat, min_refresh_iat) VALUES (?, ? ,?);

-- name: RemoveSubjectEntry :execresult
DELETE FROM subjectIAT WHERE subject = ?;

-- name: UpdateSubjectMinIAT :execresult
UPDATE subjectIAT SET min_iat = ? WHERE subject = ?;

-- name: UpdateSubjectMinRefreshIAT :execresult
UPDATE subjectIAT SET min_iat = ?, min_refresh_iat = ?  WHERE subject = ?;

-- name: GetMinIAT :one
SELECT min_iat FROM subjectIAT WHERE subject = ? LIMIT 1;

-- name: GetMinRefreshIAT :one
SELECT min_refresh_iat FROM subjectIAT WHERE subject = ? LIMIT 1;

-- name: GetMinIATRefreshIAT :one
SELECT min_iat, min_refresh_iat FROM subjectIAT WHERE subject = ? LIMIT 1;