const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');
const app = express();

// Middleware to parse JSON and enable CORS
app.use(cors());
app.use(express.json());

// Configure Nodemailer with Namecheap PrivateEmail SMTP
const transporter = nodemailer.createTransport({
  host: 'mail.privateemail.com', // Namecheap's outgoing server
  port: 465, // Use 465 for SSL or 587 for TLS/STARTTLS
  secure: true, // true for 465, false for other ports
  auth: {
    user: process.env.EMAIL_USER, // Your Namecheap PrivateEmail address
    pass: process.env.EMAIL_PASSWORD, // Your Namecheap PrivateEmail password
  },
});

// Endpoint to handle form submission
app.post('/send-email', (req, res) => {
  const { name, email, phoneNumber, category, message } = req.body;

  // Plain text email body
  const emailBody = `
    ==============================
    New Consultation Request
    ==============================

    **Name:** ${name}
    **Email:** ${email}
    **Phone:** ${phoneNumber}
    **Category:** ${category}

    ------------------------------
    **Message:**
    ${message}
    ------------------------------

    ---
    This is an automated email. Please do not reply directly to this message.
  `;

  // Email options
  const mailOptions = {
    from: `"${name}" <consultation@eduvise.ai>`, // Sender (customer's email)
    to: 'consultation@eduvise.ai', // Your email address
    replyTo: email, // Customer's email for replies
    subject: `New Consultation Request: ${category}`,
    text: emailBody, // Plain text email body
  };

  // Send email
  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error('Error sending email:', error);
      res.status(500).json({ message: 'Failed to send email' });
    } else {
      console.log('Email sent:', info.response);
      res.status(200).json({ message: 'Email sent successfully' });
    }
  });
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});