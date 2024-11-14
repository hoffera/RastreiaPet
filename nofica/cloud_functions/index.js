const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

exports.notificacao = functions.firestore
  .document("location/{userid}")
  .onUpdate(async (change, context) => {
    const beforeData = change.before.exists ? change.before.data() : null;
    const afterData = change.after.exists ? change.after.data() : null;

    const userId = context.params.userid; // Obtém o ID do usuário do contexto

    try {
      // Verifica se as variáveis de localização estão presentes
      if (afterData.latitude && afterData.longitude) {
        // Obter localização atual do usuário
        const userLat = afterData.latitude;
        const userLon = afterData.longitude;

        // Recuperar dados do círculo 
        const alertDoc = await admin.firestore().collection("alerts").doc(userId).get();
        
        if (alertDoc.exists) {
          const alertData = alertDoc.data();
          const circleLat = alertData.latitude;
          const circleLon = alertData.longitude;
          const circleRadius = alertData.distancia; // Distância do raio do círculo

          // Calcula a distância entre o ponto atual e o centro do círculo
          const distance = getDistanceFromLatLonInMeters(userLat, userLon, circleLat, circleLon);

          console.log(`Distância do centro do círculo: ${distance} metros`);

          // Verifica se a distância é maior que o raio do círculo
          if (distance > circleRadius) {
            console.log("Usuário está fora do círculo. Enviando notificação...");

            // Recupera o token FCM do usuário
            const userDoc = await admin.firestore().collection("users").doc(userId).get();
            
            let token;
            if (userDoc.exists) {
              token = userDoc.data().fcmToken; // Obtém o token FCM se existir
            }

            // Cria a mensagem de notificação
            const message = {
              notification: {
                title: "ALERTA!!!",
                body: `Seu pet saiu círculo de segurança. Atual: ${distance.toFixed(2)} metros`,
              },
              token: token,
            };

            // Envia a notificação
            await admin.messaging().send(message);
            console.log("Successfully sent message:", message);
          } else {
            console.log("Usuário está dentro do círculo.");
          }
        } else {
          console.log("Nenhum Zona encontrada para o usuário.");
        }
      } else {
        console.log("Latitude ou longitude não estão presentes nos dados atuais.");
      }
    } catch (error) {
      console.error("Error processing notification:", error);
    }
  });

// Função para calcular a distância entre duas coordenadas geográficas em metros
function getDistanceFromLatLonInMeters(lat1, lon1, lat2, lon2) {
  const R = 6371000; // Raio da Terra em metros
  const dLat = deg2rad(lat2 - lat1);
  const dLon = deg2rad(lon2 - lon1);

  const a = 
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2); 

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)); 
  const distance = R * c; // Distância em metros

  return distance;
}

function deg2rad(deg) {
  return deg * (Math.PI / 180);
}
