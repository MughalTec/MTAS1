const express = require('express');
const router = express.Router();
const pool = require('../db');

// ✅ GET PROVIDER BY SLUG
router.get('/:slug', async (req, res) => {
  try {
    const { slug } = req.params;

    const result = await pool.query(
      `SELECT *
       FROM mtas."tbl_provider"
       WHERE booking_page_slug = $1
       AND is_active = true
       LIMIT 1`,
      [slug]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Provider not found"
      });
    }

    res.json({
      success: true,
      data: result.rows[0]
    });

  } catch (err) {
    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});

module.exports = router;