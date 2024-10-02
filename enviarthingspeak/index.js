const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();

// Function to fetch and store data from ThingSpeak
async function syncThingSpeakData() {
  const url = 'https://api.thingspeak.com/channels/2293050/feeds.json?results=1&api_key=SEAMNK2RIVQJ6BT7';

  try {
    const response = await axios.get(url);
    const data = response.data.feeds[0];

    if (data) {
      // Get the timestamp of the last record sent
      const lastTimestamp = await getLastTimestamp();

      // Check if the received data is newer than the last sent
      if (!lastTimestamp || new Date(data.created_at) > new Date(lastTimestamp)) {
        // Structure of the document in Firestore
        const docData = {
          created_at: data.created_at,
          field1: data.field1, // Change according to your needs
          field2: data.field2, // Change according to your needs
          // Add more fields as needed
        };

        // Send data to Firestore
        await admin.firestore().collection('test').doc('fogo').add(docData);
        console.log('Data sent to Firestore:', docData);
      } else {
        console.log('No new data to send from ThingSpeak.');
      }
    } else {
      console.log('No data received from ThingSpeak.');
    }
  } catch (error) {
    console.error('Error fetching data from ThingSpeak:', error);
  }
}

// Function to get the timestamp of the last record sent
async function getLastTimestamp() {
  const snapshot = await admin.firestore().collection('test').doc('fogo').orderBy('created_at', 'desc').limit(1).get();
  if (!snapshot.empty) {
    return snapshot.docs[0].data().created_at;
  }
  return null; // No data sent previously
}

// Function to update the next execution time in the database
async function updateNextExecutionTime() {
  const nextExecutionTime = new Date(Date.now() + 10000); // 10 seconds from now
  await admin.firestore().collection('scheduler').doc('thingspeak').set({
    nextExecutionTime: nextExecutionTime.toISOString(),
  });
}

// Cloud Function triggered by a Pub/Sub message
exports.syncThingSpeakDataTrigger = functions.pubsub.topic('thingspeak-scheduler').onPublish(async (message) => {
  await syncThingSpeakData();
  await updateNextExecutionTime();
});

// Cloud Function to initialize the scheduler
exports.initializeThingSpeakScheduler = functions.https.onRequest(async (req, res) => {
  await updateNextExecutionTime();
  res.send('Scheduler initialized');
});
