// functions/index.js
import { defineString, defineSecret } from 'firebase-functions/params';
import { onRequest } from 'firebase-functions/v2/https';
import nodemailer from 'nodemailer';
import cors from 'cors';

// Configure CORS for production and development
const allowedOrigins = [
  'https://eduvise.ai',
  'http://localhost:*',
  'https://eduviseai.web.app'
];

const corsHandler = cors({
  origin: (origin, callback) => {
     // Allow requests with no origin (like mobile apps or curl requests)
     if (!origin) return callback(null, true);
    
     // Allow all localhost and 127.0.0.1 ports
     if (
       origin.startsWith('http://localhost:') || 
       origin.startsWith('http://127.0.0.1:') ||
       allowedOrigins.includes(origin)
     ) {
       return callback(null, true);
     }
     
     callback(new Error('Not allowed by CORS'));
   },
  methods: ['POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type']
});

// Environment configuration
const emailUser = defineSecret('EMAIL_USER');
const emailPass = defineSecret('EMAIL_PASS');

export const sendEmail = onRequest(
  { 
    secrets: [emailUser, emailPass], 
    timeoutSeconds: 30,
    memory: '256MiB',
    region: 'us-central1'
  }, 
  async (req, res) => {
    // Create transporter INSIDE handler function
    const transporter = nodemailer.createTransport({
      host: 'mail.privateemail.com',
      port: 465,
      secure: true,
      auth: {
        user: emailUser.value(),
        pass: emailPass.value()
      }
    });
    console.log('emailUser:', emailUser.value());
    console.log('emailPass:', emailPass.value());
    // Handle CORS preflight
    if (req.method === 'OPTIONS') {
      return res.status(204).send('');
    }

    corsHandler(req, res, async () => {
      try {
        // Validate request method
        if (req.method !== 'POST') {
          return res.status(403).json({ 
            error: 'Only POST requests are allowed',
            allowedMethods: ['POST']
          });
        }

        // Validate required fields
        const { name, phoneNumber, message } = req.body;
        if (!name?.trim() || !phoneNumber?.trim() || !message?.trim()) {
          return res.status(400).json({ 
            error: 'Missing required fields',
            requiredFields: ['name', 'phoneNumber', 'message'],
            optionalFields: ['email', 'category']
          });
        }

        // Extract optional fields
        const email = req.body.email || 'Not provided';
        const category = req.body.category || 'General Inquiry';

        // Send email
        await transporter.sendMail({
          from: `"${name}" <consultation@eduvise.ai>`,
          to: 'consultation@eduvise.ai',
          replyTo: email !== 'Not provided' ? email : undefined, // Only set replyTo if email was provided
          subject: `New Contact Request: ${category}`,
          text: [
            `Name: ${name}`,
            `Email: ${email}`, // Will show "Not provided" if empty
            `Phone: ${phoneNumber}`,
            `Category: ${category}`,
            `Message:\n${message}`
          ].join('\n\n'),
          html: `
            <h3>New Contact Request</h3>
            <p><strong>Name:</strong> ${name}</p>
            <p><strong>Email:</strong> ${email}</p>
            <p><strong>Phone:</strong> ${phoneNumber}</p>
            <p><strong>Category:</strong> ${category}</p>
            <p><strong>Message:</strong></p>
            <p>${message.replace(/\n/g, '<br>')}</p>
          `
        });

        return res.status(200).json({ 
          success: true,
          message: 'Email sent successfully'
        });

      } catch (error) {
        console.error('Email delivery failed:', error);
        return res.status(500).json({
          error: 'Internal server error',
          ...(process.env.NODE_ENV === 'development' && {
            detail: error.message,
            stack: error.stack
          })
        });
      }
    });
  }
);