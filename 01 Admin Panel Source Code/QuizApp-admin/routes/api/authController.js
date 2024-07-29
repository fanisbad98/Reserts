import logger from "../../config/logger.js";
import { handleError, handleResponse } from "../../config/reqHandler.js";
import { getAccessToken } from "../../middleware/auth.js";
import { SettingModel } from "../../models/settings.js";
import { UserModel, validateRegisterUser } from "../../models/user.js";

const getAppSetting = async () => {
  const data = await SettingModel.findOne().sort({ _id: -1 });
  return data;
};

const checkMobileExist = async (mobile) => {
  const result = await UserModel.findOne({
    mobile: mobile,
  });
  return result;
};

const checkEmailExist = async (email) => {
  const result = await UserModel.findOne({
    email: email,
  });
  return result;
};

const generateReferralCode = async () => {
  let randomString;

  let isExist = true;

  const appSetting = await getAppSetting();

  while (isExist) {
    randomString = `${appSetting.referralCodePrefix.toUpperCase()}${Date.now()
      .toString(36)
      .slice(5, 7)
      .toUpperCase()}${(Math.random() + 1)
      .toString(36)
      .slice(2, 5)
      .toUpperCase()}`;

    isExist = await UserModel.findOne({ referralCode: randomString });
  }

  return randomString;
};

export const register = async (req, res) => {
  logger.info("Inside Register Controller");
  try {
    const { error } = validateRegisterUser(req.body);
    if (error) {
      return handleError({ res, err_msg: error.message });
    }

    const userEmail = await checkEmailExist(req.body.email);
    if (userEmail) {
      return handleError({
        res,
        statusCode: 400,
        err_msg: "Email already registered.",
      });
    }

    const userMobile = await checkMobileExist(req.body.mobile);
    if (userMobile) {
      return handleError({
        res,
        statusCode: 400,
        err_msg: "Mobile number already registered.",
      });
    }

    const referralCode = await generateReferralCode();

    const newUser = new UserModel({ ...req.body, referralCode: referralCode });
    newUser.save(async (err, newUserData) => {
      if (err) {
        return handleError({ res, statusCode: 401, err_msg: err.message });
      }
      if (newUserData) {
        return handleResponse({ res, msg: "Registered Successfully" });
      }
    });
  } catch (err) {
    logger.error(err);
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const login = async (req, res) => {
  logger.info("Inside Login Controller");
  try {
    const userData = await checkMobileExist(req.body.mobile);
    if (!userData) {
      return handleError({
        res,
        statusCode: 400,
        err_msg: "Email address is not registered",
      });
    }

    if (!userData.userStatus) {
      return handleError({
        res,
        statusCode: 503,
        err_msg: "User Not Active",
      });
    }

    userData.token = await getAccessToken(userData._id);
    await userData.save();
    const configData = await getAppSetting();

    if (!userData.isReferralPointRedeem && userData.referedBy != null) {
      const referrarUser = await UserModel.findOne({
        referralCode: userData.referedBy,
      });
      if (referrarUser) {
        referrarUser.totalPoints += configData.referralPoints;
        userData.totalPoints += configData.welcomePoints;
        userData.isReferralPointRedeem = true;
        await referrarUser.save();
        await userData.save();
      }
    }

    return handleResponse({
      res,
      msg: "Logged in Successfully.",
      data: {
        _id: userData._id,
        name: userData.name,
        email: userData.email,
        mobile: userData.mobile,
        profile:
          userData.profilePic === ""
            ? configData.userPlaceholder
            : userData.profilePic,
        isSubscribed: userData.isSubscribed,
        totalPoints: userData.totalPoints,
        referralCode: userData.referralCode,
        token: userData.token,
      },
    });
  } catch (err) {
    logger.error(err);
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const logout = async (req, res) => {
  logger.info("Inside Logout Controller");
  try {
    const userData = await UserModel.findById(req.userId);
    userData.token = "";
    await userData.save();
    return handleResponse({ res, msg: "Logout Successfully" });
  } catch (err) {
    logger.error(err);
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};
