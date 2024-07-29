import joi from "joi";
import mongoose from "mongoose";
import db from "./dbConnection.js";

const securityQuestionSchema = new mongoose.Schema(
  {
    question: { type: String, required: true },
    optionA: { type: String, required: true },
    optionB: { type: String, required: true },
    optionC: { type: String, required: true },
    optionD: { type: String, required: true },
    correctAnswer: { type: String, required: true },
  },
  { timestamps: true }
);

const SecurityQuestionModel = db.model(
  "securityQuestion",
  securityQuestionSchema
);

const validateSecurityQuestion = (body) => {
  const schema = joi.object({
    question: joi.string().required(),
    optionA: joi.string().required(),
    optionB: joi.string().required(),
    optionC: joi.string().required(),
    optionD: joi.string().required(),
    correctAnswer: joi.string().valid("A", "B", "C", "D").required(),
  });
  return schema.validate(body);
};

export { SecurityQuestionModel, validateSecurityQuestion };

