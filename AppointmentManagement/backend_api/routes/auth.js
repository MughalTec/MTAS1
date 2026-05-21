const express = require('express');
const router = express.Router();

const pool = require('../db');


// =====================================
// GOOGLE LOGIN
// =====================================

router.post('/google', async (req, res) => {

  try {

    const {
      email,
      name,
      provider,
      provider_id
    } = req.body;

    // VALIDATION
    if (!email || !provider_id) {

      return res.status(400).json({
        success: false,
        message: "Missing required fields"
      });
    }

    // =====================================
    // CHECK USER
    // =====================================

    const userCheck = await pool.query(
      `SELECT *
       FROM mtas."tblLoginUser"
       WHERE "Provider_ID" = $1`,
      [provider_id]
    );

    // =====================================
    // EXISTING USER
    // =====================================

    if (userCheck.rows.length > 0) {

      const updatedUser = await pool.query(
        `UPDATE mtas."tblLoginUser"
         SET
         "Last_Login" = NOW(),
         "Email" = $1,
         "Name" = $2
         WHERE "Provider_ID" = $3
         RETURNING *`,
        [
          email,
          name,
          provider_id
        ]
      );

      console.log(updatedUser.rows[0]);

      return res.json({
        success: true,
        isNewUser: false,
        isProfileCompleted:
        updatedUser.rows[0]["isProfileCompleted"] ??
        updatedUser.rows[0]["IsProfileCompleted"] ??
        false,  
        user: updatedUser.rows[0]
      });
    }

    // =====================================
    // NEW USER
    // =====================================

    const newUser = await pool.query(
      `INSERT INTO mtas."tblLoginUser"
      (
        "Email",
        "Name",
        "Provider",
        "Provider_ID",
        "Created_At",
        "Active",
        "Last_Login",
        "IsProfileCompleted"
      )
      VALUES
      (
        $1,
        $2,
        $3,
        $4,
        NOW(),
        true,
        NOW(),
        false
      )
      RETURNING *`,
      [
        email,
        name,
        provider,
        provider_id
      ]
    );

    console.log(newUser.rows[0]);

    return res.json({
      success: true,
      isNewUser: true,
      isProfileCompleted: false,
      user: newUser.rows[0]
    });

  } catch (err) {

    console.log(err);

    return res.status(500).json({
      success: false,
      message: "Server Error",
      error: err.message
    });
  }
});


// =====================================
// SAVE COMPANY DETAILS
// =====================================

router.post('/company-details', async (req, res) => {

  try {

    const {
      provider_id,
      companyName,
      billingAddress,
      city,
      state,
      zipCode,
      country
    } = req.body;

    // VALIDATION
    if (!provider_id) {

      return res.status(400).json({
        success: false,
        message: "Provider ID missing"
      });
    }

    // =====================================
    // FIND USER
    // =====================================

    const user = await pool.query(
      `SELECT *
       FROM mtas."tblLoginUser"
       WHERE "Provider_ID" = $1`,
      [provider_id]
    );

    if (user.rows.length === 0) {

      return res.status(404).json({
        success: false,
        message: "User not found"
      });
    }

    // =====================================
    // INSERT COMPANY
    // =====================================

    await pool.query(
      `INSERT INTO mtas."tblCompany"
      (
        "CompanyName",
        "BillingAddress",
        "City",
        "State",
        "ZipCode",
        "Country"
      )
      VALUES
      (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6
      )`,
      [
        companyName,
        billingAddress,
        city,
        state,
        zipCode,
        country
      ]
    );


//     app.get('/bookings', async (req, res) => {
//   try {
//     const result = await pool.query(`
//       SELECT "ID", "Booking_Date", "Start_Time", "End_Time", "Status",
//              "Notes", "Created_At", "Client_ID", "Service_ID", "Staff_ID"
//       FROM mtas."tblBooking"
//       ORDER BY "ID" DESC
//     `);

//     res.json(result.rows);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: "Server Error" });
//   }
// });



    // =====================================
    // UPDATE PROFILE STATUS
    // =====================================

    await pool.query(
      `UPDATE mtas."tblLoginUser"
       SET "IsProfileCompleted" = true
       WHERE "Provider_ID" = $1`,
      [provider_id]
    );

    return res.json({
      success: true,
      message: "Profile completed successfully"
    });

  } catch (err) {

    console.log(err);

    return res.status(500).json({
      success: false,
      error: err.message
    });
  }
});

module.exports = router;

