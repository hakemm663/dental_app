const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {RtcTokenBuilder, RtcRole} = require("agora-token");
const fetch = require("node-fetch");

admin.initializeApp();

const APP_ID = process.env.AGORA_APP_ID;
const APP_CERTIFICATE = process.env.AGORA_APP_CERTIFICATE;
const CUSTOMER_ID = process.env.AGORA_CUSTOMER_ID;
const CUSTOMER_SECRET = process.env.AGORA_CUSTOMER_SECRET;

const AGORA_BASE_URL = "https://api.agora.io/v1/apps";

function getBasicAuth() {
  const credentials = Buffer.from(`${CUSTOMER_ID}:${CUSTOMER_SECRET}`).toString("base64");
  return `Basic ${credentials}`;
}

// ── Generate RTC Token ─────────────────────────────────────────────────────────

exports.generateToken = functions.https.onCall(async (data, context) => {

  const {channelName, uid, role} = data;
  if (!channelName) {
    throw new functions.https.HttpsError("invalid-argument", "channelName is required");
  }

  const tokenRole = role === "subscriber" ? RtcRole.SUBSCRIBER : RtcRole.PUBLISHER;
  const uidNum = uid || 0;
  const expireTime = 3600;

  const token = RtcTokenBuilder.buildTokenWithUid(
      APP_ID,
      APP_CERTIFICATE,
      channelName,
      uidNum,
      tokenRole,
      expireTime,
      expireTime,
  );

  return {token, uid: uidNum};
});

// ── Cloud Recording: Acquire ───────────────────────────────────────────────────

exports.acquireRecording = functions.https.onCall(async (data, context) => {

  const {channelName, uid} = data;
  if (!channelName || uid === undefined) {
    throw new functions.https.HttpsError("invalid-argument", "channelName and uid are required");
  }

  const response = await fetch(
      `${AGORA_BASE_URL}/${APP_ID}/cloud_recording/acquire`,
      {
        method: "POST",
        headers: {
          "Authorization": getBasicAuth(),
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          cname: channelName,
          uid: String(uid),
          clientRequest: {
            resourceExpiredHour: 24,
          },
        }),
      },
  );

  const result = await response.json();
  if (!response.ok) {
    throw new functions.https.HttpsError("internal", JSON.stringify(result));
  }

  return result;
});

// ── Cloud Recording: Start ─────────────────────────────────────────────────────

exports.startRecording = functions.https.onCall(async (data, context) => {

  const {channelName, uid, resourceId, storageConfig} = data;
  if (!channelName || uid === undefined || !resourceId) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "channelName, uid, and resourceId are required",
    );
  }

  if (!storageConfig || !storageConfig.accessKey || !storageConfig.secretKey) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "storageConfig with valid accessKey and secretKey is required",
    );
  }

  const token = RtcTokenBuilder.buildTokenWithUid(
      APP_ID,
      APP_CERTIFICATE,
      channelName,
      uid,
      RtcRole.SUBSCRIBER,
      3600,
      3600,
  );

  const mode = "mix";

  const requestBody = {
    cname: channelName,
    uid: String(uid),
    clientRequest: {
      token: token,
      recordingConfig: {
        channelType: 0,
        streamTypes: 2,
        maxIdleTime: 120,
        audioProfile: 1,
        transcodingConfig: {
          width: 640,
          height: 480,
          fps: 15,
          bitrate: 500,
          mixedVideoLayout: 1,
        },
      },
      storageConfig: storageConfig,
    },
  };

  const response = await fetch(
      `${AGORA_BASE_URL}/${APP_ID}/cloud_recording/resourceid/${resourceId}/mode/${mode}/start`,
      {
        method: "POST",
        headers: {
          "Authorization": getBasicAuth(),
          "Content-Type": "application/json",
        },
        body: JSON.stringify(requestBody),
      },
  );

  const result = await response.json();
  if (!response.ok) {
    throw new functions.https.HttpsError("internal", JSON.stringify(result));
  }

  return result;
});

// ── Cloud Recording: Stop ──────────────────────────────────────────────────────

exports.stopRecording = functions.https.onCall(async (data, context) => {

  const {channelName, uid, resourceId, sid} = data;
  if (!channelName || uid === undefined || !resourceId || !sid) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "channelName, uid, resourceId, and sid are required",
    );
  }

  const mode = "mix";

  const response = await fetch(
      `${AGORA_BASE_URL}/${APP_ID}/cloud_recording/resourceid/${resourceId}/sid/${sid}/mode/${mode}/stop`,
      {
        method: "POST",
        headers: {
          "Authorization": getBasicAuth(),
          "Content-Type": "application/json;charset=utf-8",
        },
        body: JSON.stringify({
          cname: channelName,
          uid: String(uid),
          clientRequest: {},
        }),
      },
  );

  const result = await response.json();
  if (!response.ok) {
    throw new functions.https.HttpsError("internal", JSON.stringify(result));
  }

  return result;
});

// ── Cloud Recording: Query ─────────────────────────────────────────────────────

exports.queryRecording = functions.https.onCall(async (data, context) => {

  const {resourceId, sid} = data;
  if (!resourceId || !sid) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "resourceId and sid are required",
    );
  }

  const mode = "mix";

  const response = await fetch(
      `${AGORA_BASE_URL}/${APP_ID}/cloud_recording/resourceid/${resourceId}/sid/${sid}/mode/${mode}/query`,
      {
        method: "GET",
        headers: {
          "Authorization": getBasicAuth(),
          "Content-Type": "application/json",
        },
      },
  );

  const result = await response.json();
  if (!response.ok) {
    throw new functions.https.HttpsError("internal", JSON.stringify(result));
  }

  return result;
});
