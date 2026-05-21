const express = require('express');
const router = express.Router();
const pool = require('../db');

// GET SERVICES BY PROVIDER
router.get('/providers/:providerId', async (req, res) => {
  try {
    const { providerId } = req.params;

    const result = await pool.query(
      `
      SELECT *
      FROM mtas."tbl_service"
      WHERE provider_id = $1
      AND is_active = true
      ORDER BY sort_order ASC
      `,
      [providerId]
    );

    res.json({
      success: true,
      data: result.rows
    });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;