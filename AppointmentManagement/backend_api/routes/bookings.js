const express = require('express');
const router = express.Router();
const pool = require('../db');


// ================================
// GET BOOKINGS
// ================================
router.get('/', async (req, res) => {

  try {

    const result = await pool.query(`
      SELECT *
      FROM mtas.tbl_booking
      ORDER BY start_time ASC
    `);

    res.json(result.rows);

  } catch (err) {

    console.log(err);

    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});


// ================================
// CREATE BOOKING (SAFE)
// ================================
router.post('/', async (req, res) => {

  try {

    let {
      provider_id,
      service_id,
      service_name,
      service_duration_minutes,
      service_price,
      client_name,
      client_email,
      client_phone,
      client_notes,
      start_time,
      end_time,
      status
    } = req.body;

    // ============================
    // VALIDATION (IMPORTANT)
    // ============================
    if (!provider_id || provider_id === "null") {
      return res.status(400).json({
        success: false,
        message: "provider_id missing or null"
      });
    }

    if (!service_id || service_id.toString().trim().isEmpty) {
      return res.status(400).json({
        success: false,
        message: "service_id missing or null"
      });
    }

    // ============================
    // INSERT BOOKING
    // ============================
    const result = await pool.query(`
      INSERT INTO mtas.tbl_booking
      (
        provider_id,
        service_id,
        service_name,
        service_duration_minutes,
        service_price,
        client_name,
        client_email,
        client_phone,
        client_notes,
        start_time,
        end_time,
        status,
        created_at
      )
      VALUES
      ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,NOW())
      RETURNING *
    `, [
      provider_id,
      service_id,
      service_name,
      service_duration_minutes,
      service_price,
      client_name,
      client_email,
      client_phone,
      client_notes,
      start_time,
      end_time,
      status
    ]);

    res.json({
      success: true,
      booking: result.rows[0]
    });

  } catch (err) {

    console.log(err);

    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});


// ================================
// CLIENT LIST
// ================================
router.get('/clients', async (req, res) => {

  try {

    const result = await pool.query(`
      SELECT *
      FROM mtas."tblClient"
      ORDER BY "First_Name"
    `);

    res.json(result.rows);

  } catch (err) {

    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});


// ================================
// CREATE CLIENT
// ================================
router.post('/create-client', async (req, res) => {

  try {

    const {
      firstName,
      lastName,
      email,
      phone
    } = req.body;

    const result = await pool.query(`
      INSERT INTO mtas."tblClient"
      (
        "First_Name",
        "Last_Name",
        "Email",
        "Phone",
        "Created_At"
      )
      VALUES ($1,$2,$3,$4,NOW())
      RETURNING "ID"
    `, [
      firstName,
      lastName,
      email,
      phone
    ]);

    res.json({
      success: true,
      clientId: result.rows[0].ID
    });

  } catch (err) {

    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});

module.exports = router;




