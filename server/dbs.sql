CREATE TABLE Users (
   learner_id  varchar(255) PRIMARY KEY,
   username  varchar(255),
   hashed_password  varchar(300),
   registration_number  varchar(20) UNIQUE NOT NULL,
   year_of_study  int,
   branch  varchar(20),
   phone_number  varchar(15) UNIQUE,
   subsystem  varchar(50)
);



CREATE TABLE  Subsystems  (
   subsystem_name  varchar(50) PRIMARY KEY,
   subsystem_head  varchar(255)
);


CREATE TABLE  Projects  (
   proj_id  SERIAL PRIMARY KEY, 
   proj_name  varchar(50) UNIQUE NOT NULL,
   proj_preface varchar(255),
   point_of_contact  varchar(255),
   subsystem_name  varchar(50),
   priority  varchar(20) CHECK(priority in('high','medium','low')),
   progress  varchar(20) CHECK(progress in('completed','in progress','not started'))
);



CREATE TABLE  Reports  (
   report_id  SERIAL PRIMARY KEY,
   report_title  varchar(20) NOT NULL UNIQUE,
   proj_id  INT,
   content  TEXT
);

INSERT into reports(report_title,proj_id,content) values()

CREATE TABLE  Comments  (
   comment_id  SERIAL PRIMARY KEY,
   comment_text  varchar(100),
   comment_by  varchar(255),
   report_id  int,
   comment_date DATE,
   is_addressed boolean 
);


CREATE TABLE  works_on  (
   learner_id  varchar(255),
   proj_id  int,
   PRIMARY KEY ( learner_id ,  proj_id )
);


CREATE TABLE  contributes_to  (
   learner_id  varchar(255),
   report_id  int,
  PRIMARY KEY ( learner_id ,  report_id )
);

CREATE TABLE  Inventory  (
   item_name  varchar(100),
   subsystem_name  varchar(50),
   item_location  varchar(255),
   qty  int,
  PRIMARY KEY ( item_name ,  subsystem_name )
);




-- users foreign key
ALTER TABLE  Users  ADD FOREIGN KEY ( subsystem ) REFERENCES  Subsystems  ( subsystem_name ) ON DELETE CASCADE;
-- subsystems foreign key
ALTER TABLE  Subsystems  ADD FOREIGN KEY ( subsystem_head ) REFERENCES  Users  ( learner_id ) ON DELETE CASCADE;
-- projects foreign key
ALTER TABLE  Projects  ADD FOREIGN KEY ( subsystem_name ) REFERENCES  Subsystems  ( subsystem_name ) ON DELETE CASCADE;
ALTER TABLE  Projects  ADD FOREIGN KEY ( point_of_contact ) REFERENCES  Users  ( learner_id ) ON DELETE CASCADE;
-- reports foreign key
ALTER TABLE  Reports  ADD FOREIGN KEY ( proj_id ) REFERENCES  Projects  ( proj_id ) ON DELETE CASCADE;
-- comments foreign key
ALTER TABLE  Comments  ADD FOREIGN KEY ( comment_by ) REFERENCES  Users  ( learner_id ) ON DELETE CASCADE;
ALTER TABLE  Comments  ADD FOREIGN KEY ( report_id ) REFERENCES  Reports  ( report_id ) ON DELETE CASCADE;
-- works_on foreign key
ALTER TABLE  works_on  ADD FOREIGN KEY ( learner_id ) REFERENCES  Users  ( learner_id ) ON DELETE CASCADE;
ALTER TABLE  works_on  ADD FOREIGN KEY ( proj_id ) REFERENCES  Projects  ( proj_id ) ON DE;
-- contributes_to foreign key
ALTER TABLE  contributes_to  ADD FOREIGN KEY ( learner_id ) REFERENCES  Users  ( learner_id ) ON DELETE CASCADE;
ALTER TABLE  contributes_to  ADD FOREIGN KEY ( report_id ) REFERENCES  Reports  ( report_id ) ON DELETE CASCADE;
-- inventory foreign key
ALTER TABLE  Inventory  ADD FOREIGN KEY ( subsystem_name ) REFERENCES  Subsystems  ( subsystem_name ) ON DELETE CASCADE;


