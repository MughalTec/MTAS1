const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// routes
const providersRoutes = require('./routes/providers');
const serviceRoutes = require('./routes/services');
const bookingRoutes = require('./routes/bookings');
const authRoutes = require('./routes/auth');

app.use('/providers', providersRoutes);
app.use('/services', serviceRoutes);
app.use('/bookings', bookingRoutes);
app.use('/auth', authRoutes);

app.listen(4000, () => {
  console.log('Server running on port 4000');
});