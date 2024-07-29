import mongoose from "mongoose";
import db from "./dbConnection.js";

const campusSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    members: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }], // Assuming each member is a user with a unique ObjectId
    points: { type: Number, default: 0 },
  },
  { timestamps: true }
);

const CampusModel = db.model("campus", campusSchema);

export { CampusModel };

