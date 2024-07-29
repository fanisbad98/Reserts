import joi from "joi";
import mongoose, { Schema } from "mongoose";
import db from "./dbConnection.js";

const questionSchema = new mongoose.Schema(
  {
    categoryId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "category",
    },
    question: { type: String, required: true },
    optionA: { type: String, required: true },
    optionB: { type: String, required: true },
    optionC: { type: String, required: true },
    optionD: { type: String, required: true },
    level: { type: String, required: true, enum: ["Easy", "Medium", "Hard"] },
  },
  { timestamps: true }
);

const QuestionModel = db.model("question", questionSchema);

const validateAddQuestion = (body) => {
  const schema = joi.object({
    categoryId: joi.string().required(),
    question: joi.string().required(),
    optionA: joi.string().required(),
    optionB: joi.string().required(),
    optionC: joi.string().required(),
    optionD: joi.string().required(),
    level: joi.string().valid("Easy", "Medium", "Hard"),
  });
  return schema.validate(body);
};