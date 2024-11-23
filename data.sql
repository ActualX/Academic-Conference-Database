SET SEARCH_PATH TO a3conference;


-- Conference data
INSERT INTO conferences (ConferenceID, Name, Location, StartDate, EndDate) Values
(1, 'SIGCSE TS', 'Toronto', '2023-03-01', '2023-03-05'),
(2, 'CompEd', 'Location TBD', '2025-06-01', '2025-06-05'),
(3, 'International Conference on Machine Learning', 'Paris', '2024-07-10', '2024-07-15'),
(4, 'Global Cybersecurity Summit', 'Singapore', '2023-10-05', '2023-10-08'),
(5, 'Conference on Quantum Computing Advances', 'San Francisco', '2024-04-20', '2024-04-23'),
(6, 'SIGCSE TS', 'New York', '2024-03-01', '2024-03-05'),
(7, 'Conference on Quantum Computing Advances', 'Los Angeles', '2024-12-11', '2024-12-16');



INSERT INTO Authors (AuthorID, FirstName, LastName, Email, Organization, IsReviewer) VALUES
(1, 'Michelle', 'Craig', 'michellecraig@email.com', 'University of Toronto', TRUE),
(2, 'Jennifer', 'Campbell', 'jennifercampbell@email.com', 'University of Ottawa', TRUE),
(3, 'Sadia', 'Sharmin', 'sadiasharmin@email.com', 'University of Alberta', FALSE),
(4, 'Jonathan', 'Calver', 'jonathancalver@email.com', 'Standford University', TRUE),
(5, 'Larry', 'Yueli Zhang', 'larryzhang@email.com', 'Research Lab', TRUE),
(6, 'Diane', 'Horton', 'dianehorton@email.com', 'University of Toronto', FALSE),
(7, 'Daniel', 'Zingaro', 'danielzingaro@email.com', 'Research Institute', TRUE),
(8, 'Danny', 'Heap', 'dannyheap@email.com', 'University of Toronto', FALSE),
(9, 'Emma', 'Stone', 'emmastone@email.com', 'Tech Company', TRUE),
(10, 'James', 'Bond', 'jamesbond@email.com', 'Global Tech', FALSE);



INSERT INTO Submissions (SubmissionID, ConferenceID, Title, Type, Status, submissionCount, reviewCount) VALUES
(1, 1, 'Student Perspectives on Optional Groups', 'paper', 'Accepted', 1, 3),
(2, 1, 'Experience Report on the Use of Breakout Rooms in a Large Online Course', 'paper', 'Accepted', 1, 5),
(3, 2, 'Introducing and Evaluating Exam Wrappers in CS2', 'paper', 'Accepted', 1, 6),
(4, 3, 'Advances in Neural Network Optimization', 'paper', 'Under Review', 1, 1),
(5, 4, 'Cybersecurity Trends in 2023: A Global Perspective', 'paper', 'Accepted', 1, 4),
(6, 5, 'Quantum Entanglement and Communication', 'paper', 'Rejected', 1, 3),
(7, 1, 'Innovations in Distance Learning', 'Poster', 'Accepted', 1, 4),
(8, 3, 'Deep Learning Applications in Healthcare', 'paper', 'Accepted', 4, 3),
(9, 1, 'Virtual Classrooms: Engagement and Challenges', 'Poster', 'Accepted', 1, 5),
(10, 2, 'Interactive Learning with AI Assistants', 'Poster', 'Accepted', 1, 7),
(11, 6, 'Exploring Computer Science Education in 2024', 'paper', 'Under Review', 3, 0),
(12, 6, 'Innovative Teaching Methods in Cybersecurity', 'paper', 'Accepted', 2, 3),
(13, 7, 'Quantum Algorithms in Real-World Scenarios', 'paper', 'Rejected', 2, 3),
(14, 7, 'The Future of Quantum Computing', 'Poster', 'Accepted', 1, 6);



INSERT INTO SubmissionAuthors (submissionid, authorid, authororder) VALUES
(1, 1, 1), (1, 2, 2),
(2, 3, 1), (2, 4, 2),
(3, 5, 1), (3, 6, 2),
(4, 7, 1),
(5, 8, 1), (5, 9, 2),
(6, 1, 2),
(7, 1, 1),
(8, 2, 1), (8, 3, 2),
(9, 4, 1),
(10, 5, 1), (10, 6, 2),
(11, 1, 1), (11, 3, 2),
(12, 2, 1),
(13, 5, 1),
(14, 4, 1);



