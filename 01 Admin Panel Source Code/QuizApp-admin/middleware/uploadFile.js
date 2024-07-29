import multer from "multer";
import config from "../config/index.js";

let profileStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, `admin/${config.profilePicPath}`);
  },
  filename: (req, file, cb) => {
    if (req?.session?.user?.isDemoAdmin === false) {
      cb(null, `${Date.now()}_${file.originalname}`);
    } else {
      let extArray = file.mimetype.split("/");
      let extension =
        extArray[extArray.length - 1] === "octet-stream"
          ? "heic"
          : extArray[extArray.length - 1];
      cb(null, req.userId + "-" + Date.now() + "." + extension);
    }
  },
});

let profilePicUpload = multer({
  storage: profileStorage,
  fileFilter: (req, file, cb) => {
    if (
      file.mimetype == "image/png" ||
      file.mimetype == "image/jpg" ||
      file.mimetype == "image/jpeg" ||
      file.mimetype == "image/x-icon" ||
      file.mimetype == "application/octet-stream"
    ) {
      cb(null, true);
    } else {
      cb(null, false);
      return cb("Only .png, .jpg and .jpeg format allowed!");
    }
  },
});

let categoryStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, `admin/${config.categoryImagePath}`);
  },
  filename: (req, file, cb) => {
    cb(
      null,
      req.body.categoryName + "-" + Date.now() + "-" + file.originalname
    );
  },
});

let categoryUpload = multer({
  storage: categoryStorage,
  fileFilter: (req, file, cb) => {
    if (req.body.categoryName.trim() === "") {
      return cb("Category name required");
    } else {
      if (
        file.mimetype == "image/png" ||
        file.mimetype == "image/jpg" ||
        file.mimetype == "image/jpeg" ||
        file.mimetype == "image/x-icon"
      ) {
        cb(null, true);
      } else {
        cb(null, false);
        return cb("Only .png, .jpg and .jpeg format allowed!");
      }
    }
  },
});

let bannerStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, `admin/${config.bannerImagePath}`);
  },
  filename: (req, file, cb) => {
    cb(null, `banner-${Date.now()}-${file.originalname}`);
  },
});

let bannerUpload = multer({
  storage: bannerStorage,
  fileFilter: (req, file, cb) => {
    if (
      file.mimetype == "image/png" ||
      file.mimetype == "image/jpg" ||
      file.mimetype == "image/jpeg" ||
      file.mimetype == "image/x-icon"
    ) {
      cb(null, true);
    } else {
      cb(null, false);
      return cb("Only .png, .jpg and .jpeg format allowed!");
    }
  },
});

let paymentStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, `admin/${config.paymentPicPath}`);
  },
  filename: (req, file, cb) => {
    let extArray = file.mimetype.split("/");
    let extension = extArray[extArray.length - 1];
    cb(null, `${req.body.name}-${Date.now()}.${extension}`);
  },
});

let paymentUpload = multer({
  storage: paymentStorage,
  fileFilter: (req, file, cb) => {
    if (
      file.mimetype == "image/png" ||
      file.mimetype == "image/jpg" ||
      file.mimetype == "image/jpeg" ||
      file.mimetype == "image/x-icon"
    ) {
      cb(null, true);
    } else {
      cb(null, false);
      return cb("Only .png, .jpg and .jpeg format allowed!");
    }
  },
});

let csvStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, `admin/${config.csvPath}`);
  },
  filename: (req, file, cb) => {
    cb(null, `${req.body._id}-${file.originalname.trim()}`);
  },
});

let csvUpload = multer({
  storage: csvStorage,
});

let notificationStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, `admin/${config.notificationPath}`);
  },
  filename: (req, file, cb) => {
    cb(null, `${file.originalname.trim()}`);
  },
});

let notificationUpload = multer({
  storage: notificationStorage,
});

let appIconStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, `admin/${config.appIconPath}`);
  },
  filename: (req, file, cb) => {
    cb(null, `${file.originalname.trim()}`);
  },
});

let appIconUpload = multer({ storage: appIconStorage });

export {
  profilePicUpload,
  categoryUpload,
  bannerUpload,
  paymentUpload,
  csvUpload,
  notificationUpload,
  appIconUpload,
};
