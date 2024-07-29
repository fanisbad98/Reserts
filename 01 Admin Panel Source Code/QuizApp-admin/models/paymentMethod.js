import mongoose from "mongoose";
import joi from "joi";
import db from "./dbConnection.js";

const paymentMethodSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    image: { type: String, required: true },
    inputField: { type: String, enum: ["text", "number"] },
    inputPlaceholder: { type: String },
    isActive: { type: Boolean, default: true },
  },
  {
    versionKey: false,
    timestamps: {
      createdAt: true,
      updatedAt: true,
    },
  }
);

const PaymentMethodModel = db.model("paymentMethod", paymentMethodSchema);

export { PaymentMethodModel };
