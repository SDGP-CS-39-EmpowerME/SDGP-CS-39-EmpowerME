const express = require('express');
const { google } = require('googleapis');
const multer = require('multer');
const fs = require('fs');
const cors = require('cors');
const cron = require('node-cron');

const app = express();
const PORT = 3000;
const REDIRECT_URI = 'https://3582-45-121-90-169.ngrok-free.app/oauth2callback';
const SCOPES = ['https://www.googleapis.com/auth/drive'];

const oauth2Client = new google.auth.OAuth2(
    '800910222707-27hmuoopb6ri9oin95erm4da9qmbva7u.apps.googleusercontent.com',
    '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',
    REDIRECT_URI
);

const drive = google.drive({ version: 'v3', auth: oauth2Client });

app.use(cors());
app.use(express.json()); 

const upload = multer({ dest: 'uploads/' });

let recordingsFolderId = null;
let uploadedFiles = [];

async function getOrCreateFolder(folderName) {
    try {
        const response = await drive.files.list({
            q: `mimeType='application/vnd.google-apps.folder' and name='${folderName}'`,
            fields: 'files(id)'
        });

        if (response.data.files.length > 0) {
            return response.data.files[0].id;
        } else {
            const res = await drive.files.create({
                requestBody: {
                    name: folderName,
                    mimeType: 'application/vnd.google-apps.folder'
                }
            });
            return res.data.id;
        }
    } catch (error) {
        console.error('Error getting or creating folder:', error);
        throw error;
    }
}

async function saveFileToFolder(file, folderId) {
    try {

        const metadata = {
            name: file.name,
            mimeType: file.mimeType,
            parents: [folderId]
        };

        const fileStream = fs.createReadStream(file.path);
        const response = await drive.files.create({
            requestBody: metadata,
            media: {
                mimeType: file.mimeType,
                body: fileStream,
            },
        });

        console.log('File uploaded successfully:', response.data);

        uploadedFiles.push(file.name);

        return response.data;
    } catch (error) {
        console.error('Error uploading file:', error);
        throw error;
    }
}

async function saveFilesToFolder(folderId) {
    const folderPath = './DriveUpload'; // Adjust the folder path 
    const files = fs.readdirSync(folderPath);
    for (const fileName of files) {
        if (!uploadedFiles.includes(fileName)) {
            const filePath = `${folderPath}/${fileName}`;
            const fileStats = fs.statSync(filePath);
            if (fileStats.isFile()) {
                const mimeType = 'application/octet-stream'; // Adjust the MIME type 
                const file = {
                    name: fileName,
                    mimeType: mimeType,
                    path: filePath,
                };
                await saveFileToFolder(file, folderId);
            }
        }
    }
}

let isUploadEnabled = true; // Flag to control upload process

cron.schedule('* * * * *', async () => {
    console.log('Checking for new files...');
    if (!recordingsFolderId || !isUploadEnabled) {
        return; // Stop upload if folder is not ready or upload is disabled
    }
    await saveFilesToFolder(recordingsFolderId);
});

app.post('/toggleUpload', (req, res) => {
    isUploadEnabled = req.body.enable === 'true'; // Update the flag based on the request
    res.status(200).send(`Upload process is now ${isUploadEnabled ? 'enabled' : 'disabled'}`);
});



app.post('/upload', upload.single('file'), async (req, res) => {
    try {
        const file = req.file;
        console.log(file.name);

        if (file.name == undefined) {
            // Generating new file name based on date, time, and location
            file.name = file.originalname;
        }

        if (!file) {
            return res.status(400).send('No file uploaded');
        }

        if (!recordingsFolderId) {
            recordingsFolderId = await getOrCreateFolder('My Recordings');
        }

        await saveFileToFolder(file, recordingsFolderId);

        res.status(200).send('File uploaded successfully');
    } catch (error) {
        console.error('Error uploading file:', error);
        res.status(500).send('Error uploading file');
    }
});

app.get('/', async (req, res) => {
    const authUrl = oauth2Client.generateAuthUrl({
        access_type: 'offline',
        scope: SCOPES,
    });
    res.json({ authUrl: authUrl });
});

app.get('/oauth2callback', async (req, res) => {
    const code = req.query.code;
    try {
        const { tokens } = await oauth2Client.getToken(code);
        oauth2Client.setCredentials(tokens);

        if (!recordingsFolderId) {
            recordingsFolderId = await getOrCreateFolder('My Recordings');
        }

        await saveFilesToFolder(recordingsFolderId);

        res.json(tokens);
    } catch (error) {
        console.error('Error exchanging code for tokens:', error);
        res.status(500).json({ error: 'Failed to authenticate' });
    }
});

app.listen(PORT, async () => {
    console.log(`Server is running on https://3582-45-121-90-169.ngrok-free.app`);
});
