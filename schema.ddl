/*
Could not:
Constraints that could not be enforced directly in DDL include:
1. Ensures at least one author of an accepted submission is registered for the conference.
This requires cross table data accessing. We could make views to review these
informations but we cannot write CHECKs in views,
thus there's no way to help us automate this constraint without the help of triggers.

2. Ensures that at least one author is a reviewer.
This requires cross table data accessing. For the same reason as 1, there's no way
to automate this constraint without the help of triggers.

3. Prevents scheduling conflicts for presentations involving the same authors.
This requires cross table data accessing. For the same reason as 1, there's no way
to automate this constraint without the help of triggers.

4. Checks that a submission has at least three reviews before it can be accepted.
This requires cross table data accessing. For the same reason as 1, there's no way
to automate this constraint without the help of triggers.

5. Manages the resubmission process to ensure accepted submissions are not resubmitted.
Although this doesn't requires cross table data accessing, but querying the already
submitted submissions will require query and as we all know we cannot include
queries and functions in the check. So there's no way to automate this constraint
without the help of triggers.

6. Ensures session chairs do not chair sessions that include their own submissions.
This requires cross table data accessing. For the same reason as 1, there's no way to
automate this constraint without the help of triggers.

7. Prevents reviewers from reviewing their own submissions or those from the same organization.
This requires cross table data accessing. For the same reason as 1, there's no way to
automate this constraint without the help of triggers.

8. Ensure that at least one author of a paper submission is marked as a reviewer.
This requires cross table data accessing and updating. Although there is 1 approach
which doesn't requires triggers: add a reviewerID to submission table and update it to be one of
the authors marked as reviewer, but this approach requires updating tables when the authors' status
changes, so without the help of triggers, we are unable to make such an update.


Did not:
Constraints not enforced in DDL include:
N/A

Extra Constraints:
Additional constraints enforced that were not specified include:
1. Unique email address for authors, ensuring the distinct identification of
individuals involved in submissions and reviews.
2. extra submission count and review count attribute for the submission table 

Assumptions:
Assumptions made during schema design include:
1. Each submission is uniquely identifiable by its 'SubmissionID'.
2. The order of authors in 'SubmissionAuthors' is significant and reflective of
their roles or contributions.
3. All authors are associated with an organization, as reflected by the non-nullable
'Organization' field in the 'Authors' table.
4. Detailed conflict of interest checks for reviewers and session chairs are managed
outside the DDL scope, likely at the application level.
5. The submission with the same title and type can be considered the same article.
 */





DROP SCHEMA IF EXISTS A3Conference CASCADE;
CREATE SCHEMA A3Conference;
SET SEARCH_PATH TO A3Conference;

-- Conferences: Stores basic information about each conference.
CREATE TABLE Conferences
(
    conferenceID INT PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    location     VARCHAR(255) NOT NULL,
    startDate    DATE         NOT NULL,
    endDate      DATE         NOT NULL,
    CHECK (startDate <= endDate)    -- Ensures the start date comes before the end date
);

-- Submissions: Represents each submission to a conference, including its status.
CREATE TABLE Submissions
(
    submissionID INT PRIMARY KEY,
    conferenceID INT          NOT NULL,
    title        VARCHAR(255) NOT NULL,
    type         VARCHAR(100) NOT NULL CHECK (type IN ('paper', 'Poster')),
    status       VARCHAR(100) NOT NULL CHECK (status IN ('Accepted', 'Rejected', 'Under Review')),
    submissionCount INTEGER DEFAULT 0,    -- Counts resubmissions for uniqueness
    reviewCount INTEGER DEFAULT 0,    -- Tracks the number of reviews for a submission
    FOREIGN KEY (conferenceID) REFERENCES Conferences (conferenceID),
    CHECK (status != 'Accepted' OR reviewCount >= 3)
);

-- Authors: Contains information about each author, including whether they can review.
CREATE TABLE Authors (
    authorID     INT PRIMARY KEY,
    firstName    VARCHAR(255) NOT NULL,
    lastName     VARCHAR(255) NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    organization VARCHAR(255) NOT NULL,
    isReviewer   BOOLEAN NOT NULL DEFAULT FALSE -- Indicates if the author can review
);

-- SubmissionAuthors: Links authors to their submissions, preserving author order.
CREATE TABLE SubmissionAuthors
(
    submissionID INT NOT NULL,
    authorID     INT NOT NULL,
    authorOrder  INT NOT NULL,    -- Maintains the order of authors for a submission
    PRIMARY KEY (submissionID, authorID),
    FOREIGN KEY (submissionID) REFERENCES Submissions (submissionID),
    FOREIGN KEY (authorID) REFERENCES Authors (authorID)
);

-- Reviews: Records reviews for submissions, including recommendations and comments.
CREATE TABLE Reviews (
    reviewID       INT PRIMARY KEY,
    submissionID   INT NOT NULL,
    reviewerID     INT NOT NULL,    -- Links to the author acting as the reviewer
    reviewTime TIMESTAMP NOT NULL,
    recommendation VARCHAR(100) CHECK (recommendation IN ('Accept', 'Reject')),
    comments       TEXT,
    FOREIGN KEY (submissionID) REFERENCES Submissions (submissionID),
    FOREIGN KEY (reviewerID) REFERENCES Authors (authorID)
);

