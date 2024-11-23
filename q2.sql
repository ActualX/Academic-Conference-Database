SELECT
    A.name,
    COUNT(DISTINCT A.conferenceID) as NumberOfConferencesAttended
FROM
    Attendees A
GROUP BY
    A.name;
