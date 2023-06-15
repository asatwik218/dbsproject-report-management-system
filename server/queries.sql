-- TRIGGERS

/*on report delete ,
    delete all comments on the report 
    delete all entries in the contributes_to table
*/
CREATE OR REPLACE FUNCTION delete_comments_on_report_delete_func()
RETURNS TRIGGER AS '
DECLARE
BEGIN
    DELETE FROM COMMENTS WHERE REPORT_ID = OLD.REPORT_ID;
    DELETE FROM CONTRIBUTES_TO WHERE REPORT_ID = OLD.REPORT_ID;
    RETURN OLD;
END;
'language 'plpgsql';

CREATE OR REPLACE TRIGGER delete_comments_on_report_delete
  BEFORE DELETE ON REPORTS
  FOR EACH ROW
  EXECUTE PROCEDURE delete_comments_on_report_delete_func();


/* on project delete,
    delete all reports related to that project
    delete all entries of that project from works_on
*/
CREATE OR REPLACE FUNCTION delete_reports_on_project_delete_func()
RETURNS TRIGGER AS '
DECLARE
BEGIN
    DELETE FROM Reports WHERE proj_id = OLD.proj_id;
    DELETE FROM works_on WHERE proj_id = OLD.proj_id;
    RETURN OLD;
END;
'language 'plpgsql';

CREATE OR REPLACE TRIGGER delete_reports_on_project_delete
  BEFORE DELETE ON Projects
  FOR EACH ROW
  EXECUTE PROCEDURE delete_reports_on_project_delete_func();


-- TODO:
/* on USER insert
    set year_of_study
    set branch
    from reg_no
*/

/*
 on comment insert 
 add comment_date 
 make is_addressed = false initially
*/
CREATE OR REPLACE FUNCTION add_comment_date()
RETURNS TRIGGER AS '
DECLARE
BEGIN
    UPDATE comments SET comment_date = CURRENT_TIMESTAMP WHERE comment_id = NEW.comment_id;
    UPDATE comments SET is_addressed = false WHERE comment_id = NEW.comment_id;   
    RETURN NEW;
END;
'language 'plpgsql';

CREATE OR REPLACE TRIGGER add_comment_date_trigger
  BEFORE DELETE ON Comments
  FOR EACH ROW
  EXECUTE PROCEDURE add_comment_date();


-- insert project
CREATE OR REPLACE PROCEDURE Project_Insert(varchar,varchar,varchar,varchar,varchar)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    INSERT INTO projects(proj_name, proj_preface,point_of_contact,subsystem_name,priority) VALUES($1,$2,$3,$4,$5);
END;
$$;

call Project_Insert(proj_name, proj_preface,point_of_contact,subsystem_name,priority);

--insert report
CREATE OR REPLACE PROCEDURE Report_Insert(varchar,int)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    INSERT INTO reports(report_title,proj_id) values($1,$2);
END;
$$;

call Report_Insert(report_title,proj_id);

--comment insert
CREATE OR REPLACE PROCEDURE Comment_Insert(varchar,varchar,int)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    INSERT INTO comments(comment_text,comment_by,report_id) values($1,$2,$3);
END;
$$;

call Comment_Insert(comment_text,comment_by,report_id);

--delete comment
CREATE OR REPLACE PROCEDURE Comment_delete(int)
LANGUAGE 'plpgsql'
AS $$
BEGIN
   DELETE FROM COMMENTS WHERE comment_id = $1;
END;
$$;

call Comment_delete();

--delete reports
CREATE OR REPLACE PROCEDURE Report_delete(int)
LANGUAGE 'plpgsql'
AS $$
BEGIN
   DELETE FROM Reports WHERE report_id = $1;
END;
$$;

call Report_delete();

--delete projects
CREATE OR REPLACE PROCEDURE Project_delete( id integer)
LANGUAGE 'plpgsql'
AS $$
BEGIN
   DELETE FROM Projects WHERE proj_id = id;
END;
$$;

call Project_delete();

--insert into works_on
CREATE OR REPLACE PROCEDURE Works_on_insert(varchar,int)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    INSERT INTO works_on(learner_id,proj_id) values($1,$2);
END;
$$;

call Works_on_insert(learner_id,proj_id);


-- getting all projects of a particular user
SELECT * FROM projects INNER JOIN works_on on works_on.proj_id = projects.proj_id where works_on.learner_id = $1





