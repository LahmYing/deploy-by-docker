let fs = require("fs");
let Path = require("path");
let minify = require("html-minifier").minify;
let rootPath = "./public";

// 遍历目录
let traversePath = (path) => {
  if (fs.existsSync(path)) {
    // 读取目录
    files = fs.readdirSync(path);
    files.forEach(function (file, index) {
      let curPath = path + "/" + file;
      // 文件夹
      if (fs.statSync(curPath).isDirectory()) {
        traversePath(curPath);
      } else {
        if (
          Path.extname(curPath) === ".html" ||
          Path.extname(curPath) === ".htm"
        ) {
          compressHtml(curPath);
        }
      }
    });
  }
};

let compressHtml = (filePath) => {
  fs.readFile(filePath, "utf8", function (err, data) {
    if (err) {
      // throw err;
      console.log(`err readFile = ${filePath}`);
    } else {
      // 删除
      fs.unlink(filePath, (err) => {
        if (err) {
          // throw err;
          console.log(`err deleted = ${filePath}`);
        } else {
          fs.writeFile(
            filePath,
            minify(data, {
              removeComments: true,
              collapseWhitespace: true,
              minifyJS: true,
              minifyCSS: true,
            }),
            function () {
              console.log(`compressHtml = ${filePath}`);
            }
          );
        }
      });
    }
  });
};

traversePath(rootPath);
