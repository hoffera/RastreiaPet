const functions = require("firebase-functions");
const admin = require("firebase-admin");
const mqtt = require("mqtt");

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

// Configuração do cliente MQTT sem username e password
const mqttClient = mqtt.connect("mqtts://f21298fae87f4c46b7de1324b32c4669.s1.eu.hivemq.cloud:8883");

mqttClient.on("connect", () => {
  console.log("Conectado ao broker MQTT");
  mqttClient.subscribe("pets/#", (err) => {
    if (!err) {
      console.log("Inscrito no tópico 'pets/#'");
    } else {
      console.error("Erro ao se inscrever no tópico:", err);
    }
  });
});

// Manipulador para mensagens recebidas do MQTT
mqttClient.on("message", async (topic, message) => {
  try {
    const data = JSON.parse(message.toString());
    const userId = data.userId; // Exemplo de como obter o userId da mensagem
    const petData = {
      nome: data.nome,
    };

    // Envia os dados para o Firestore
    await admin.firestore().collection("pets").doc(userId).set(petData, { merge: true });
    console.log("Dados enviados para o Firestore:", petData);
    
  } catch (error) {
    console.error("Erro ao processar mensagem MQTT:", error);
  }
});
