import mongoose from "mongoose";
import joi from "joi";
import db from "./dbConnection.js";

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, isUnique: true },
    mobile: { type: String, isUnique: true },
    profilePic: {
      type: String,
      default: "",
    },
    isSubscribed: { type: Boolean, default: false },
    totalPoints: {
      type: Number,
      default: 0,
      min: [0, "Don't have enough points"],
    },
    referralCode: { type: String, isUnique: true },
    referedBy: { type: String },
    isReferralPointRedeem: { type: Boolean, default: false },
    token: { type: String, default: "" },
    userStatus: { type: Boolean, default: true },
  },
  {
    versionKey: false,
    timestamps: {
      createdAt: true,
      updatedAt: true,
    },
  }
);

const UserModel = db.model("user", userSchema);

const validateRegisterUser = (body) => {
  const schema = joi.object({
    name: joi.string().trim().min(3).max(128),
    email: joi.string().email().min(3).max(128),
    mobile: joi.string(),
    referedBy: joi.string().allow(null, "").optional(),
  });
  return schema.validate(body);
};

export { UserModel, validateRegisterUser };