-- Presentations: Schedules presentations for accepted submissions at the conference.
CREATE TABLE Presentations (
    presentationID INT PRIMARY KEY,
    submissionID   INT       NOT NULL,
    conferenceID   INT       NOT NULL,
    startTime    TIMESTAMP NOT NULL,
    endTime TIMESTAMP NOT NULL,
    location       VARCHAR(255),
    sessionChairID INT,    -- Identifies the session chair, must not be an author of the session's submissions
    FOREIGN KEY (submissionID) REFERENCES Submissions (submissionID),
    FOREIGN KEY (conferenceID) REFERENCES Conferences (conferenceID),
    FOREIGN KEY (sessionChairID) REFERENCES Authors (authorID)
);

-- Attendees: Tracks individuals who have registered to attend the conference.
CREATE TABLE Attendees
(
    attendeeID   INT PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    isStudent    BOOLEAN      NOT NULL,    -- Differentiates student attendees for fee purposes
    conferenceID INT          NOT NULL,
    registered BOOLEAN DEFAULT FALSE,    -- Tracks registration status
    FOREIGN KEY (conferenceID) REFERENCES Conferences (conferenceID)
);

-- Workshops: Lists workshops occurring at the conference, requiring separate registration.
CREATE TABLE Workshops
(
    workshopID    INT PRIMARY KEY,
    conferenceID  INT          NOT NULL,
    title         VARCHAR(255) NOT NULL,
    facilitatorID INT          NOT NULL,    -- Links to an attendee acting as the facilitator
    FOREIGN KEY (conferenceID) REFERENCES Conferences (conferenceID),
    FOREIGN KEY (facilitatorID) REFERENCES Attendees (attendeeID)
);

-- OrganizingCommittee: Records members of the conference's organizing committee.
CREATE TABLE OrganizingCommittee
(
    memberID     INT PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    conferenceID INT          NOT NULL,
    role         VARCHAR(255),    -- Specifies the committee role of the member
    FOREIGN KEY (conferenceID) REFERENCES Conferences (conferenceID)
);

-- ConferenceChairs: Identifies the chairs of the conference, requiring prior committee experience.
CREATE TABLE ConferenceChairs
(
    chairID      INT PRIMARY KEY,
    memberID     INT NOT NULL,    -- Links to a member of the Organizing Committee
    conferenceID INT NOT NULL,
    FOREIGN KEY (memberID) REFERENCES OrganizingCommittee (memberID),
    FOREIGN KEY (conferenceID) REFERENCES Conferences (conferenceID)
);



-- Triggers and Functions

-- Ensure that at least one author of a paper submission is marked as a reviewer.
CREATE OR REPLACE FUNCTION ensure_paper_has_reviewer_author()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if at least one author of paper is a reviewer
    IF (SELECT type FROM Submissions WHERE SubmissionID = NEW.SubmissionID) = 'paper' AND NOT EXISTS (
        SELECT 1
        FROM SubmissionAuthors SA
        JOIN Authors A ON SA.AuthorID = A.AuthorID
        WHERE SA.SubmissionID = NEW.SubmissionID AND A.isReviewer = TRUE
    ) THEN
        RAISE EXCEPTION 'At least one author must be a reviewer for paper submissions.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ensure_reviewer_for_paper
AFTER INSERT OR UPDATE ON SubmissionAuthors
FOR EACH ROW
EXECUTE FUNCTION ensure_paper_has_reviewer_author();



-- Prevents reviewers from reviewing their own submissions or those from the same organization.
CREATE OR REPLACE FUNCTION fn_check_reviewer_conflict()
RETURNS TRIGGER AS $$
DECLARE
    reviewer_org VARCHAR(255);
BEGIN
    -- Retrieves the organization of the reviewer.
    SELECT organization INTO reviewer_org
    FROM Authors
    WHERE authorID = NEW.reviewerID;
    
    -- Check if the reviewer is an author or co-author of the submission
    IF EXISTS (
        SELECT 1
        FROM SubmissionAuthors
        WHERE SubmissionID = NEW.SubmissionID AND AuthorID = NEW.ReviewerID
    ) THEN
        RAISE EXCEPTION 'Reviewers cannot review their own submissions.';
    END IF;
    
    -- Check for organizational conflict
    IF EXISTS (
        SELECT 1
        FROM SubmissionAuthors SA
        JOIN Authors A ON SA.authorID = A.authorID
        WHERE SA.submissionID = NEW.submissionID AND A.organization = reviewer_org
    ) THEN
        RAISE EXCEPTION 'Reviewers cannot review submissions from their organization.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Check_Reviewer_Conflict
BEFORE INSERT OR UPDATE ON Reviews
FOR EACH ROW
EXECUTE FUNCTION fn_check_reviewer_conflict();


