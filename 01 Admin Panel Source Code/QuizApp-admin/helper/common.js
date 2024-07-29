import bcryptjs from "bcryptjs";

const generateEncryptedPassword = async (password) => {
  const hashedPassword = bcryptjs.hash(password, 10);
  return hashedPassword;
};

const compareEncryptedPassword = async (incomingPwd, encryptedPwd) => {
  const hashedPwd = bcryptjs.compare(incomingPwd, encryptedPwd);
  return hashedPwd;
};

export { generateEncryptedPassword, compareEncryptedPassword };
