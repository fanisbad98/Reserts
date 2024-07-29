import mongoose from "mongoose";
import joi from "joi";
import db from "./dbConnection.js";

const withdrawReqSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Types.ObjectId, required: true, ref: "user" },
    reqStatus: {
      type: String,
      default: "Pending",
      enum: ["Pending", "Approved", "Rejected"],
    },
    amount: { type: Number, required: true },
    points: { type: Number, required: true },
    paymentMethod: {
      type: mongoose.Types.ObjectId,
      required: true,
      ref: "paymentMethod",
    },
    paymentVia: {
      type: String,
      required: true,
    },
  },
  {
    versionKey: false,
    timestamps: {
      createdAt: true,
      updatedAt: true,
    },
  }
);

const WithdrawReqModel = db.model("withdrawReq", withdrawReqSchema);

const validateCreateReq = (body) => {
  const schema = joi.object({
    amount: joi.number().positive(),
    points: joi.number().positive(),
    paymentMethod: joi.string(),
    paymentVia: joi.string(),
  });
  return schema.validate(body);
};

const validateUpdateReqStatus = (body) => {
  const schema = joi.object({
    status: joi.string().allow("Approved", "Rejected"),
  });
  return schema.validate(body);
};

export { WithdrawReqModel, validateCreateReq, validateUpdateReqStatus };
