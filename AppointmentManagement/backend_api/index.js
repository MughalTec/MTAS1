const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const providerRoutes = require('./routes/providers');
const serviceRoutes = require('./routes/services');
const bookingRoutes = require('./routes/bookings');

const app = express();

app.use(cors());
app.use(express.json());

// ================= ROUTES =================
app.use('/auth', authRoutes);
app.use('/providers', providerRoutes);
app.use('/services', serviceRoutes);
app.use('/bookings', bookingRoutes);

// ================= TEST =================
app.get('/', (req, res) => {
  res.send('API Running 🚀');
});

app.listen(4000, () => {
  console.log('Server running on port 4000');
});