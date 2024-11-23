SELECT
    c.Name AS ConferenceName,
    EXTRACT(YEAR FROM c.StartDate) AS Year,
    ROUND((COUNT(s.*) FILTER (WHERE s.Status = 'Accepted')::decimal / COUNT(s.*)) * 100, 2) AS AcceptanceRate
FROM
    Conferences c
JOIN
    Submissions s ON c.ConferenceID = s.ConferenceID
GROUP BY
    c.Name, Year
ORDER BY
    ConferenceName, Year;
