import appRoot from "app-root-path";
import winston from "winston";

const options = {
  console: {
    level: "info",
    filename: `${appRoot}/logs/app.log`,
    handleExceptions: true,
    json: true,
    maxsize: 5242880, // 5MB
    maxFiles: 5,
    colorize: true,
    timestamp: true,
    format: winston.format.combine(winston.format.colorize({ all: true })),
  },
  exceptions: {
    level: "error",
    handleExceptions: true,
    handleRejections: true,
    filename: `${appRoot}/logs/exceptions.log`,
    timestamp: true,
    maxsize: 5242880,
    json: true,
    colorize: true,
    maxFiles: 20,
    tailable: true,
    zippedArchive: true,
  },
};

export const logger = winston.createLogger({
  format: winston.format.combine(
    winston.format.errors({ stack: true }),
    winston.format.label({ label: "[LOGGER]" }),
    winston.format.timestamp({ format: "YYYY-MMM-DD HH:MM:ss" }),
    winston.format.printf(
      (log) =>
        ` ${log.label}  ${log.timestamp}  ${log.level} : ${log.message} ${
          log.stack ?? ""
        }`
    )
  ),
  transports: [
    new winston.transports.Console(options.console),
    new winston.transports.File(options.exceptions),
  ],
  exceptionHandlers: new winston.transports.File(options.exceptions),
});

export default logger;
