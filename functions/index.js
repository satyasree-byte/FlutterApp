// functions/index.js
import { defineSecret } from 'firebase-functions/params';
import { onRequest } from 'firebase-functions/v2/https';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import nodemailer from 'nodemailer';

// Initialize Firebase Admin SDK
initializeApp();
const db = getFirestore();

// Define your secrets
const emailUser = defineSecret('EMAIL_USER');
const emailPass = defineSecret('EMAIL_PASS');

// ========== 1. SAVE BOOKING TO FIRESTORE ==========
export const saveBooking = onRequest(
  {
    timeoutSeconds: 30,
    memory: '256MiB',
    region: 'us-central1'
  },
  async (req, res) => {
    // ✅ CORS HEADERS
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    
    // ✅ HANDLE PREFLIGHT
    if (req.method === 'OPTIONS') {
      return res.status(200).send('');
    }
    
    if (req.method !== 'POST') {
      return res.status(405).json({ error: 'Method not allowed' });
    }
    
    try {
      const {
        name,
        phone,
        email = '',
        userType = 'General',
        requirement,
        bookingMethod = 'whatsapp',
        amount = 699
      } = req.body;
      
      // Validation
      if (!name?.trim() || !phone?.trim() || !requirement?.trim()) {
        return res.status(400).json({
          error: 'Missing required fields',
          requiredFields: ['name', 'phone', 'requirement']
        });
      }

      // Generate booking ID
      const timestamp = Date.now();
      const randomSuffix = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
      const bookingId = `EDV${timestamp}${randomSuffix}`;

      // Booking data
      const bookingData = {
        id: bookingId,
        name: name.trim(),
        phone: phone.trim(),
        email: email?.trim() || null,
        userType: userType,
        requirement: requirement.trim(),
        bookingMethod: bookingMethod,
        amount: parseFloat(amount),
        status: 'pending',
        whatsappSent: bookingMethod === 'whatsapp',
        emailSent: bookingMethod === 'email',
        paymentStatus: 'pending',
        createdAt: new Date().toISOString(),
        timestamp: new Date()
      };

      // Save to Firestore
      await db.collection('bookings').doc(bookingId).set(bookingData);

      console.log(`✅ Booking saved: ${bookingId}`);

      // Return success
      return res.status(200).json({
        success: true,
        bookingId: bookingId,
        message: 'Booking saved successfully'
      });

    } catch (error) {
      console.error('❌ Save booking error:', error);
      return res.status(500).json({
        success: false,
        error: error.message
      });
    }
  }
);

