import mongoose from "mongoose";
import joi from "joi";
import db from "./dbConnection.js";

const adminSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, required: true },
    password: { type: String, required: true },
    lastLogin: { type: Date, default: Date.now },
    isDemoAdmin: { type: Boolean, default: true },
  },
  { timestamps: true }
);

const AdminModel = db.model("admin", adminSchema);

const adminLoginValidation = (body) => {
  const schema = joi.object({
    email: joi.string().trim().email().required(),
    password: joi.string().required(),
  });
  return schema.validate(body);
};

export { AdminModel, adminLoginValidation };
