import jwt from "jsonwebtoken";
import logger from "../config/logger.js";
import config from "../config/index.js";
import { handleError, handleResponse } from "../config/reqHandler.js";
import { UserModel } from "../models/user.js";

export const verifyAdmin = async (req, res, next) => {
  logger.info("Verify Admin Middleware");
  try {
    if (req.session.user) {
      if (req.session.user.isDemoAdmin) {
        return handleResponse({
          res,
          msg: `You can't perform this action because you are Demo Admin`,
          data: { reloadRequired: false },
        });
      } else {
        next();
      }
    } else {
      return res.redirect("/login");
    }
  } catch (err) {
    logger.error(err);
    return handleError({
      res,
      statusCode: err.statusCode ?? 500,
      err_msg: err.message,
    });
  }
};

export const getAccessToken = async (userId) => {
  const data = { userId };
  return jwt.sign({ data }, config.jwtSecret, {
    expiresIn: "17200000h",
  });
};

export const verifyUser = async (req, res, next) => {
  logger.info("Verify User Profile");
  try {
    let token =
      req.headers.Authorization ||
      req.headers.authorization ||
      req.headers["x-access-token"] ||
      req.header("token");

    if (!token) {
      return handleError({
        res,
        statusCode: 400,
        err_msg: "Please Login first.",
      });
    }

    token = token.split(" ")[1];
    const decoded = jwt.verify(token, config.jwtSecret);
    const { data } = decoded;
    req.userId = data.userId;
    const userData = await UserModel.findOne({
      token: token,
      userStatus: true,
    });
    if (userData) {
      return next();
    } else {
      return handleError({ res, statusCode: 401, err_msg: "Token expired." });
    }
  } catch (error) {
    logger.error(error);
    return handleError({
      res,
      statusCode: error.statusCode ?? 500,
      err_msg: error.message,
    });
  }
};
