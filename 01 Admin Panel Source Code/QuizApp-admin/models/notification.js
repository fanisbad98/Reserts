import mongoose from "mongoose";
import db from "./dbConnection.js";

const pushNotificationSchema = new mongoose.Schema(
  {
    notificationId: {
      type: String,
      required: true,
    },
    title: { type: String },
    subTitle: { type: String },
    content: { type: String },
    imageURL: { type: String, default: "" },
  },
  { timestamps: true }
);

const PushNotificationModel = db.model(
  "pushNotification",
  pushNotificationSchema
);

export { PushNotificationModel };
