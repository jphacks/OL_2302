/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.helloWorld = onRequest((request, response) => {
    logger.info("Hello logs!", {structuredData: true});
    response.send("Hello from Firebase!");
});

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.scheduledFunction = functions.pubsub.schedule('every 24 hours').onRun((context) => {
    // Firestoreの更新処理
    const firestore = admin.firestore();
    const pillCounter = firestore.collection('yourCollection').doc('yourDoc').get().then(doc => {
    return firestore.collection('yourCollection').doc('yourDoc').update({
        pillCounter: pillCounter+1,
    });
    }).catch(err => {
        console.log(err);
    });
});

// exports.testFunction = functions.https.onRequest((request, response) => {
//     const firestore = admin.firestore();
//     const pillCounter = firestore.collection('yourCollection').doc('yourDoc').get().then(doc => {
//     return firestore.collection('yourCollection').doc('yourDoc').update({
//         pillCounter: pillCounter+1,
//     });
//     }).catch(err => {
//         console.log(err);
//     });
//     response.send("Function executed!");
// });