// functions/index.js - sendEmail function
export const sendEmail = onRequest(
  { 
    timeoutSeconds: 30,
    memory: '256MiB',
    region: 'us-central1',
    secrets: [emailUser, emailPass]
  }, 
  async (req, res) => {
    // CORS headers
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    
    if (req.method === 'OPTIONS') {
      return res.status(200).send('');
    }

    try {
      const { name, phoneNumber, message, email, category, booking_reference } = req.body;
      
      console.log('📧 Sending email from/to consulting@eduvise.ai');
      
      if (!name?.trim() || !phoneNumber?.trim() || !message?.trim()) {
        return res.status(400).json({ 
          error: 'Missing required fields'
        });
      }

      const userEmail = email || 'Not provided';
      const userCategory = category || 'General Inquiry';

      // Create transporter with your email provider
      const transporter = nodemailer.createTransport({
        // ⚠️ IMPORTANT: Use correct SMTP for your provider
        // For Gmail/Google Workspace:
        host: 'smtp.gmail.com',
        port: 587,
        secure: false,
        auth: {
          user: emailUser.value(),  // consulting@eduvise.ai
          pass: emailPass.value()   // App Password (NOT regular password)
        }
        
        // For Office365:
        // host: 'smtp.office365.com',
        // port: 587,
        // secure: false,
        
        // For privateemail.com:
        // host: 'mail.privateemail.com',
        // port: 465,
        // secure: true,
      });

      // ✅ SOLUTION 2: Send with BCC to self
      await transporter.sendMail({
        from: '"Eduvise.ai Website" <consulting@eduvise.ai>',
        
        // Send TO a different address or leave empty
        to: 'consulting@eduvise.ai',  // Or leave as consulting@eduvise.ai
        
        // ✅ BCC to the same address (works better)
        bcc: 'consulting@eduvise.ai',
        
        // ✅ Or use CC instead
        // cc: 'consulting@eduvise.ai',
        
        replyTo: userEmail !== 'Not provided' ? userEmail : 'consulting@eduvise.ai',
        
        subject: `📋 New Consultation: ${userCategory} - ${booking_reference || 'New'}`,
        
        text: `
          NEW CONSULTATION REQUEST
          ========================
          Reference: ${booking_reference || 'Not provided'}
          Name: ${name}
          Email: ${userEmail}
          Phone: ${phoneNumber}
          Category: ${userCategory}
          
          Message:
          ${message}
          
          ---
          Sent via Eduvise.ai Website Form
          Time: ${new Date().toLocaleString()}
        `,
        
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px;">
            <h2 style="color: #2C3E50;">📋 NEW CONSULTATION REQUEST</h2>
            <hr style="border: 1px solid #eee;">
            
            <div style="background: #f8f9fa; padding: 15px; border-radius: 5px;">
              <p><strong>🔢 Reference:</strong> ${booking_reference || 'Not provided'}</p>
              <p><strong>👤 Name:</strong> ${name}</p>
              <p><strong>📧 Email:</strong> ${userEmail}</p>
              <p><strong>📞 Phone:</strong> ${phoneNumber}</p>
              <p><strong>🎓 Category:</strong> ${userCategory}</p>
            </div>
            
            <div style="background: #fff3cd; padding: 15px; border-radius: 5px; margin: 15px 0;">
              <p><strong>📝 Requirement:</strong></p>
              <p>${message.replace(/\n/g, '<br>')}</p>
            </div>
            
            <hr style="border: 1px solid #eee;">
            <p style="color: #666; font-size: 12px;">
              ⏰ Sent: ${new Date().toLocaleString()}<br>
              📍 Source: Eduvise.ai Website Booking Form
            </p>
          </div>
        `
      });

      console.log('✅ Email sent successfully (BCC to self)');
      
      return res.status(200).json({ 
        success: true,
        message: 'Email sent successfully',
        bookingReference: booking_reference
      });

    } catch (error) {
      console.error('❌ Email error:', error);
      
      // If it's authentication error, check credentials
      if (error.message.includes('535') || error.message.includes('authentication')) {
        console.log('⚠️ SMTP Authentication failed. Check:');
        console.log('1. Email credentials in Firebase Secrets');
        console.log('2. Use App Password for Gmail, not regular password');
        console.log('3. SMTP server settings');
      }
      
      return res.status(500).json({
        error: 'Internal server error',
        detail: error.message
      });
    }
  }
);

// ========== 3. GET BOOKING DETAILS ==========
export const getBooking = onRequest(
  {
    timeoutSeconds: 30,
    memory: '256MiB',
    region: 'us-central1'
  },
  async (req, res) => {
    // ✅ CORS HEADERS
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    
    if (req.method === 'OPTIONS') {
      return res.status(200).send('');
    }
    
    try {
      const { bookingId } = req.query;
      
      if (!bookingId) {
        return res.status(400).json({ error: 'Booking ID required' });
      }

      const doc = await db.collection('bookings').doc(bookingId).get();
      
      if (!doc.exists) {
        return res.status(404).json({ error: 'Booking not found' });
      }

      return res.status(200).json({
        success: true,
        booking: doc.data()
      });

    } catch (error) {
      return res.status(500).json({ error: error.message });
    }
  }
);

// ========== 4. AUTO CONFIRMATION EMAIL ==========
export const sendBookingConfirmation = onDocumentCreated(
  'bookings/{bookingId}',
  async (event) => {
    try {
      const bookingData = event.data.data();
      
      if (bookingData.bookingMethod === 'email' && bookingData.email) {
        const transporter = nodemailer.createTransport({
          host: 'mail.privateemail.com',
          port: 465,
          secure: true,
          auth: {
            user: emailUser.value(),
            pass: emailPass.value()
          }
        });

        await transporter.sendMail({
          from: '"Eduvise.ai" <consulting@eduvise.ai>',
          to: bookingData.email,
          subject: `Booking Confirmation #${bookingData.id}`,
          html: `
            <div style="font-family: Arial, sans-serif;">
              <h2>Thank You for Your Booking!</h2>
              <p>Dear ${bookingData.name},</p>
              <p>We have received your booking request.</p>
              
              <div style="background: #f8f9fa; padding: 15px;">
                <h3>Booking Details:</h3>
                <p><strong>Booking ID:</strong> ${bookingData.id}</p>
                <p><strong>Name:</strong> ${bookingData.name}</p>
                <p><strong>Phone:</strong> ${bookingData.phone}</p>
                <p><strong>Service:</strong> ₹${bookingData.amount} Consultation</p>
              </div>
              
              <p>We will contact you within 24 hours.</p>
              
              <p>Best regards,<br>
              Eduvise.ai Team</p>
            </div>
          `
        });

        console.log(`✅ Confirmation email sent: ${bookingData.id}`);
      }

    } catch (error) {
      console.error('Confirmation email error:', error);
    }
  }
);