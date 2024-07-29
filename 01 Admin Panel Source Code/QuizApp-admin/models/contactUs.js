import mongoose, { Schema } from "mongoose";
import joi from "joi";
import db from "./dbConnection.js";

const contactUsSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, required: true },
    message: { type: String, required: true },
    createdBy: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "user",
    },
  },
  { timestamps: true }
);

const ContactUsModel = db.model("contactUs", contactUsSchema);

const addContactUsValidation = (body) => {
  const schema = joi.object({
    name: joi.string().required(),
    email: joi.string().trim().email().required(),
    message: joi.string().required(),
  });
  return schema.validate(body);
};

export { ContactUsModel, addContactUsValidation };
