# Academic-Conference-Database

A database of an academic conference!

The domain:

- Conferences have names, locations, and dates
- Conferences with the same name can occur multiple times. For example, some conferences are held every year, some every two years, and so on.
- Authors make submissions to conferences. Submissions can be either papers or posters, and can have any number of authors. However, anonymous submissions are not permitted. The order of the authors on a paper is meaningful.
- To help ensure there are enough reviewers for submissions, at least one author on each paper must be a reviewer. This is not a requirement for posters.
- Reviewers are assigned to review submissions. Reviewers cannot review their own submissions, the submissions of anyone else with whom they are co-authors, or the submissions of anyone else from their organization. Reviewers can also declare additional conflicts beyond those rules.
- A submission must receive at least three reviews before it can have a decision – either “accept” or “reject”. Each review recommends a decision, and a submission cannot be accepted if it no reviewer recommended “accept”.
- Submissions that have previously been accepted cannot be submitted again later. (Assume submissions are the same if they have the same title, authors, and type. However multiple submissions can have the same title.)
- Accepted submissions are scheduled for presentation during a conference. Posters are presented during a “poster session”, which can have any number of posters presented at the same time. Papers are presented in “paper sessions”.
Each paper session can have multiple papers assigned, but each paper has its own start time within the session. Paper sessions also require someone in the role of “session chair”. The only requirement of a session chair is that they are attending the conference, aren’t an author on any papers at that session, and do
not have something else schedule at the same time.
- Multiple presentations can be scheduled at the same time but no author can have two presentations at the same time, with one exception – an author can have one paper and poster at the same time, as long as they are not the sole author on either of them.
- Conference attendees must all register for the conference. Most attendees pay a registration fee, and students pay a lower fee than other attendees.
- At least one author on every accepted submission must be registered for the conference.
- Conferences can also have workshops. Workshops must have at least one facilitator. Attendees who want to attend workshops must register and pay for those separately from the rest of the conference.
- Conferences have organizing committees as well as one or two conference chairs. The conference chairs must have been on the organizing committee for that conference at least twice before becoming conference chair, unless the conference is too new.
- Everyone involved should have contact information and the organization they are part of stored in the database.

  Some features above are not realistic, but they are simplified.

  q1 - q5:
  1. For each conference, report the percentage of submissions that were accepted in each year that conference was held.
  2. For each person in the database, report the number of conferences they have attended.
  3. Find the conference with the highest total number of papers accepted. Report all the first authors on those papers.
  4. Find the accepted submission that was submitted the most times before it was accepted.
  5. For each occurrence of a conference, report the average number of papers in a paper session and the average number of posters in the poster session.
