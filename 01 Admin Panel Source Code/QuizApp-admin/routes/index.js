import express from "express";
import adminRoutes from "./admin/adminRoutes.js";
import apiRoutes from "./api/index.js";
import appRoutes from "./app/appRoute.js";

const mainRoute = express.Router();

// mainRoute.use("/api");
mainRoute.use("/admin", adminRoutes);
mainRoute.use("/", appRoutes);
mainRoute.use("/api/v1", apiRoutes);

export default mainRoute;
