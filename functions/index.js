const {logger} = require("firebase-functions");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();

const ADMIN_UID = "RMhlAqRXFzLaaovOKstR3bEzYnC3";

exports.notifyAdminOnNewMessage = onDocumentCreated("messageTouch/{messageId}", async (event) => {
  const data = event.data.data();

  const messagePayload = {
    notification: {
      title: "📥 New Inquiry Received",
      body: `${data.from_name} sent a message: ${data.business_idea || "No idea text."}`,
    },
    data: {
      from_email: data.from_email || "",
      additional_notes: data.additional_notes || "",
    },
  };

  try {
    const adminDoc = await getFirestore().doc(`users/${ADMIN_UID}`).get();
    const tokens = adminDoc.data()?.tokens;

    if (!Array.isArray(tokens) || tokens.length === 0) {
      logger.warn("No valid FCM tokens found for the admin user.");
      return;
    }

    const response = await getMessaging().sendToDevice(tokens, messagePayload);

    const invalidTokens = [];
    response.results.forEach((result, index) => {
      const error = result.error;
      if (error && (
        error.code === "messaging/invalid-registration-token" ||
        error.code === "messaging/registration-token-not-registered"
      )) {
        invalidTokens.push(tokens[index]);
      }
    });

    if (invalidTokens.length > 0) {
      await getFirestore().doc(`users/${ADMIN_UID}`).update({
        tokens: FieldValue.arrayRemove(...invalidTokens),
      });
      logger.info("Removed invalid FCM tokens:", invalidTokens);
    }

  } catch (err) {
    logger.error("Error sending notification to admin:", err);
  }
});