import mongoose from "mongoose";
import { unlink } from "fs/promises";
import config from "../../config/index.js";
import logger from "../../config/logger.js";
import { handleError, handleResponse } from "../../config/reqHandler.js";
import { CategoryModel } from "../../models/categories.js";
import { QuestionModel } from "../../models/questions.js";
import { SettingModel } from "../../models/settings.js";
import { UserModel } from "../../models/user.js";
import { PaymentMethodModel } from "../../models/paymentMethod.js";
import UserAnswerModel, {UserAnswers} from "../../models/userAnswers.js";

import {
  validateCreateReq,
  WithdrawReqModel,
} from "../../models/withdrawReq.js";
import {
  addContactUsValidation,
  ContactUsModel,
} from "../../models/contactUs.js";
import { size } from "lodash";
import { error } from "console";

export const getFeatureCategories = async (req, res) => {
  logger.info("at getFeatureCategory Controller");
  try {
    const categories = await CategoryModel.find(
      { isFeature: true, isActive: true },
      { name: 1, image: 1 }
    );
    return handleResponse({ res, data: categories });
  } catch (err) {
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const saveUserAnswer = async(req, res) =>{
  try{
    const {questionId, selectedAnswer, userId, categoryId, lvl} = req.body;
    if(!questionId || !selectedAnswer || !userId || !categoryId || !lvl){
      return handleError({
        res,
        statusCode: 400,
        err_msg: "All fields are required",
      });
    }

    const userAnswer = new  UserAnswerModel({
      questionId: questionId,
      selectedAnswer: selectedAnswer,
      userId:userId,
      categoryId:categoryId,
      lvl:lvl,
    });
    await userAnswer.save();
    return handleResponse({
      res,
      msg: "User answer saved successfully",
    });
  } catch(err){
    return handleError({
      res,
      statusCode: err.statusCode ?? 500,
      err_msg: err.message || "Something went wrong",
    });
  }
};

export const joinCampus = async (req, res) =>{
  const {campusId } = req.params;
  const { userId} = req.body;

  try{
    const campus = await CampusModel.findById(campusId);
    if(!campus){
      throw new Error("Campus not found");
    }
    if (campus.members.includes (userId)){
      throw new Error("User is already a member of the campus");
    }

    campus.members.push(userId);
    await campus.save();
    return res.status(200).json({ message: "User joined the campus successfully"});
  }catch (error){
    console.error('Error joining campus:',error.message);
    return res.status(500).json({ error: "Failed to join campus. Please try again later."});
  }
};

export const getCategories = async (req, res) => {
  logger.info("at getCategories Controller");
  try {
    const categories = await CategoryModel.find(
      { isActive: true },
      { name: 1, image: 1 }
    );
    return handleResponse({ res, data: categories });
  } catch (err) {
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};



export const getCampuses = async (req, res) => {
  logger.info("at getCampuses Controller");
  try{
    const campuses = await CampusModel.find({});
    return handleResponse({res, data: campuses});
  }catch(err){
    return handleError({
      res,
      statusCode: err.statusCode ?? 500,
      err_msg: err.message || "Someting went wrong",
    });
  }
};


export const getSecurityQuestions = async (req, res) =>{
  logger.info ("at getSecurityQuestions Controller");
  try{
    const securityQuestions = await SecurityQuestionModelstion.aggregate([
      {
        $sample: {
          size:10,
        },
      },
      {
        $project:{
          _id:0,
          question: 1,
          optionA: 1,
          optionB: 1,
          optionC: 1,
          optionD: 1,
        },
      },
    ]);
    if (securityQuestions.length < 10){
      return handleError({
        res,
        err_msg: "No security Question Found",
      });
    }
    return handleResponse({
      res,
      data: securityQuestions,
    });
  }catch (err){
    return handleError({
      res,
      statusCode: err.statusCode ?? 500,
      err_msg:err.message || "Something went wrong",
    });
  }
};

export const getQuestions = async (req, res) => {
  logger.info("at getCategories Controller");
  try {
    const { id, level } = req.query;

    const questions = await QuestionModel.aggregate([
      {
        $match: {
          categoryId: mongoose.Types.ObjectId(id),
          level: level,
        },
      },
      {
        $sample: {
          size: 10,
        },
      },
      {
        $project: {
          _id: 0,
          question: 1,
          optionA: 1,
          optionB: 1,
          optionC: 1,
          optionD: 1,
        },
      },
    ]);

    if (questions.length < 10) {
      return handleError({
        res,
        err_msg: "No Question Found",
      });
    }

    return handleResponse({
      res,
      data: questions,
    });
  } catch (err) {
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const getAppSettings = async (req, res) => {
  logger.info("at getAppSetting Controller");
  try {
    const data = await SettingModel.findOne(
      {},
      {
        _id: 0,
        createdAt: 0,
        updatedAt: 0,
        __v: 0,
        oneSignalSecretKey: 0,
        ruleOfQuiz: 0,
        privacyPolicy: 0,
        termsOfUse: 0,
        appIcon: 0,
        appName: 0,
      }
    )
      .sort({ _id: -1 })
      .lean();

    return handleResponse({
      res,
      data: data,
    });
  } catch (err) {
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const getRuleOfQuiz = async (req, res) => {
  logger.info("at get Rule of Quiz controller");
  try {
    const data = await SettingModel.findOne({}, { ruleOfQuiz: 1, _id: 0 })
      .sort({ _id: -1 })
      .lean();
    return handleResponse({ res, data: data });
  } catch (error) {
    return handleError({
      res,
      statusCode: error.statusCode ?? 401,
      err_msg: error.message || "Something went Wrong",
    });
  }
};

export const getPrivacyPolicy = async (req, res) => {
  logger.info("at get Privacy Policy controller");
  try {
    const data = await SettingModel.findOne({}, { _id: 0, privacyPolicy: 1 })
      .sort({ _id: -1 })
      .lean();
    return handleResponse({ res, data: data });
  } catch (error) {
    return handleError({
      res,
      statusCode: error.statusCode ?? 401,
      err_msg: error.message || "Something went Wrong",
    });
  }
};

export const getTermsOfUse = async (req, res) => {
  logger.info("at get Terms of Use controller");
  try {
    const data = await SettingModel.findOne({}, { _id: 0, termsOfUse: 1 })
      .sort({ _id: -1 })
      .lean();
    return handleResponse({ res, data: data });
  } catch (error) {
    return handleError({
      res,
      statusCode: error.statusCode ?? 401,
      err_msg: error.message || "Something went Wrong",
    });
  }
};

export const addPoints = async (req, res) => {
  logger.info("at addPoints Controller");
  try {
    const { point } = req.body;
    const updatedData = await UserModel.findOneAndUpdate(
      {
        _id: mongoose.Types.ObjectId(req.userId),
      },
      { $inc: { totalPoints: point } },
      {
        projection: { totalPoints: 1 },
        returnDocument: "after",
      }
    );
    return handleResponse({
      res,
      data: updatedData,
    });
  } catch (err) {
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const getMyProfile = async (req, res) => {
  logger.info("at Get My Profile controller");
  try {
    const appSetting = await SettingModel.findOne({}, { userPlaceholder: 1 })
      .sort({ _id: -1 })
      .lean();
    const data = await UserModel.findOne(
      { _id: req.userId },
      {
        referedBy: 0,
        isReferralPointRedeem: 0,
        token: 0,
        userStatus: 0,
        createdAt: 0,
        updatedAt: 0,
        _id: 0,
      }
    );
    data.profilePic =
      data.profilePic == "" ? appSetting.userPlaceholder : data.profilePic;
    return handleResponse({
      res,
      data: data,
    });
  } catch (error) {
    return handleError({
      res,
      statusCode: error.statusCode ?? 401,
      err_msg: error.message || "Something went Wrong",
    });
  }
};

export const topUsers = async (req, res) => {
  logger.info("at Top Users Controller");
  try {
    const appSetting = await SettingModel.findOne({}, { userPlaceholder: 1 })
      .sort({ _id: -1 })
      .lean();

    const users = await UserModel.aggregate([
      {
        $sort: {
          totalPoints: -1,
        },
      },
      {
        $limit: 10,
      },
      {
        $project: {
          totalPoints: 1,
          name: {
            $arrayElemAt: [
              {
                $split: ["$name", " "],
              },
              0,
            ],
          },
          profilePic: {
            $cond: {
              if: {
                $eq: ["$profilePic", ""],
              },
              then: appSetting.userPlaceholder,
              else: "$profilePic",
            },
          },
        },
      },
    ]);
    return handleResponse({
      res,
      data: users,
    });
  } catch (err) {
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const updateProfile = async (req, res) => {
  logger.info("Inside Update Profile Controller");
  try {
    var oldImgPath = await UserModel.findOne(
      { _id: mongoose.Types.ObjectId(req.userId) },
      { profilePic: 1 }
    );
    if (req.file && oldImgPath.profilePic != "") {
      if (oldImgPath.profilePic != "") {
        await unlink(`admin/${oldImgPath.profilePic}`);
      }
    }

    const imagePath = req.file
      ? `${config.profilePicPath}/${req.file.filename}`
      : oldImgPath.profilePic;
    const updatedData = await UserModel.findOneAndUpdate(
      { _id: req.userId },
      {
        $set: {
          profilePic: imagePath,
          name: req.body.name,
        },
      },
      {
        projection: { profilePic: 1, name: 1 },
        returnDocument: "after",
      }
    );
    return handleResponse({
      res,
      msg: "Profile updated Successfully.",
      data: updatedData,
    });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const deleteProfilePic = async (req, res) => {
  logger.info("Inside Delete Profile Picture Controller");
  try {
    var userData = await UserModel.findOne(
      { _id: mongoose.Types.ObjectId(req.userId) },
      { profilePic: 1 }
    );

    if (userData.profilePic != "") {
      await unlink(`admin/${userData.profilePic}`);
      userData.profilePic = "";
      await userData.save();
    } else {
      return handleError({ res, err_msg: "No Prodile pic found" });
    }
    return handleResponse({ res, msg: "profile picture removed" });
  } catch (error) {
    logger.error(error);
    return handleError({ res, err: error });
  }
};

export const getPaymentGateways = async (req, res) => {
  logger.info("at getPaymentGateways Controller");
  try {
    const payments = await PaymentMethodModel.find({ isActive: true }).sort({
      _id: -1,
    });
    return handleResponse({ res, data: payments });
  } catch (err) {
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const createWithdraw = async (req, res) => {
  logger.info("at Create Withdraw Request Controller");
  try {
    const { error } = validateCreateReq(req.body);
    if (error) {
      return handleError({ res, err_msg: error.message });
    }
    const userData = await UserModel.findById(
      mongoose.Types.ObjectId(req.userId)
    );

    if (userData.totalPoints >= req.body.points) {
      const updatePoints = await UserModel.findByIdAndUpdate(
        mongoose.Types.ObjectId(req.userId),
        {
          $inc: {
            totalPoints: -req.body.points,
          },
        },
        {
          returnDocument: "after",
        }
      );
      const { totalPoints, ...rest } = updatePoints;
      const withdrawReq = new WithdrawReqModel({
        ...req.body,
        userId: mongoose.Types.ObjectId(req.userId),
      });
      await withdrawReq.save();

      return handleResponse({
        res,
        msg: "Withdrawal Request created Successfully",
        data: { totalPoints },
      });
    } else {
      return handleError({
        res,
        err_msg: "You don't have Enough Points",
      });
    }
  } catch (err) {
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const getWithdrawals = async (req, res) => {
  logger.info("at Get Withdrawals history Controller");
  try {
    const withdrawals = await WithdrawReqModel.find({
      userId: mongoose.Types.ObjectId(req.userId),
    })
      .populate("paymentMethod")
      .sort({ _id: -1 });
    return handleResponse({ res, data: withdrawals });
  } catch (err) {
    return handleError({
      res,
      statusCode: err.statusCode ?? 401,
      err_msg: err.message || "Something went Wrong",
    });
  }
};

export const addContactUs = async (req, res) => {
  logger.info("at Add Contact Us Controller");
  try {
    const { error } = await addContactUsValidation(req.body);
    if (error) {
      return handleError({ res, err_msg: error.message });
    }
    const contactUs = await ContactUsModel.create({
      ...req.body,
      createdBy: mongoose.Types.ObjectId(req.userId),
    });
    await contactUs.save();

    return handleResponse({ res, msg: "Request Created Successfully" });
  } catch (error) {
    return handleError({
      res,
      statusCode: error.statusCode ?? 401,
      err_msg: error.message || "Something went Wrong",
    });
  }
};


