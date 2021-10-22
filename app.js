const Koa = require("koa"),
  views = require("koa-views"),
  serve = require("koa-static"),
  router = require("koa-router")();

const app = new Koa();

// 可以指定多个静态目录
// app.use(serve(__dirname + "/static"));
app.use(serve(__dirname + "/public"));

app.use(
  views("views", {
    map: {
      html: "ejs",
    },
  })
);

// router.prefix('/blog')

router.get("/", async (ctx) => {
  await ctx.render("index");
});

app.use(router.routes()).use(router.allowedMethods());

const port = 80;
app.listen(port, () => {
  console.log(`blog app serving at ${port} as a docker container...`);
});
