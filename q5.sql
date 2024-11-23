SELECT
    c.ConferenceID,
    EXTRACT(YEAR FROM c.StartDate) AS Year,
    AVG(CASE WHEN s.Type = 'paper' THEN 1 ELSE 0 END) AS AvgPapers,
    AVG(CASE WHEN s.Type = 'Poster' THEN 1 ELSE 0 END) AS AvgPosters
FROM
    Conferences c
JOIN
    Submissions s ON c.ConferenceID = s.ConferenceID
GROUP BY
    c.ConferenceID, Year
ORDER BY
    Year, c.ConferenceID;
