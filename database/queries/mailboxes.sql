-- name: AddMailbox :execresult
INSERT INTO mailbox (username, maildir, quota, active) VALUES (?, ?, ?, 'false');

-- name: RemoveMailbox :execresult
DELETE FROM mailbox WHERE username = ?;

-- name: EnableMailbox :execresult
UPDATE mailbox SET active = 'true' WHERE username = ?;

-- name: DisableMailbox :execresult
UPDATE mailbox SET active = 'disabled' WHERE username = ?;

-- name: DeactivateMailbox :execresult
UPDATE mailbox SET active = 'false' WHERE username = ?;

-- name: GetAllMailboxes :many
SELECT * FROM mailbox;

-- name: GetAllEnabledMailboxes :many
SELECT username, maildir, quota FROM mailbox WHERE active = 'true';

-- name: GetAllActiveMailboxes :many
SELECT username, maildir, quota FROM mailbox WHERE active = 'true' OR active = 'disabled';

-- name: GetAllInactiveMailboxes :many
SELECT username, maildir, quota FROM mailbox WHERE active <> 'true';

-- name: ChangeMailboxMaildir :execresult
UPDATE mailbox SET maildir = sqlc.arg(maildir) WHERE username = sqlc.arg(username);

-- name: ChangeMailboxQuota :execresult
UPDATE mailbox SET quota = sqlc.arg(maildir) WHERE username = sqlc.arg(username);

-- name: GetMailbox :one
SELECT * FROM mailbox WHERE username = ? LIMIT 1;

-- name: GetMailboxMaildir :one
SELECT maildir FROM mailbox WHERE username = ? AND (active = 'true' OR active = 'disabled') LIMIT 1;

-- name: GetMailboxQuota :one
SELECT quota FROM mailbox WHERE username = ? AND (active = 'true' OR active = 'disabled') LIMIT 1;