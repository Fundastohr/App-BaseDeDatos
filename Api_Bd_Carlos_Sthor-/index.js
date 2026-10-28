process.env.TZ = "America/Caracas";
const pg = require("pg");
// Evitar que node-postgres convierta DATE a objeto Date con desfase horario UTC
pg.types.setTypeParser(1082, (str) => str);

const express = require("express");
const cors = require("cors");
const app = express();
const port = 3002;
const Participantes = require("./Routes/Participantes");
const Concurso = require("./Routes/Concurso.js");
const Exposicion = require("./Routes/Exposicion.js");
const taller = require("./Routes/Taller.js");
const Routes_Obra = require("./Routes/Routes_Obra.js");
const Routes_Encuentro = require("./Routes/Routes_Encuentro.js");

app.use(express.json());
app.use(cors());

app.get("/", (req, res) => {
  res.send("¡Hola, mundo!");
});

app.listen(port, () => {
  console.log(`API escuchando en el puerto ${port}`);
});

app.use("/Participantes", Participantes);
app.use("/Concurso", Concurso);
app.use("/Exposicion", Exposicion);
app.use("/taller", taller);
app.use("/Obras", Routes_Obra);
app.use("/encuentro", Routes_Encuentro);
