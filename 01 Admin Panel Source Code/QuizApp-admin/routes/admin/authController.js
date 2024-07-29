import _ from "lodash";
import logger from "../../config/logger.js";
import { handleError } from "../../config/reqHandler.js";
import { compareEncryptedPassword } from "../../helper/common.js";
import { adminLoginValidation, AdminModel } from "../../models/admin.js";
import { SettingModel } from "../../models/settings.js";

export const verifyLogin = async (req, res) => {
  logger.info("at verifyLogin controller");
  try {
    const appData = await SettingModel.findOne(
      {},
      { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
    );
    const validate = await adminLoginValidation(req.body);

    if (validate.error) {
      return res.render("auth/login", {
        data: validate.error._original,
        app: appData,
        error: validate.error,
        success: req.flash("success"),
      });
    }
    const admin = await AdminModel.findOne({
      email: req.body.email,
    });
    if (!admin) {
      return res.render("auth/login", {
        data: req.body,
        app: appData,
        error: "Please enter valid email address",
        success: req.flash("success"),
      });
    }
    const validPwd = await compareEncryptedPassword(
      req.body.password,
      admin.password
    );
    if (!validPwd) {
      return res.render("auth/login", {
        data: req.body,
        app: appData,
        error: "Password Incorrect",
        success: req.flash("success"),
      });
    }
    req.session.user = {
      _id: admin._id,
      name: admin.name,
      email: admin.email,
      isDemoAdmin: admin.isDemoAdmin,
    };
    return res.redirect("/dashboard");
  } catch (err) {
    logger.error(err);
    return handleError({ res, err: err.message });
  }
};

export const logout = async (req, res) => {
  logger.info("Inside Logout Controller");
  try {
    if (req.session.user) {
      req.session.destroy();
      res.clearCookie("connect.sid");
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      return res.render("auth/login", {
        error: "",
        success: "",
        data: null,
        app: appData,
      });
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};
