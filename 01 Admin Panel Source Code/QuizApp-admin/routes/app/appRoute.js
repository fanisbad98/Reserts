import express from "express";
import { verifyAdmin } from "../../middleware/auth.js";
import {
  appIconUpload,
  bannerUpload,
  categoryUpload,
  csvUpload,
  notificationUpload,
  paymentUpload,
  profilePicUpload,
} from "../../middleware/uploadFile.js";
import {
  addCategory,
  addCampus,
  addPaymentGateway,
  addQuetions,
  addSecurityQuestion,
  renderNotification,
  renderAdsSettings,
  renderAppSettings,
  renderCategories,
  renderDashboard,
  renderHomeScreenBanner,
  renderLogin,
  renderPaymentSettings,
  renderQuestions,
  renderQuestionsByCategory,
  renderUsers,
  renderWithdrawals,
  renderCampuses,
  updateAppSetting,
  updateBanner,
  updateWithdraw,
  updateUserStatus,
  updateCategoryFeature,
  updateCategoryStatus,
  updateCategory,
  updatePaymentMethosStatus,
  deleteCategory,
  deletePaymentMethod,
  uploadCSV,
  changePassword,
  sendNotification,
  renderContactUs,
  renderAdminSetting,
  updateAdminSetting,
  deleteQuestion,
  deleteUserAnswers,
  deleteCampus,
  renderSecurityQuestions,
  renderUserAnswers,
  deleteSecurityQuestion,
} from "./appController.js";
import { verify } from "jsonwebtoken";

const appRoutes = express.Router();

// Renders
appRoutes.get("/login", renderLogin);
appRoutes.get("/dashboard", renderDashboard);
appRoutes.get("/homeScreenBanner", renderHomeScreenBanner);
appRoutes.get("/users", renderUsers);
appRoutes.get("/contactus", renderContactUs);
appRoutes.get("/categories", renderCategories);
appRoutes.get("/questions/:categoryId", renderQuestions);
appRoutes.get("/questions", renderQuestionsByCategory);
appRoutes.get("/withdrawals", renderWithdrawals);
appRoutes.get("/pushNotification", renderNotification);
appRoutes.get("/appSettings", renderAppSettings);
appRoutes.get("/adsSettings", renderAdsSettings);
appRoutes.get("/paymentSettings", renderPaymentSettings);
appRoutes.get("/adminSettings", renderAdminSetting);
appRoutes.get("/campuses", renderCampuses);
appRoutes.get("/securityQuestions", renderSecurityQuestions);
appRoutes.get("/userAnswers", renderUserAnswers);
// appRoutes.get("/adminSettings");

// Admin Actions
appRoutes.post(
  "/bannerImage",
  verifyAdmin,
  bannerUpload.single("bannerImage"),
  updateBanner
);
appRoutes.delete("/userAnswers/:id", verifyAdmin, deleteUserAnswers);
appRoutes.post("/addSecurityQuestions", verifyAdmin, addSecurityQuestion);
appRoutes.post(
  "/addSecurityQuestion",
  verifyAdmin,
  csvUpload.single("csvFile"),
  uploadCSV
);
appRoutes.post(
  "/addCampus",
  verifyAdmin,
  addCampus
);
appRoutes.delete(
  "/securityQuestion/:id",
  verifyAmdin,
  deleteSecurityQuestion
)
appRoutes.post(
  "/addCategory",
  verifyAdmin,
  categoryUpload.single("categoryImage"),
  addCategory
);
appRoutes.post(
  "/paymentGateway",
  verifyAdmin,
  paymentUpload.single("image"),
  addPaymentGateway
);
appRoutes.post(
  "/updateCategory",
  verifyAdmin,
  categoryUpload.single("newCategoryImage"),
  updateCategory
);
appRoutes.post(
  "/bulkQuestion",
  verifyAdmin,
  csvUpload.single("csvFile"),
  uploadCSV
);
appRoutes.post("/changePassword", verifyAdmin, changePassword);
appRoutes.post(
  "/pushNotification",
  verifyAdmin,
  notificationUpload.single("notificationImage"),
  sendNotification
);
appRoutes.patch("/withdraw/:id", verifyAdmin, updateWithdraw);
appRoutes.patch("/userStatus/:id", verifyAdmin, updateUserStatus);
appRoutes.patch("/category/feature/:id", verifyAdmin, updateCategoryFeature);
appRoutes.patch("/category/status/:id", verifyAdmin, updateCategoryStatus);
appRoutes.delete("/category/:id", verifyAdmin, deleteCategory);
appRoutes.delete("/campuses/:id", verifyAdmin, deleteCampus);
appRoutes.patch(
  "/paymentMethod/status/:id",
  verifyAdmin,
  updatePaymentMethosStatus
);
appRoutes.delete("/paymentMethod/:id", verifyAdmin, deletePaymentMethod);
appRoutes.post("/addQuestions", verifyAdmin, addQuetions);
appRoutes.delete("/question/:id", verifyAdmin, deleteQuestion);
appRoutes.post(
  "/updateAppSetting",
  verifyAdmin,
  profilePicUpload.single("userPlaceholder"),
  updateAppSetting
);
appRoutes.post(
  "/updateAdminSetting",
  verifyAdmin,
  appIconUpload.single("appIcon"),
  updateAdminSetting
);

export default appRoutes;
