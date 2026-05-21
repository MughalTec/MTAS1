exports.socialLogin = async (req, res) => {

  try {

    console.log(req.body);

    res.json({
      success: true,
      message: 'Social login working'
    });

  } catch (err) {

    res.status(500).json({
      success: false,
      error: err.message
    });

  }

};