INSERT INTO Reviews (ReviewID, SubmissionID, ReviewerID, ReviewTime, Recommendation, Comments) VALUES
(1, 1, 5, '2023-03-02 09:00:00', 'Accept', 'A comprehensive and well-articulated paper.'),
(2, 1, 7, '2023-03-02 13:00:00', 'Accept', 'Outstanding analysis and presentation.'),
(3, 2, 9, '2023-03-03 10:30:00', 'Reject', 'The methodology section requires clarification.'),
(4, 3, 7, '2023-03-04 15:00:00', 'Accept', 'Innovative approach, but needs more data.'),
(5, 3, 9, '2023-03-05 09:20:00', 'Accept', 'Solid work, well supported by current literature.'),
(6, 4, 1, '2023-07-11 11:15:00', 'Reject', 'Interesting topic, but the paper lacks experimental results.'),
(7, 5, 4, '2023-10-06 14:45:00', 'Accept', 'A thorough and well-researched piece.'),
(8, 5, 7, '2023-10-07 10:00:00', 'Accept', 'Great insights into the evolving cybersecurity landscape.'),
(9, 6, 7, '2024-04-21 16:30:00', 'Reject', 'The conclusions drawn are not well-supported by the data.'),
(10, 7, 5, '2023-03-01 12:00:00', 'Accept', 'Engaging and relevant to current educational challenges.'),
(11, 8, 5, '2023-07-12 14:00:00', 'Accept', 'Excellent application of deep learning techniques.'),
(12, 8, 1, '2023-07-13 09:30:00', 'Accept', 'Impressive research with potential for real-world impact.'),
(13, 9, 9, '2023-03-02 10:45:00', 'Accept', 'A well-structured study on an important topic.'),
(14, 10, 2, '2023-06-02 11:00:00', 'Accept', 'Innovative and forward-thinking.'),
(15, 10, 7, '2023-06-03 15:30:00', 'Accept', 'A crucial contribution to AI in education.'),
(16, 11, 2, '2024-03-02 09:00:00', 'Reject', 'The paper needs more depth in its theoretical framework.'),
(17, 12, 1, '2024-03-02 10:00:00', 'Accept', 'Well-structured and informative.'),
(18, 13, 2, '2024-07-11 14:00:00', 'Accept', 'Comprehensive and insightful.'),
(19, 14, 7, '2024-10-06 09:15:00', 'Accept', 'Engaging content with practical implications.');


INSERT INTO Presentations (PresentationID, SubmissionID, ConferenceID,
                           StartTime, EndTime, Location, SessionChairID) VALUES
(1, 1, 1, '2023-03-02 09:30:00', '2023-03-02 10:30:00', 'Main Auditorium', 5),
(2, 2, 1, '2023-03-03 11:00:00', '2023-03-03 12:00:00', 'Conference Room B', 6),
(3, 3, 2, '2025-06-02 14:00:00', '2025-06-02 15:00:00', 'Hall 2', 7),
(4, 4, 3, '2024-07-11 16:00:00', '2024-07-11 17:00:00', 'Lecture Hall 3', 8),
(5, 7, 1, '2023-03-04 10:00:00', '2023-03-04 10:45:00', 'Workshop Room', 9),
(6, 8, 3, '2024-07-12 11:00:00', '2024-07-12 12:00:00', 'Seminar Room', 10),
(7, 9, 1, '2023-03-02 15:30:00', '2023-03-02 16:15:00', 'Hall C', 2),
(8, 10, 2, '2025-06-03 09:00:00', '2025-06-03 09:45:00', 'Auditorium 2', 3);



INSERT INTO Attendees (AttendeeID, Name, Email, IsStudent, ConferenceID, Registered) VALUES
(1, 'Anne White', 'annewhite@email.com', FALSE, 1, TRUE),
(2, 'Gary Black', 'garyblack@email.com', TRUE, 3, TRUE),
(3, 'Sarah Green', 'sarahgreen@email.com', FALSE, 2, TRUE),
(4, 'Oliver Brown', 'oliverbrown@email.com', TRUE, 4, FALSE),
(5, 'Emma Johnson', 'emmajohnson@email.com', FALSE, 5, TRUE),
(6, 'James Wilson', 'jameswilson@email.com', TRUE, 1, FALSE),
(7, 'Mia Davis', 'miadavis@email.com', FALSE, 3, TRUE),
(8, 'Lucas Miller', 'lucasmiller@email.com', TRUE, 2, FALSE),
(9, 'Amelia Taylor', 'ameliataylor@email.com', FALSE, 4, TRUE),
(10, 'Liam Smith', 'liamsmith@email.com', TRUE, 5, FALSE);



INSERT INTO Workshops (WorkshopID, ConferenceID, Title, FacilitatorID) VALUES
(1, 3, 'Intro to Deep Learning', 6),
(2, 4, 'Advanced Cybersecurity', 8),
(3, 1, 'Effective Teaching Techniques in Computer Science', 1),
(4, 2, 'Quantum Computing Fundamentals', 5),
(5, 5, 'The Future of Quantum Computing', 9),
(6, 1, 'Exploring AI Ethics', 7),
(7, 3, 'Machine Learning for Healthcare Applications', 10),
(8, 4, 'Cybersecurity Threats and Solutions', 3);



INSERT INTO OrganizingCommittee (MemberID, Name, Email, ConferenceID, Role) VALUES
(1, 'Lucas Green', 'lucasgreen@email.com', 1, 'Coordinator'),
(2, 'Hannah Blue', 'hannahblue@email.com', 2, 'Event Manager'),
(3, 'Natalie Reed', 'nataliereed@email.com', 1, 'Program Chair'),
(4, 'Ethan Carter', 'ethancarter@email.com', 2, 'Financial Coordinator'),
(5, 'Sophia Lee', 'sophialee@email.com', 3, 'Logistics Manager'),
(6, 'Noah Turner', 'noahturner@email.com', 4, 'Sponsorship Coordinator'),
(7, 'Zoe Brooks', 'zoebrooks@email.com', 5, 'Volunteer Coordinator'),
(8, 'Liam Walker', 'liamwalker@email.com', 1, 'Marketing Director'),
(9, 'Olivia Harris', 'oliviaharris@email.com', 2, 'Technical Support Lead'),
(10, 'Jackson Wright', 'jacksonwright@email.com', 3, 'Public Relations Officer');



INSERT INTO ConferenceChairs (ChairID, MemberID, ConferenceID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 5, 3),
(4, 6, 4),
(5, 7, 5),
(6, 8, 1),
(7, 9, 2),
(8, 10, 3);



