import mongoose from "mongoose";
import config from "../config/index.js";
import logger from "../config/logger.js";

mongoose.connect(config.db.uri, config.db.options);

const db = mongoose.connection;
// CONNECTION EVENTS

// When successfully connected
db.on("connected", () => {
  logger.info("Mongoose connection open to DB");
});

// If the connection throws an error
db.on("error", (err) => {
  logger.debug(`Mongoose connection error for DB: ${err}`);
});

// When the connection is disconnected
db.on("disconnected", () => {
  logger.debug("Mongoose connection disconnected for DB");
});

// When connection is reconnected
db.on("reconnected", () => {
  logger.info("Mongoose connection reconnected for DB");
});
// If the Node process ends, close the Mongoose connection
process.on("SIGINT", () => {
  db.close(() => {
    logger.debug(
      "Mongoose connection disconnected for DB through app termination"
    );
    // eslint-disable-next-line no-process-exit
    process.exit(0);
  });
});

export default db;
