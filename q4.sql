SELECT
    submissionID, title, submissionCount
FROM
    Submissions
WHERE
    status = 'Accepted'
ORDER BY
    submissionCount DESC
LIMIT 1;