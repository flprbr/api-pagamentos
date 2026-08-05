const express = require("express");
const app = express();
const port = process.env.PORT || 8080;

app.get("/", (req, res) => res.send("api-pagamentos running"));
app.get("/health", (req, res) => res.json({ status: "ok" }));

app.listen(port, "0.0.0.0", () => {
  console.log(`api-pagamentos ouvindo na porta ${port}`);
});
