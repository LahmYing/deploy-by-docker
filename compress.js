let fs = require("fs");
let Path = require("path");
let minify = require("html-minifier").minify;

// use old version avoid error like 'Must use import to load ES Module: /node_modules/imagemin/index.js'
// Same as imageminJpegtran and imageminPngquant
let imagemin = require("imagemin");
let imageminJpegtran = require("imagemin-jpegtran");
let imageminPngquant = require("imagemin-pngquant");

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
        let extname = Path.extname(curPath);
        switch (extname) {
          case ".html":
          case ".htm":
            compressHtml(curPath);
            break;
          case ".png":
          case ".jpg":
          case ".jpeg":
            compressImage(curPath);
            break;
          default:
            break;
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
      // fs.unlink(filePath, (err) => {
      //   if (err) {
      //     // throw err;
      //     console.log(`err deleted = ${filePath}`);
      //   } else {
      //     fs.writeFile(
      //       filePath,
      //       minify(data, {
      //         removeComments: true,
      //         collapseWhitespace: true,
      //         minifyJS: true,
      //         minifyCSS: true,
      //       }),
      //       function () {
      //         console.log(`compressHtml = ${filePath}`);
      //       }
      //     );
      //   }
      // });
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
};

let compressImage = (filePath) => {
  let image;
  let len = filePath.lastIndexOf("/");
  let destination = filePath.slice(0, len);
  imagemin([filePath], {
    // 目标文件夹
    destination: destination,
    plugins: [
      imageminJpegtran(),
      imageminPngquant({
        quality: [0.6, 0.8],
      }),
    ],
  }).then((result) => {
    // 直接替换
    /** 
      fs.unlink(filePath, (err) => {
        if (err) {
          // throw err;
          console.log(`err deleted image = ${filePath}`);
        } else {
          image = result;
          // console.log(image);
        }
      });
      */
    image = result;
  });
  // .catch((error) => { // imagemin 这插件不会报错，不会运行至此
  //   console.log(`error compressImage = ${filePath}`);
  // });
};

// compressImage("./public/img/scrollup.png");

traversePath(rootPath);
