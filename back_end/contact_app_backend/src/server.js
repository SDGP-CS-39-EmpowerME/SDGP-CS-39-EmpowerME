const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');

const app = express();
const port = 3000;

const serviceAccount = require('./firebase-credentials.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Add a new contact
app.post('/addContact', async (req, res) => {
  try {
    const { name, number } = req.body;
    const newContact = { name, number };
    await db.collection('contacts').add(newContact);
    console.log('New contact added:', newContact);
    res.send('Contact added successfully');
  } catch (error) {
    console.error('Error adding contact:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Delete a contact
app.delete('/deleteContact/:name', async (req, res) => {
  try {
    const contactName = req.params.name;
    const snapshot = await db.collection('contacts').where('name', '==', contactName).get();
    snapshot.forEach(async (doc) => {
      await db.collection('contacts').doc(doc.id).delete();
    });
    console.log('Contact deleted:', contactName);
    res.send('Contact deleted successfully');
  } catch (error) {
    console.error('Error deleting contact:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Update a contact
app.put('/updateContact/:name', async (req, res) => {
  try {
    const oldName = req.params.name;
    const { newName, newNumber } = req.body;

    const snapshot = await db.collection('contacts').where('name', '==', oldName).get();
    snapshot.forEach(async (doc) => {
      await db.collection('contacts').doc(doc.id).update({ name: newName, number: newNumber });
    });

    console.log('Contact updated:', oldName, 'to', newName, newNumber);
    res.send('Contact updated successfully');
  } catch (error) {
    console.error('Error updating contact:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Get all contacts
app.get('/getContacts', async (req, res) => {
  try {
    const snapshot = await db.collection('contacts').get();
    const contacts = snapshot.docs.map(doc => doc.data());
    res.json(contacts);
  } catch (error) {
    console.error('Error fetching contacts:', error);
    res.status(500).send('Internal Server Error');
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});





