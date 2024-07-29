import express from "express";
import { verifyUser } from "../../middleware/auth.js";
import { profilePicUpload } from "../../middleware/uploadFile.js";
import * as apiController from "./apiController.js";
import * as authController from "./authController.js";

const apiRoutes = express.Router();

// Global APIs
apiRoutes.post("/register", authController.register);
apiRoutes.get("/login", authController.login);
apiRoutes.get("/appSettings", apiController.getAppSettings);

// Private APIs
apiRoutes.put("/logout", verifyUser, authController.logout);
apiRoutes.get(
  "/featureCategories",
  verifyUser,
  apiController.getFeatureCategories
);
apiRoutes.get("/campuses", verifyUser, apiController.getCampuses);
apiRoutes.get("/securityQuestions", verifyUser, apiController.getSecurityQuestions);
apiRoutes.get("/categories", verifyUser, apiController.getCategories);
apiRoutes.get("/questions", verifyUser, apiController.getQuestions);
apiRoutes.post("/addPoints", verifyUser, apiController.addPoints);
apiRoutes.get("/topUsers", verifyUser, apiController.topUsers);
apiRoutes.post(
  "/profile",
  verifyUser,
  profilePicUpload.single("profilePic"),
  apiController.updateProfile
);
apiRoutes.get("/myProfile", verifyUser, apiController.getMyProfile);
apiRoutes.delete("/profilePic", verifyUser, apiController.deleteProfilePic);
apiRoutes.get("/paymentGateways", verifyUser, apiController.getPaymentGateways);
apiRoutes.post("/withdraw", verifyUser, apiController.createWithdraw);
apiRoutes.post("/userAnswers", apiController.saveUserAnswer)
apiRoutes.get("/withdrawals", verifyUser, apiController.getWithdrawals);
apiRoutes.post("/contactus", verifyUser, apiController.addContactUs);
apiRoutes.get("/ruleofquiz", verifyUser, apiController.getRuleOfQuiz);
apiRoutes.get("/privacypolicy", verifyUser, apiController.getPrivacyPolicy);
apiRoutes.get("/termsofuse", verifyUser, apiController.getTermsOfUse);

export default apiRoutes;
