const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNotificationOnDistanceChange = functions.firestore
    .document('alerts/{userId}')
    .onUpdate((change, context) => {
        const newValue = change.after.data();
        const oldValue = change.before.data();

        // Verifica se a distância foi atualizada para 10
        if (newValue.distancia === 10 && oldValue.distancia !== 10) {
            const userId = context.params.userId;

            // Mensagem que você deseja enviar
            const message = {
                notification: {
                    title: 'Alerta de Distância',
                    body: `A distância do usuário ${userId} atingiu 10!`,
                },
                topic: userId, // ou use um token específico
            };

            // Enviar a notificação
            return admin.messaging().send(message)
                .then((response) => {
                    console.log('Notificação enviada:', response);
                })
                .catch((error) => {
                    console.error('Erro ao enviar a notificação:', error);
                });
        }

        return null; // Para indicar que a função completou
    });