-- Ensures session chairs do not chair sessions that include their own submissions.
CREATE OR REPLACE FUNCTION fn_check_chair_conflict()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the session chair is an author of the submission
    IF EXISTS (
        SELECT 1
        FROM SubmissionAuthors
        WHERE SubmissionID = NEW.SubmissionID AND AuthorID = NEW.SessionChairID
    ) THEN
        RAISE EXCEPTION 'Session chairs cannot be authors of submissions in their session.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_chair_conflict
BEFORE INSERT OR UPDATE ON Presentations
FOR EACH ROW
EXECUTE FUNCTION fn_check_chair_conflict();


-- Manages the resubmission process to ensure accepted submissions are not resubmitted.
CREATE OR REPLACE FUNCTION fn_manage_resubmission()
RETURNS TRIGGER AS $$
DECLARE
    existing_submission RECORD;
BEGIN
    -- Attempt to find an existing submission with the same title and type
    SELECT *
    INTO existing_submission
    FROM Submissions
    WHERE LOWER(title) = LOWER(NEW.title)
    AND type = NEW.type
    LIMIT 1;

    IF FOUND THEN
        -- Check if the existing submission is already accepted
        IF existing_submission.status = 'Accepted' THEN
            RAISE EXCEPTION 'This submission has already been accepted and cannot be resubmitted.';
        ELSE
            -- Update existing submission with new status and reset review count
            UPDATE Submissions
            SET status = NEW.status,
                submissionCount = existing_submission.submissionCount + 1,
                reviewCount = NEW.reviewCount
            WHERE submissionID = existing_submission.submissionID;
            
            -- Prevent the new submission from being inserted
            RETURN NULL;
        END IF;
    END IF;

    -- Allow the insertion of new submissions as normal
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_resubmission
BEFORE INSERT ON Submissions
FOR EACH ROW
EXECUTE FUNCTION fn_manage_resubmission();


-- Updates the review count for a submission each time a new review is added.
CREATE OR REPLACE FUNCTION update_review_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Submissions SET reviewCount = reviewCount + 1 WHERE SubmissionID = NEW.SubmissionID;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_review_count
AFTER INSERT ON Reviews
FOR EACH ROW
EXECUTE FUNCTION update_review_count();



-- Prevents scheduling conflicts for presentations involving the same authors.
CREATE OR REPLACE FUNCTION check_presentation_scheduling_conflict()
RETURNS TRIGGER AS $$
BEGIN
    -- Check for any overlapping presentations for the authors involved
    IF EXISTS (
        SELECT 1 FROM Presentations P
        INNER JOIN SubmissionAuthors SA ON P.SubmissionID = SA.SubmissionID
        INNER JOIN SubmissionAuthors SA2 ON SA2.SubmissionID = NEW.SubmissionID
        WHERE SA.AuthorID = SA2.AuthorID
        AND (
            (NEW.startTime >= P.startTime AND NEW.startTime < P.endTime)
            OR (NEW.endTime > P.startTime AND NEW.endTime <= P.endTime)
            OR (P.startTime >= NEW.startTime AND P.startTime < NEW.endTime)
            OR (P.endTime > NEW.startTime AND P.endTime <= NEW.endTime)
        )
        AND NEW.PresentationID != P.PresentationID -- Exclude self for updates
    ) THEN
        RAISE EXCEPTION 'Scheduling conflict detected for one of the authors.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_presentation_scheduling_conflict
BEFORE INSERT OR UPDATE ON Presentations
FOR EACH ROW
EXECUTE FUNCTION check_presentation_scheduling_conflict();


-- Ensures at least one author of an accepted submission is registered for the conference.
CREATE OR REPLACE FUNCTION ensure_at_least_one_author_registered()
RETURNS TRIGGER AS $$
BEGIN
    -- Checks if at least one author is registered for the conference when a submission is accepted.
    IF NEW.status = 'Accepted' AND NOT EXISTS (
        SELECT 1 FROM Attendees A
        JOIN Authors Au ON A.email = Au.email
        JOIN SubmissionAuthors SA ON Au.authorID = SA.authorID
        WHERE SA.submissionID = NEW.submissionID AND A.conferenceID = NEW.conferenceID AND A.isStudent IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'At least one author must be registered for the conference.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ensure_author_conference_registration
BEFORE UPDATE OF status ON Submissions
FOR EACH ROW
WHEN (NEW.status = 'Accepted')
EXECUTE FUNCTION ensure_at_least_one_author_registered();



-- Ensures that if an author is a reviewer before inserting/updating a review.
CREATE OR REPLACE FUNCTION ensure_author_is_reviewer()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the author assigned as a reviewer is marked as isReviewer
    IF NOT EXISTS (
        SELECT 1
        FROM Authors
        WHERE authorID = NEW.reviewerID AND isReviewer = TRUE
    ) THEN
        RAISE EXCEPTION 'Only authors marked as reviewers can review submissions.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ensure_author_is_reviewer
BEFORE INSERT OR UPDATE ON Reviews
FOR EACH ROW
EXECUTE FUNCTION ensure_author_is_reviewer();