-- deleting tables if required
-- DROP TABLE Projects Cascade;
-- DROP TABLE Users Cascade;
-- DROP TABLE comments Cascade;
-- DROP TABLE works_on Cascade;
-- DROP TABLE contributes_to Cascade;
-- DROP TABLE reports Cascade;
-- DROP TABLE inventory Cascade;
-- DROP TABLE subsystems Cascade;




-- INSERTION into subsystems
INSERT INTO Subsystems (subsystem_name) VALUES ('avionics');
INSERT INTO Subsystems (subsystem_name) VALUES ('propulsions');
INSERT INTO Subsystems (subsystem_name) VALUES ('aerodynamics');
INSERT INTO Subsystems (subsystem_name) VALUES ('structures');
INSERT INTO Subsystems (subsystem_name) VALUES ('management');


-- Insert into users
INSERT INTO users values('satwik.agarwal@learner.manipal.edu','Satwik Agarwal','$2b$10$4ihrljKb.hi4KF6jBHYRxO977hwjeMLzOYHdQImWGMn3v9bFzcgTm','210905264',21,'CSE','7001206144','avionics');
INSERT INTO users values('krish.goyal1@learner.manipal.edu','Krish Goyal','$2b$10$TJtDdtnlMEm6uukvaRkD4OWVVFpKG4bcmrLDtPZoRIt6VxzTJzkT6','210962100',21,'AIML','7906847088','management');
INSERT INTO users values('divyansh.gupta1@learner.manipal.edu','Divyansh Gupta','$2b$10$PPQGaNLlFK2N7sKKmnodjeRK18xCBrNWfOVU4sl5z/BpYRZdmUSQi','210962086',21,'AIML','9026698202','avionics');
INSERT INTO users values('abhishek.debnath@learner.manipal.edu','Abhishek Debnath','$2b$10$y3mO7sgHTGBij1mBkvtM6OusxbE8EBaKcCWPXQ.t6qgqroWRZbsFu','210905222',21,'CSE','8327563291','management');
INSERT INTO users values('rohit.das@learner.manipal.edu','Rohit Das','$2b$10$gcBlcHoFdrgA.atTArjmS.io4JyZlJ8PlIU6vW9.Yl1zT4rqbOTmm','220905265',22,'EEE','3245781255','aerodynamics');
INSERT INTO users values('sana.chauhan@learner.manipal.edu','Sana Chauhan','$2b$10$piWX7MeR4vLd8SGvOPKGxeC0vgtreYcRH.ddf6M/.nd9yIQfFwM8G','200905234',20,'Civil','5478889743','propulsions');
INSERT INTO users values('mohit.bhattacharya@learner.manipal.edu','Mohit Bhattacharya','$2b$10$ytL3O0lukIwRSCgQsnSG1eNXuUXV8ZlJSuB5r5l1P5/IurPdYodh.','210905256',21,'Mech','2233114564','aerodynamics');
INSERT INTO users values('sagar.patil@learner.manipal.edu','Sagar Patil','$2b$10$9ZI3p1xbS4vGI5UJ6nYPQuw0n5wwcAuokdkcn02buj7PySfxQvDUG','210905543',21,'CSE','6712458734','structures');
INSERT INTO users values('diya.jhunjhunwala@learner.manipal.edu','Diya Jhunjhunwala','$2b$10$bey0dSbYiEH.VTwP.ol.9u3KnJGTnf0/LeHhE94sLSeexTFWaJwpO','200905298',20,'IT','5478902300','propulsions');



