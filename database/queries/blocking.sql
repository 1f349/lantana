-- name: CreateReport :execresult
INSERT INTO receiveBlockReports (address, reporter, report) VALUES (?, ?, ?);

-- name: DeleteReport :execresult
DELETE FROM receiveBlockReports WHERE address = $1 AND reporter = $2;

-- name: GetAllReports :many
SELECT * FROM receiveBlockReports;

-- name: GetReportsOfAddress :many
SELECT reporter, report FROM receiveBlockReports WHERE address = ?;

-- name: GetReportsOfReporter :many
SELECT address, report FROM receiveBlockReports WHERE reporter = ?;

-- name: GetReport :one
SELECT report FROM receiveBlockReports WHERE address = $1 AND reporter = $2 LIMIT 1;

-- name: Block :execresult
INSERT INTO receiveBlockMap (address, access) VALUES (?, 'REJECT');

-- name: Unblock :execresult
DELETE FROM receiveBlockMap WHERE address = ?;

-- name: GetAllBlocks :many
SELECT * FROM receiveBlockMap;

-- name: GetBlock :one
SELECT access FROM receiveBlockMap WHERE address = ?;