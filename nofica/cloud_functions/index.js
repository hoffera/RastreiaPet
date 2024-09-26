const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

exports.notificacao = functions.firestore
  .document("pets/{userid}")
  .onUpdate(async (change, context) => {
    const beforeData = change.before.exists ? change.before.data() : null;
    const afterData = change.after.exists ? change.after.data() : null;

    // Verifica se a variável 'nome' foi alterada
    if (beforeData.nome !== afterData.nome) {
      try {
        const userId = context.params.userid; // Obtém o ID do usuário do contexto

        // Aqui você pode querer obter o token do Firestore
        const userDoc = await admin.firestore().collection("users").doc(userId).get();
        
        let token;
        if (userDoc.exists) {
          token = userDoc.data().fcmToken; // Obtém o token FCM se existir
        }

        // Se o token não existir, salve-o
        if (!token) {
          // Supondo que você tenha um método para obter o token do cliente
          // Aqui, você pode implementar a lógica para salvar um novo token
          // Para exemplo, vamos usar um valor fixo
          token = "NEW_FCM_TOKEN"; // Você precisa substituir isso pelo token real do cliente

          // Salvar o token no Firestore
          await admin.firestore().collection("users").doc(userId).set({
            fcmToken: token,
          }, { merge: true });
        }

        // Cria a mensagem de notificação
        const message = {
          notification: {
            title: "Pet Name Changed", // Personalize conforme necessário
            body: `The pet's name has been changed to ${afterData.nome}`, // Personalize conforme necessário
          },
          token: token,
        };

        // Envia a notificação
        await admin.messaging().send(message);
        console.log("Successfully sent message:", message);
        
      } catch (error) {
        console.error("Error sending notifications:", error);
      }
    } else {
      console.log("Nenhuma alteração no nome");
    }
  });