INSERT INTO projects(proj_name,proj_preface,point_of_contact,subsystem_name,priority,progress) values('Flight computer','A flight computer is a form of circular slide rule used in aviation and one of a very few analog computers in widespread use in the 21st century','divyansh.gupta1@learner.manipal.edu','avionics','medium','not started')
INSERT INTO projects(proj_name,proj_preface,point_of_contact,subsystem_name,priority,progress) values('Udaan','Avionics Control System for Unmanned Aerial Vehicles (UAVs)','satwik.agarwal@learner.manipal.edu','avionics','high','in progress')
INSERT INTO projects(proj_name,proj_preface,point_of_contact,subsystem_name,priority,progress) values('Project Sky','Investigating the Performance of Avionics Systems in Extreme Environments','sana.chaihan@learner.manipal.edu','Propulsion','high','completed')
INSERT INTO projects(proj_name,proj_preface,point_of_contact,subsystem_name,priority,progress) values('Project FDDT','Improving the Reliability of Avionics Systems Using Fault Detection and Diagnosis Techniques','sagar.patil@learner.manipal.edu','structures','low','not started')
INSERT INTO projects(proj_name,proj_preface,point_of_contact,subsystem_name,priority,progress) values('Project HEPA','Avionics System Integration for Hybrid Electric Propulsion Aircraft','diya.jhunjhunwala@learner.manipal.edu','Propulsion','medium','in progress')



INSERT into reports(report_title,proj_id,content) values('TFC',10,'The flight computer, also known as an E6B or whiz wheel, is a circular slide rule used in aviation for various calculations such as fuel consumption, airspeed, and wind correction. It is one of the few analog computers still widely used in the 21st century.')
INSERT into reports(report_title,proj_id,content) values('ACS',10,'An Avionics Control System (ACS) for Unmanned Aerial Vehicles (UAVs) is a critical component that controls and monitors various functions of the aircraft, such as navigation, communication, and mission management.')
INSERT into reports(report_title,proj_id,content) values('IPA',12,'Investigating the performance of avionics systems in extreme environments is crucial to ensure their safe and reliable operation. Such testing involves subjecting avionics systems to extreme temperatures, pressure.')
INSERT into reports(report_title,proj_id,content) values('IRA',13,'Improving the reliability of avionics systems using fault detection and diagnosis techniques is vital to enhance aircraft safety. These techniques involve using sensors, algorithms, and software to monitor avionics systems for anomalies, diagnose faults, and take corrective action before failure occurs.')
INSERT into reports(report_title,proj_id,content) values('ASI',14,'Avionics system integration for hybrid electric propulsion aircraft is a critical aspect that requires coordination between the propulsion system and avionics subsystems to ensure seamless operation, safety, and efficiency of the aircraft.')


Insert into works_on VALUES('divyansh.gupta1@learner.manipal.edu',10);
Insert into works_on VALUES('satwik.agarwal@learner.manipal.edu',10);

Insert into works_on VALUES('divyansh.gupta1@learner.manipal.edu',11);
Insert into works_on VALUES('satwik.agarwal@learner.manipal.edu',11);
Insert into works_on VALUES('abhishek.debnath@learner.manipal.edu',11);

Insert into works_on VALUES('sana.chauhan@learner.manipal.edu',12);
Insert into works_on VALUES('diya.jhunjhunwala@learner.manipal.edu',12);

Insert into works_on VALUES('sagar.patil@learner.manipal.edu',13);

;
Insert into works_on VALUES('sana.chauhan@learner.manipal.edu',14);
Insert into works_on VALUES('diya.jhunjhunwala@learner.manipal.edu',14);
Insert into works_on VALUES('rohit.das@learner.manipal.edu',14);





Insert into Contributes_to VALUES('divyansh.gupta1@learner.manipal.edu',1);
Insert into Contributes_to VALUES('satwik.agarwal@learner.manipal.edu',1);

Insert into Contributes_to VALUES('satwik.agarwal@learner.manipal.edu',2);


Insert into Contributes_to VALUES('sana.chauhan@learner.manipal.edu',3);
Insert into Contributes_to VALUES('diya.jhunjhunwala@learner.manipal.edu',3);

Insert into Contributes_to VALUES('sagar.patil@learner.manipal.edu',4);

;
Insert into Contributes_to VALUES('sana.chauhan@learner.manipal.edu',5);
Insert into Contributes_to VALUES('diya.jhunjhunwala@learner.manipal.edu',5);

