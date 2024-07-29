import path, { resolve } from "path";
import bodyParser from "body-parser";
import cookieParser from "cookie-parser";
import * as dotenv from "dotenv";
import express, { json } from "express";
import session from "express-session";
import ConnectMongoDBSession from "connect-mongodb-session";
import mongoose from "mongoose";
import flash from "connect-flash";
import morgan from "morgan";
import { fileURLToPath } from "url";
import config from "./config/index.js";
import logger from "./config/logger.js";
import mainRoute from "./routes/index.js";
import { renderLogin } from "./routes/app/appController.js";
import { AdminModel } from "./models/admin.js";
import { generateEncryptedPassword } from "./helper/common.js";
import { SettingModel } from "./models/settings.js";

dotenv.config();

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const MongoDBStore = ConnectMongoDBSession(session);

const app = express();

const store = new MongoDBStore({
  uri: config.db.uri,
  collection: "sessions",
});

app.set("views", path.join(__dirname, "admin"));
app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({ extended: false }));
app.use(morgan("dev"));
app.use(cookieParser());
app.use(json());
app.use(flash());
app.use(express.static(path.join(__dirname, "admin")));

app.use(
  session({
    cookie: { maxAge: 288000000 },
    secret: config.jwtSecret,
    resave: true,
    saveUninitialized: false,
    store: store,
  })
);

app.use((req, res, next) => {
  res.setHeader(
    "Access-Control-Allow-Methods",
    "POST, PUT, OPTIONS, DELETE, GET"
  );
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  next();
});

app.get("/", renderLogin);
app.use("/", mainRoute);

mongoose
  .connect(config.db.uri, config.db.options)
  .then((result) => {
    app.listen(config.port);
    logger.info(`app Listen on http://localhost:${config.port}/`);
    (async () => {
      try {
        let adminDetails = await AdminModel.findOne({ isDemoAdmin: false });
        if (!adminDetails) {
          let pass = await generateEncryptedPassword("admin@123");
          await AdminModel.create({
            email: "admin@admin.com",
            name: "Admin",
            password: pass,
            isDemoAdmin: false,
          });
          console.log("Admin Created");
        }

        let appDetails = await SettingModel.findOne();
        if (!appDetails) {
          await SettingModel.create({ appName: "Quiz & Earn" });
          console.log("App Settings Created");
        }
      } catch (e) {
        console.log(e);
      }
    })();
  })
  .catch((err) => {
    logger.error(err);
  });
