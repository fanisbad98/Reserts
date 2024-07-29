import { unlink } from "fs/promises";
import mongoose, { mongo } from "mongoose";
import * as OneSignal from "@onesignal/node-onesignal";
import excelJS from "exceljs";
import config from "../../config/index.js";
import logger from "../../config/logger.js";
import { handleError, handleResponse } from "../../config/reqHandler.js";
import { CategoryModel } from "../../models/categories.js";
import { PaymentMethodModel } from "../../models/paymentMethod.js";
import { QuestionModel, validateAddQuestion } from "../../models/questions.js";
import { SettingModel } from "../../models/settings.js";
import { UserModel } from "../../models/user.js";
import {
  validateUpdateReqStatus,
  WithdrawReqModel,
} from "../../models/withdrawReq.js";
import { AdminModel } from "../../models/admin.js";
import {
  compareEncryptedPassword,
  generateEncryptedPassword,
} from "../../helper/common.js";
import { PushNotificationModel } from "../../models/notification.js";
import { ContactUsModel } from "../../models/contactUs.js";
import { CampusModel } from "../../models/campuses.js";
import { SecurityQuestionModel } from "../../models/securityQuestions.js";
import { UserAnswerModel } from "../../models/userAnswers.js";


export const renderLogin = async (req, res) => {
  logger.info("Inside renderLogin Controller");
  try {
    if (req.session.user) {
      return res.redirect("/dashboard");
    } else {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      return res.render("auth/login", {
        error: req.flash("error"),
        data: null,
        app: appData,
        success: req.flash("success"),
      });
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderDashboard = async (req, res) => {
  logger.info("Inside renderDashboard controller");
  try {
    if (req.session.user) {
      const users = await UserModel.count();
      const categories = await CategoryModel.count();
      const campuses = await CampusModel.count();
      const questions = await QuestionModel.count();
      const securityQuestions = await SecurityQuestionModel.count();
      const userAnswers = await UserAnswerModel.count();
      const withdrawals = await WithdrawReqModel.count();
      const paymentMethods = await PaymentMethodModel.count();
      const notifications = await PushNotificationModel.count();
      const contacts = await ContactUsModel.count();
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      return res.render("app/dashboard", {
        pageName: "dashboard",
        user: req.session.user,
        app: appData,
        data: {
          users,
          categories,
          campuses,
          questions,
          securityQuestions,
          userAnswers,
          withdrawals,
          paymentMethods,
          notifications,
          contacts,
        },
      });
    } else {
      return res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderHomeScreenBanner = async (req, res) => {
  logger.info("Inside renderHomeScreenBanner Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const data = await SettingModel.findOne({}, { bannerImage: 1 })
        .sort({ _id: -1 })
        .lean();
      return res.render("app/homeScreenBanner", {
        pageName: "homeScreenBanner",
        user: req.session.user,
        app: appData,
        banner: data.bannerImage,
      });
    } else {
      res.redirect("/login");
    }
  } catch (err) {
    logger.error(err);
    return handleError({ res, err: err.message });
  }
};

export const renderUsers = async (req, res) => {
  logger.info("Inside renderUser Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const users = await UserModel.find({}, { token: 0 })
        .sort({ _id: -1 })
        .lean();
      const appSetting = await SettingModel.findOne(
        {},
        { userPlaceholder: 1 }
      ).sort({ _id: -1 });
      for (const i in users) {
        if (users[i].profilePic === "") {
          users[i].profilePic = appSetting.userPlaceholder;
        }
        if (req.session.user.isDemoAdmin) {
          users[i].mobile = "Demo Admin can't see this Field";
          users[i].email = "Demo Admin can't see this Field";
        }
      }
      return res.render("app/users", {
        pageName: "users",
        user: req.session.user,
        app: appData,
        data: users,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderContactUs = async (req, res) => {
  logger.info("Inside Render ContactUs Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const appSetting = await SettingModel.findOne(
        {},
        { userPlaceholder: 1 }
      ).sort({ _id: -1 });
      const data = await ContactUsModel.aggregate([
        {
          $lookup: {
            from: "users",
            localField: "createdBy",
            foreignField: "_id",
            as: "user",
          },
        },
        {
          $unwind: {
            path: "$user",
            preserveNullAndEmptyArrays: false,
          },
        },
        {
          $project: {
            name: 1,
            email: 1,
            message: 1,
            user: {
              name: 1,
              profilePic: {
                $cond: {
                  if: {
                    $eq: ["$user.profilePic", ""],
                  },
                  then: appSetting.userPlaceholder,
                  else: "$user.profilePic",
                },
              },
            },
            createdAt: 1,
          },
        },
      ]);
      return res.render("app/contactus", {
        pageName: "contactus",
        user: req.session.user,
        app: appData,
        data: data,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderAdminSetting = async (req, res) => {
  logger.info("Inside Render Admin Setting Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      return res.render("app/adminSettings", {
        pageName: "adminSettings",
        user: req.session.user,
        app: appData,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderCategories = async (req, res) => {
  logger.info("Inside renderCategories Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const categories = await CategoryModel.find(
        {},
        { name: 1, image: 1, isActive: 1, isFeature: 1 }
      );
      return res.render("app/categories", {
        pageName: "categories",
        user: req.session.user,
        app: appData,
        data: categories,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderCampuses = async (req, res) => {
  logger.info("Inside renderCampuses Controller");
  try {
    if (req.session.user) {

      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const campuses = await CampusModel.find(
        {}, // Fetch all campuses
        { name: 1, members: 1, points: 1 } 
      );
      return res.render("app/campuses", {
        pageName: "campuses",
        user: req.session.user,
        app: appData,
        data: campuses,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};


export const renderQuestionsByCategory = async (req, res) => {
  logger.info("Inside renderQuestionsByCategory Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const category = await CategoryModel.aggregate([
        {
          $lookup: {
            from: "questions",
            localField: "_id",
            foreignField: "categoryId",
            as: "result",
          },
        },
        {
          $project: {
            _id: 1,
            name: "$name",
            image: "$image",
            questionCount: {
              $size: "$result",
            },
            isFeature: "$isFeature",
            isActive: "$isActive",
          },
        },
        {
          $sort: {
            isActive: -1,
            isFeature: -1,
          },
        },
      ]);
      return res.render("app/questionsByCategory", {
        pageName: "questions",
        user: req.session.user,
        app: appData,
        data: category,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderQuestions = async (req, res) => {
  logger.info("at RenderQuestion Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const { categoryId } = req.params;
      const category = await CategoryModel.findById(
        mongoose.Types.ObjectId(categoryId)
      );
      const questions = await QuestionModel.find(
        {
          categoryId: mongoose.Types.ObjectId(categoryId),
        },
        { _id: 1, question: 1, level: 1 }
      );
      return res.render("app/questions", {
        pageName: "questions",
        user: req.session.user,
        app: appData,
        data: { name: category.name, _id: category._id, questions: questions },
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderSecurityQuestions = async (req, res) => {
  logger.info("Inside renderSecurityQuestions Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const securityQuestions = await SecurityQuestionModel.find(
        {}, 
        { question: 1 } 
      );
      return res.render("app/securityQuestions", {
        pageName: "securityQuestions",
        user: req.session.user,
        app: appData,
        data: securityQuestions, 
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};


export const renderUserAnswers = async (req, res) => {
  logger.info("Inside userAnswers Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );

      const userAnswers = await UserAnswerModel.find(
        { userId: req.session.user._id },
        { questionId: 1, selectedAnswer: 1, categoryId: 1, lvl: 1 }
      ).sort({ _id: -1 });

      const categoryIds = userAnswers.map(answer => answer.categoryId);
      const categories = await CategoryModel.find(
        { _id: { $in: categoryIds } },
        { name: 1 }
      );

      const userAnswersWithDetails = await Promise.all(userAnswers.map(async (answer) => {
        const question = await QuestionModel.findById(answer.questionId);
        const category = categories.find(c => c._id.equals(answer.categoryId));
        return {
          ...answer.toObject(),
          question,
          category
        };
      }));

      return res.render("app/userAnswers", {
        pageName: "userAnswers",
        user: req.session.user,
        app: appData,
        data: userAnswersWithDetails
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};


export const renderWithdrawals = async (req, res) => {
  logger.info("Inside renderWithdrawal Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const appSetting = await SettingModel.findOne(
        {},
        { userPlaceholder: 1 }
      ).sort({ _id: -1 });
      const withdrawals = await WithdrawReqModel.aggregate([
        {
          $lookup: {
            from: "paymentmethods",
            localField: "paymentMethod",
            foreignField: "_id",
            as: "paymentMethod",
          },
        },
        {
          $unwind: {
            path: "$paymentMethod",
            preserveNullAndEmptyArrays: true,
          },
        },
        {
          $lookup: {
            from: "users",
            localField: "userId",
            foreignField: "_id",
            as: "user",
          },
        },
        {
          $unwind: {
            path: "$user",
            preserveNullAndEmptyArrays: true,
          },
        },
        {
          $project: {
            _id: 1,
            user: {
              _id: 1,
              name: 1,
              email: 1,
              mobile: 1,
              isSubscribed: 1,
              totalPoints: 1,
              userStatus: 1,
              profilePic: {
                $cond: {
                  if: {
                    $eq: ["$user.profilePic", ""],
                  },
                  then: appSetting.userPlaceholder,
                  else: "$user.profilePic",
                },
              },
            },
            reqStatus: 1,
            amount: 1,
            points: 1,
            paymentVia: 1,
            paymentMethod: {
              _id: 1,
              name: 1,
              image: 1,
            },
          },
        },
        {
          $sort: {
            _id: -1,
          },
        },
      ]);
      return res.render("app/withdrawals", {
        pageName: "withdrawals",
        user: req.session.user,
        app: appData,
        data: withdrawals,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderNotification = async (req, res) => {
  logger.info("Inside renderNotification Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const data = await PushNotificationModel.find({}, { _id: 0 }).sort({
        _id: -1,
      });
      return res.render("app/pushNotification", {
        pageName: "pushNotification",
        user: req.session.user,
        app: appData,
        data: data,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderAppSettings = async (req, res) => {
  logger.info("Inside renderAppSettings Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const count = await SettingModel.find().count();
      if (count === 0) await SettingModel.create({});
      const data = await SettingModel.findOne({}).sort({ _id: -1 });
      if (req.session.user.isDemoAdmin) {
        data.oneSignalAppID = "Demo Admin Can't See this Field";
        data.oneSignalSecretKey = "Demo Admin Can't See this Field";
      }
      return res.render("app/appSettings", {
        pageName: "appSettings",
        user: req.session.user,
        app: appData,
        setting: data,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderAdsSettings = async (req, res) => {
  logger.info("Inside renderAds Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const count = await SettingModel.find().count();
      if (count === 0) await SettingModel.create({});
      const data = await SettingModel.findOne({}).sort({ _id: -1 });
      return res.render("app/adsSettings", {
        pageName: "adsSettings",
        user: req.session.user,
        app: appData,
        setting: data,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const renderPaymentSettings = async (req, res) => {
  logger.info("Inside render Payment Controller");
  try {
    if (req.session.user) {
      const appData = await SettingModel.findOne(
        {},
        { appIcon: 1, appName: 1, copyrightYear: 1, appHost: 1 }
      );
      const paymentGateways = await PaymentMethodModel.find({}).sort({
        _id: -1,
      });
      return res.render("app/paymentSettings", {
        pageName: "paymentSettings",
        user: req.session.user,
        app: appData,
        data: paymentGateways,
      });
    } else {
      res.redirect("/login");
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const changePassword = async (req, res) => {
  logger.info("Inside Change Password Controller");
  try {
    const admin = await AdminModel.findById(req.session.user._id);
    const validPwd = await compareEncryptedPassword(
      req.body.oldPassword,
      admin.password
    );
    if (!validPwd) {
      return handleError({
        res,
        statusCode: 400,
        err_msg: "Old Password not Matched",
      });
    }

    const newPass = await generateEncryptedPassword(req.body.newPassword);
    await AdminModel.findByIdAndUpdate(admin._id, {
      $set: { password: newPass },
    });

    return handleResponse({ res, msg: "Password Change Successfully" });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error.message });
  }
};

export const sendNotification = async (req, res) => {
  logger.info("Inside Send Push Notification Controller");
  try {
    const { notificationTitle, notificationSubTitle, notificationContent } =
      req.body;
    const data = await SettingModel.findOne(
      {},
      { oneSignalAppID: 1, oneSignalSecretKey: 1 }
    ).sort({ _id: -1 });
    if (
      !data ||
      data?.oneSignalAppID == null ||
      data?.oneSignalSecretKey == null
    ) {
      return handleResponse({
        res,
        err_msg: "You have to Set OnSignal AppID and Secret Key",
      });
    }

    const configuration = OneSignal.createConfiguration({
      authMethods: {
        app_key: {
          tokenProvider: {
            getToken() {
              return data.oneSignalSecretKey;
            },
          },
        },
      },
    });
    const client = new OneSignal.DefaultApi(configuration);

    const notification = new OneSignal.Notification();
    notification.app_id = data.oneSignalAppID;
    notification.included_segments = ["Subscribed Users"];
    notification.contents = {
      en: notificationContent ?? "",
    };
    notification.headings = {
      en: notificationTitle ?? "",
    };
    notification.subtitle = {
      en: notificationSubTitle ?? "",
    };
    if (req.file) {
      notification.big_picture = `${req.headers.origin}/${config.notificationPath}/${req.file.filename}`;
      notification.ios_attachments = {
        id1: `${req.headers.origin}/${config.notificationPath}/${req.file.filename}`,
      };
    }
    const dataNotification = await client.createNotification(notification);

    await PushNotificationModel.create({
      notificationId: dataNotification.id,
      title: notificationTitle,
      subTitle: notificationSubTitle,
      content: notificationContent,
      imageURL: req.file
        ? `${req.headers.origin}/${config.notificationPath}/${req.file.filename}`
        : "",
    });
    return handleResponse({ res, msg: "Notification Created Successfully" });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err_msg: error.message });
  }
};

export const addCategory = async (req, res) => {
  logger.info("Inside Add Category Controller");
  try {
    let isExist = await CategoryModel.find({ name: req.body.categoryName });
    if (isExist.length > 0) {
      await unlink(`admin/${config.categoryImagePath}/${req.file.filename}`)
      return handleError({
        res,
        err_msg: "Category Already Exist",
      })
    } else {
      var category = new CategoryModel({
        name: req.body.categoryName,
        image: `${config.categoryImagePath}/${req.file.filename}`,
      });
      await category.save();
      return handleResponse({
        res,
        data: { reloadRequired: true },
        msg: "Category Added Successfully.",
      });
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const addSecurityQuestion = async (req, res) => {
  try {
    if (!req.session.user) {
      return res.redirect("/login");
    }
    const { question } = req.body;
    const newSecurityQuestion = new SecurityQuestionModel({ question });
    await newSecurityQuestion.save();
    return res.status(200).json({ message: "Security question added successfully" });
  } catch (error) {
    console.error("Error adding security question:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
};




export const deleteSecurityQuestion = async (req, res) => {
  try {
    if (!req.session.user) {
      return res.redirect("/login");
    }
    const { id } = req.params;
    await SecurityQuestionModel.findByIdAndDelete(id);
    return res.status(200).json({ message: "Security question deleted successfully" });
  } catch (error) {
    console.error("Error deleting security question:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
};



export const deleteCategory = async (req, res) => {
  logger.info("Inside Delete Category Controller");
  try {
    const { id } = req.params;
    var categoryData = await CategoryModel.findOne({
      _id: mongoose.Types.ObjectId(id),
    });
    if (categoryData.image != "") {
      await unlink(`admin/${categoryData.image}`);
    }
    await QuestionModel.deleteMany({ categoryId: mongoose.Types.ObjectId(id) });
    const data = await CategoryModel.findByIdAndDelete(id);
    return handleResponse({
      res,
      data: data,
      msg: "Category Deleted",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const deleteUserAnswers = async (req, res) => {
  try {
    if (!req.session.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const { id } = req.params;
    const deletedAnswer = await UserAnswerModel.findByIdAndDelete(id);

    if (!deletedAnswer) {
      return res.status(404).json({ message: "User answer not found" });
    }

    return res.status(200).json({ message: "User answer deleted successfully" });
  } catch (error) {
    console.error("Error deleting user answer:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
};


export const deleteCampus = async (req, res) => {
  logger.info("Inside Delete Campus Controller");
  try {
    const { id } = req.params;

    // Find the campus by ID
    const campus = await CampusModel.findById(id);

    if (!campus) {
      return handleError({
        res,
        err_msg: "Campus Not Found",
      });
    }

    // Delete the campus
    await campus.delete();

    return handleResponse({
      res,
      data: { campus },
      msg: "Campus Deleted Successfully.",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const deleteQuestion = async (req, res) => {
  logger.info("Inside Delete Question Controller");
  try {
    const { id } = req.params;
    await QuestionModel.findOneAndDelete({
      _id: mongoose.Types.ObjectId(id),
    });
    return handleResponse({
      res,
      msg: "Question Deleted",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const deletePaymentMethod = async (req, res) => {
  logger.info("Inseide Delete Payment Method Controller");
  try {
    const { id } = req.params;
    let paymentMethod = await PaymentMethodModel.findOne({
      _id: mongoose.Types.ObjectId(id),
    });
    if (paymentMethod.image != "") {
      await unlink(`admin/${paymentMethod.image}`);
    }
    await PaymentMethodModel.findByIdAndDelete(paymentMethod._id);
    return handleResponse({
      res,
      msg: "Payment Method Deleted!",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const updateBanner = async (req, res) => {
  logger.info("Inside Update Banner Controller");
  try {
    var oldImgPath = await SettingModel.findOne({}, { bannerImage: 1 }).sort({
      _id: -1,
    });
    if (oldImgPath.bannerImage != "") {
      await unlink(`admin/${oldImgPath.bannerImage}`);
    }

    const imagePath = `${config.bannerImagePath}/${req.file.filename}`;
    const updatedData = await SettingModel.updateOne(
      { _id: oldImgPath._id },
      {
        $set: {
          bannerImage: imagePath,
        },
      }
    );
    return handleResponse({
      res,
      msg: "Banner image updated Successfully.",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const addCampus = async (req, res) => {
  logger.info("Insede Add Campus Controller");
  try {
   const {name} = req.body;
   const existingCampus = await CampusModel.findOne({ name });
   if (existingCampus){
    return handleError({
      res,
      err_msg: "Campus Already Exists",
    });
   } 
   const newCampus = new CampusModel({
    name,
   });

   await newCampus.save();
   return handleResponse({
    res,
    data: { reloadRequired: true},
    msg: "Campus Added Successfully.",
   });
  }catch(error){
    logger.error(error);
    return handleError({ res, err: error});
  }
};







export const addQuetions = async (req, res) => {
  logger.info("Inside Add Question Controller");
  try {
    const { error } = validateAddQuestion(req.body);
    if (error) {
      return handleError({ res, err_msg: error.message });
    }
    const data = await QuestionModel.create(req.body);
    if (data) {
      return handleResponse({ res, msg: "Question Added Successfully" });
    } else {
      return handleError({ res, err_msg: "Something went wrong" });
    }
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const updateAppSetting = async (req, res) => {
  logger.info("Inside Update App Setting Controller");
  try {
    const record = await SettingModel.findOne(
      {},
      { _id: 1, userPlaceholder: 1 }
    )
      .sort({ _id: -1 })
      .lean();

    if (req.file) {
      if (record.userPlaceholder != "") {
        await unlink(`admin/${record.userPlaceholder}`);
        req.body.userPlaceholder = `${config.profilePicPath}/${req.file.filename}`;
      }
    }
    req.body.androidUpdatePopup =
      req.body.androidUpdatePopup === "on" ? true : false;
    req.body.iOSUpdatePopup = req.body.iOSUpdatePopup === "on" ? true : false;
    req.body.androidForceUpdate =
      req.body.androidForceUpdate === "on" ? true : false;
    req.body.iOSForceUpdate = req.body.iOSForceUpdate === "on" ? true : false;
    req.body.isMinusGrading = req.body.isMinusGrading === "on" ? true : false;
    req.body.hint5050 = req.body.hint5050 === "on" ? true : false;
    const createdData = await SettingModel.updateOne(
      {
        _id: record._id,
      },
      {
        $set: {
          ...req.body,
        },
      }
    );
    return handleResponse({ res, msg: "App Setting Update Successfully!!!" });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const updateAdminSetting = async (req, res) => {
  logger.info("Inside Update Admin Setting Controller");
  try {
    const record = await SettingModel.findOne({}, { appIcon: 1 })
      .sort({ _id: -1 })
      .lean();
    if (req.file) {
      if (record.appIcon && record.appIcon != "") {
        await unlink(`admin/${record.appIcon}`);
      }
      req.body.appIcon = `${config.appIconPath}/${req.file.filename}`;
    }
    const updatedData = await SettingModel.updateOne(
      {
        _id: record._id,
      },
      { $set: { ...req.body } }
    );
    return handleResponse({ res, msg: "Admin Setting Update Successfully!!!" });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const addPaymentGateway = async (req, res) => {
  logger.info("Inside Add Payment Gateway Controller");
  try {
    var paymentGateway = new PaymentMethodModel({
      name: req.body.name,
      inputField: req.body.inputField,
      inputPlaceholder: req.body.inputPlaceholder,
      isActive: true,
      image: `${config.paymentPicPath}/${req.file.filename}`,
    });
    await paymentGateway.save();

    return handleResponse({ res, msg: "Payment Gateway Added Successfully" });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const updateWithdraw = async (req, res) => {
  logger.info("Inside Update Withdraw Req. Controller");
  try {
    const { id } = req.params;
    const { error } = validateUpdateReqStatus(req.body);
    if (error) {
      return handleError({ res, err_msg: error.message });
    }
    const withdrawReq = await WithdrawReqModel.findById(
      {
        _id: mongoose.Types.ObjectId(id),
      }
    );
    if (withdrawReq.reqStatus === 'Pending') {
      withdrawReq.reqStatus = req.body.status

      if (req.body.status === 'Rejected') {
        const user = await UserModel.findOne({ _id: withdrawReq.userId })
        user.totalPoints += withdrawReq.points
        await user.save();
      }
      await withdrawReq.save();
      return handleResponse({ res, msg: "Request Updated Successfully" });
    }
    return handleError({ res, err_msg: "Can't Change status of this Request" })
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const updateUserStatus = async (req, res) => {
  logger.info("Inside Update User Status Controller");
  try {
    const { id } = req.params;

    const user = await UserModel.findOne(
      { _id: mongoose.Types.ObjectId(id) },
      { userStatus: 1 }
    );
    await UserModel.findOneAndUpdate(
      {
        _id: user._id,
      },
      {
        $set: {
          token: "",
          userStatus: !user.userStatus,
        },
      }
    );
    return handleResponse({ res, msg: "Status Change Successfully" });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const updateCategoryFeature = async (req, res) => {
  logger.info("Inside Update Category Feature Controller");
  try {
    const { id } = req.params;
    const category = await CategoryModel.findOne(
      {
        _id: mongoose.Types.ObjectId(id),
      },
      { isFeature: 1 }
    );
    await CategoryModel.findOneAndUpdate(
      {
        _id: category._id,
      },
      {
        $set: {
          isFeature: !category.isFeature,
        },
      }
    );
    return handleResponse({
      res,
      msg: category.isFeature
        ? "Successfully removed from Feature Category!"
        : "Added to Feature Category",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const updateCategoryStatus = async (req, res) => {
  logger.info("Inside Update Category Activation controller");
  try {
    const { id } = req.params;
    const category = await CategoryModel.findOne(
      {
        _id: mongoose.Types.ObjectId(id),
      },
      { isActive: 1 }
    );
    await CategoryModel.findOneAndUpdate(
      {
        _id: category._id,
      },
      {
        $set: {
          isActive: !category.isActive,
        },
      }
    );
    return handleResponse({
      res,
      msg: category.isActive ? "Category Deactivated!" : "Category Activated!",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const updatePaymentMethosStatus = async (req, res) => {
  logger.info("Inside Payment Method Status Update Controller ");
  try {
    const { id } = req.params;
    const paymentMethod = await PaymentMethodModel.findOne(
      {
        _id: mongoose.Types.ObjectId(id),
      },
      { isActive: 1 }
    );
    await PaymentMethodModel.findOneAndUpdate(
      { _id: paymentMethod._id },
      { $set: { isActive: !paymentMethod.isActive } }
    );
    return handleResponse({
      res,
      msg: paymentMethod.isActive
        ? "Payment Method Deactivated!"
        : "Payment Method Activated!",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const updateCategory = async (req, res) => {
  logger.info("Inside Update Category Controller");
  try {
    var categoryData = await CategoryModel.findOne({
      _id: mongoose.Types.ObjectId(req.body._id),
    });
    if (req.body.newCategoryImage) {
      await unlink(`admin/${categoryData.image}`);
      const imagePath = `${config.categoryImagePath}/${req.file.filename}`;
      const updatedData = await CategoryModel.updateOne(
        { _id: categoryData._id },
        {
          $set: {
            image: imagePath,
            name: req.body.categoryName,
          },
        }
      );
    } else {
      const updatedData = await CategoryModel.updateOne(
        { _id: categoryData._id },
        {
          $set: {
            name: req.body.categoryName,
          },
        }
      );
    }
    return handleResponse({
      res,
      msg: "Category updated Successfully.",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const uploadCSV = async (req, res) => {
  logger.info("At Upload CSV Controller");
  try {
    const workBook = new excelJS.Workbook();
    // await workBook.xlsx.readFile(req.file.path);
    await workBook.csv.readFile(req.file.path);
    let questionArray = [];
    let errorArray = [];
    let questionObj = { categoryId: req.body._id };
    await workBook.eachSheet((e) => {
      e.eachRow({ includeEmpty: false }, async (row, index) => {
        if (index === 1) {
          return;
        }
        let que = {
          ...questionObj,
          question: row.values?.[1],
          optionA: row.values?.[2].toString(),
          optionB: row.values?.[3].toString(),
          optionC: row.values?.[4].toString(),
          optionD: row.values?.[5].toString(),
          answer: row.values?.[6].toString(),
          level: row.values?.[7],
        };
        const { error } = await validateAddQuestion(que);
        if (error) {
          errorArray.push(error.message);
        }
        questionArray.push(que);
      });
    });

    if (errorArray.length > 0) {
      return handleError({ res, err: errorArray });
    }

    await QuestionModel.insertMany(questionArray);
    await unlink(req.file.path);

    return handleResponse({
      res,
      msg: "Question Addedd Successfully.",
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};
