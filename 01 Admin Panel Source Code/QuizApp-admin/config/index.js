import { config } from "dotenv";

config();

export default {
  port: process.env.PORT,
  db: {
    uri: process.env.MONGODB_URI,
    options: {
      useNewUrlParser: true,
      readPreference: "primaryPreferred",
      useUnifiedTopology: true,
      useNewUrlParser: true,
    },
  },
  jwtSecret: process.env.JWT_SECRET,
  categoryImagePath: "public/dist/img/category",
  bannerImagePath: "public/dist/img/banner",
  profilePicPath: "public/dist/img/profilePic",
  paymentPicPath: "public/dist/img/paymentPic",
  csvPath: "uploads/questions",
  notificationPath: "uploads/notification",
  appIconPath: "public/dist/img",
};
