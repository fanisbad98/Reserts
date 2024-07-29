import mongoose, { Schema } from "mongoose";
import db from "./dbConnection.js";

const userAnswerSchema = new mongoose.Schema({
  questionId: { type: String, required: true },
  selectedAnswer: { type: String, required: true },
  userId: { type: String, required: true },
  categoryId: { type: String, required: true },
  lvl: { type: String, required: true },
}, { timestamps: true });

const UserAnswerModel = db.model('UserAnswer', userAnswerSchema);

export  {UserAnswerModel};
