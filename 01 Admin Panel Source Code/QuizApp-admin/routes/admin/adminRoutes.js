import express from "express";
import { logout, verifyLogin } from "./authController.js";

const adminRoutes = express.Router();

adminRoutes.post("/login", verifyLogin);
adminRoutes.get("/logout", logout);

export default adminRoutes;
