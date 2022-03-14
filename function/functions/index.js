const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

var db = admin.firestore();
var fcm = admin.messaging();

exports.notifyNewMessage = functions.firestore
  .document("messages/{messageDocId}/{messageCollectioId}/{messageId}")
  .onCreate(async (snapshot) => {
    const message = snapshot.data();

    const querySnapShot = await db
      .collection("users")
      .doc(message.received_by)
      .get();

    const token = await querySnapShot.get("fcm_token");
    const userName = await querySnapShot.get("username");

    const payLoad = {
      notification: {
        title: `Love Me | ${userName}`,
        body: message.type == 2 ? "Image": message.message,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    return fcm.sendToDevice(token, payLoad);
  });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
