import mongoose from "mongoose";
import db from "./dbConnection.js";

const categorySchema = new mongoose.Schema(
  {
    name: { type: String, required: true, unique: true },
    image: { type: String, required: true },
    isFeature: { type: Boolean, default: false },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

const CategoryModel = db.model("category", categorySchema);

export { CategoryModel };
