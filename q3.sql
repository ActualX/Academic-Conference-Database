WITH AcceptedPapers AS (
    SELECT
        ConferenceID,
        COUNT(*) AS TotalAccepted
    FROM
        Submissions
    WHERE
        Status = 'Accepted'
    GROUP BY
        ConferenceID
    ORDER BY
        TotalAccepted DESC
    LIMIT 1
)
SELECT DISTINCT
    c.ConferenceID,
    c.Name AS ConferenceName,
    sa.AuthorID
FROM
    SubmissionAuthors sa
JOIN
    Submissions s ON sa.SubmissionID = s.SubmissionID
JOIN
    AcceptedPapers ap ON s.ConferenceID = ap.ConferenceID
JOIN
    Conferences c ON c.ConferenceID = ap.ConferenceID
WHERE
    sa.AuthorOrder = (
        SELECT MIN(AuthorOrder)
        FROM SubmissionAuthors
        WHERE SubmissionID = s.SubmissionID
    );
