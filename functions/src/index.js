const functions = require('firebase-functions');
const admin = require('firebase-admin');
const mqtt = require('mqtt');

admin.initializeApp();

const firestore = admin.firestore();

// Replace with your MQTT broker URL and credentials
const mqttBrokerUrl = 'mqtts://f21298fae87f4c46b7de1324b32c4669.s1.eu.hivemq.cloud:8883'; // URL do broker com TLS
const mqttUsername = ''; // Deixe vazio se não precisar de autenticação
const mqttPassword = ''; 

// Replace with your Firestore collection name
const firestoreCollectionName = 'mqtt_data';

// Create an MQTT client
const client = mqtt.connect(mqttBrokerUrl, {
  username: mqttUsername,
  password: mqttPassword,
});

// Listen for incoming MQTT messages
client.on('message', (topic, message) => {
  // Parse the message (assuming it's JSON)
  const data = JSON.parse(message.toString());

  // Add the data to Firestore
  firestore.collection("test").doc(userId).set(petData, { merge: true })
    .then(() => {
      console.log('Data successfully added to Firestore:', data);
    })
    .catch((error) => {
      console.error('Error adding data to Firestore:', error);
    });
});

// Export the Cloud Function
exports.mqttToFirestore = functions.https.onCall((data, context) => {
  // This function is not used in this example, but you can use it to trigger the MQTT connection
  // or perform other actions.
  console.log('MQTT to Firestore function triggered.');
  return null;
});