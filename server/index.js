const pool = require("./db");
const express = require("express");
const app = express();
const cors = require("cors");
const bcrypt = require("bcrypt");
const { v4: uuidv4 } = require("uuid");
const saltRounds = 10;

const PORT = process.env.PORT ?? 8000;

//middleware
app.use(cors());
app.use(express.json());


//user login
app.post("/login", async (req, res) => {
  const { learnerID, password } = req.body;
  let result = false;
  let msg = "";

  try {
    const query = await pool.query(
      "SELECT hashed_password FROM users where learner_id = $1",
      [learnerID]
    );

    if (query.rows.length === 0) {
      result = false;
      msg = "User not found";
    } else {
      const match = await bcrypt.compare(
        password,
        query.rows[0].hashed_password
      );
      if (match) {
        result = true;
        msg = "Login successful";
      } else {
        result = false;
        msg = "Incorrect password";
      }
    }

    res.json({ result: result, msg: msg });
  } catch (err) {
    res.json(err);
  }
});

//get all projects of a particular user
app.post("/getprojects", async (req, res) => {
  const { learner_id } = req.body;
  try {
    const projects = await pool.query(
      "SELECT * FROM projects INNER JOIN works_on on works_on.proj_id = projects.proj_id where works_on.learner_id = $1",
      [learner_id]
    );
    res.json(projects.rows);
  } catch (err) {
    console.error(err);
  }
});

//create a new project
app.post("/createproject", async (req, res) => {
  // call Project_Insert(proj_name, proj_preface,point_of_contact,subsystem_name,priority);

  const { learner_id, name, preface, sname, poc, userContributes } = req.body;
  try {
    let q = await pool.query("CALL Project_Insert($1,$2,$3,$4,'low')", [
      name,
      preface,
      poc,
      sname,
    ]);
    q = await pool.query("SELECT proj_id FROM projects WHERE proj_name = $1", [
      name,
    ]);
    const proj_id = q.rows[0].proj_id;
    for (const user of userContributes) {
      q = await pool.query("CALL Works_on_insert($1,$2)", [
        user.value,
        proj_id,
      ]);
    }
    console.log(q);
    res.json({ result: "success" });
  } catch (err) {
    console.error(err);
    res.json({ result: "failure", err });
  }
});

//get all reports of a particular project
app.get("/:proj_id/getreports", async (req, res) => {
  const proj_id = parseInt(req.params.proj_id);
  try {
    const reports = await pool.query(
      "SELECT * FROM reports where proj_id = $1",
      [proj_id]
    );
    res.json(reports.rows);
  } catch (err) {
    console.error(err);
  }
});

// get project details
app.get("/:proj_id/getdetails", async (req, res) => {
  const proj_id = req.params.proj_id;
  try {
    const proj_details = await pool.query(
      "SELECT * FROM projects where proj_id = $1",
      [proj_id]
    );
    const users_working = await pool.query(
      "SELECT * FROM users INNER JOIN works_on on works_on.learner_id = users.learner_id where works_on.proj_id = $1",
      [proj_id]
    );
    res.json({
      proj_details: proj_details.rows[0],
      users_working: users_working.rows,
    });
  } catch (err) {
    console.error(err);
  }
});

//get all users
app.get("/getusers", async (req, res) => {
  try {
    const users = await pool.query("SELECT * FROM users");
    res.json(users.rows);
  } catch (err) {
    console.error(err);
  }
});

//create a report
app.post("/createreport", async (req, res) => {
  const { report_title, proj_id, userContributes } = req.body;

  try {
    const q1 = await pool.query("CALL Report_Insert($1,$2)", [
      report_title,
      proj_id,
    ]);
    const q2 = await pool.query(
      "select report_id from reports where report_title = $1 and proj_id = $2",
      [report_title, proj_id]
    );
    const report_id = q2.rows[0].report_id;
    for (const user of userContributes) {
      const q3 = await pool.query("INSERT into contributes_to values($1,$2)", [
        user.value,
        report_id,
      ]);
    }

    res.json({ success: true, report_id: report_id });
  } catch (err) {
    console.error(err);
    res.json({ success: false });
  }
});

//edit a report
app.post("/createreport", async (req, res) => {
  const { report_title, proj_id, userContributes } = req.body;

  try {
    const q1 = await pool.query("CALL Report_Insert($1,$2)", [
      report_title,
      proj_id,
    ]);
    const q2 = await pool.query(
      "select report_id from reports where report_title = $1 and proj_id = $2",
      [report_title, proj_id]
    );
    const report_id = q2.rows[0].report_id;
    for (const user of userContributes) {
      const q3 = await pool.query("INSERT into contributes_to values($1,$2)", [
        user.value,
        report_id,
      ]);
    }

    res.json({ success: true , report_id});
  } catch (err) {
    console.error(err);
    res.json({ success: false });
  }
});

//get report details
app.get("/:report_id/getreportdetails", async (req, res) => {
  const report_id = parseInt(req.params.report_id);
  console.log(report_id);

  try {
    const query = await pool.query(
      "Select * from reports where report_id = $1",
      [report_id]
    );
    const data = await query.rows[0];

    const query2 = await pool.query(
      "SELECT * FROM users INNER JOIN contributes_to on contributes_to.learner_id = users.learner_id where contributes_to.report_id = $1",
      [report_id]
    );
    const data2 = await query2.rows;

    const query3 = await pool.query(
      "Select * from comments where report_id = $1 ",
      [report_id]
    );
    const data3 = await query3.rows;

    console.log(data);
    console.log(data2);

    res.json({
      report_details: data,
      users_contributing: data2,
      comments: data3,
    });
  } catch (err) {
    console.error(err);
  }
});

//add comment
// https://localhost:8000/addcomment
app.post("/addcomment", async (req, res) => {
  const { report_id, learner_id, comment } = req.body;

  try {
    // call Comment_Insert(comment_text,comment_by,report_id);

    const query = await pool.query("CALL Comment_Insert($1,$2,$3)", [
      comment,
      learner_id,
      report_id,
    ]);
    console.log(query);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.json({ success: false });
  }
});

//post report content
app.post("/postcontent", async (req, res) => {
  const { report_id, content } = req.body;

  try {
    const query = await pool.query(
      "UPDATE reports SET content=$1 where report_id=$2",
      [content, report_id]
    );
    console.log(query);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.json({ success: false });
  }
});

//delete project
app.delete("/deleteproject/:proj_id", async (req, res) => {
  const proj_id = parseInt(req.params.proj_id);
  try {

    const q = await pool.query(
      "call Project_delete($1)",[proj_id]
    );

    res.json({ success: true });
    
  } catch (err) {
    console.error(err);

    res.json({ success: false });
  }

})





app.listen(PORT, () => {
  console.log(`server has started on port ${PORT}`);
});
