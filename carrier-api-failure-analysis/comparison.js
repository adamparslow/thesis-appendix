const iterateVariables = require("./analyse");
const path = require("path");
const fs = require("fs");

const DATA_FOLDER = "Processed Data";

function getFileData() {
   const files = fs.readdirSync(path.join(__dirname, DATA_FOLDER));
   const fileData = [];

   for (let file of files) {
      const courier = file.split(" ")[0];
      const time = file.split(" ")[1].split(".")[0];

      fileData.push({
         file: file,
         time: time,
      });
   }

   return fileData;
}

async function compare() {
   let results = {};

   for (let fd of getFileData()) {
      console.log(fd);
      const result = await iterateVariables(
         path.join(__dirname, DATA_FOLDER, fd.file)
      );

      for (let key in result) {
         const newKey = key + "t" + fd.time;
         if (!(newKey in results)) {
            results[newKey] = [];
         }

         results[newKey].push(result[key][0]);
      }
   }

   let csvFileData =
      "Time,Cutoff,AmountBeforeAlert,AmountBeforeResolution,MTTA,MTTRA";

   for (let key in results) {
      if (!checkIfSuccessful(results[key])) {
         delete results[key];
         continue;
      }

      const time = key.split("t")[1];
      const cutoff = key.split("t")[0].split("c")[1];
      const resolve = key.split("t")[0].split("c")[0].split("r")[1];
      const alert = key.split("t")[0].split("c")[0].split("r")[0].split("a")[1];

      const mtta =
         parseInt(key.slice(1, key.length).split("r")[0]) *
         generateTimeFactor(time);
      const mttra =
         parseInt(key.slice(1, key.length).split("r")[1].split("c")[0]) *
         generateTimeFactor(time);

      console.log(`${key} | MTTA: ${mtta}. MTTRA: ${mttra}`);
      csvFileData += `\r\n${time},${cutoff},${alert},${resolve},${mtta},${mttra}`;
   }

   fs.writeFileSync("results.csv", csvFileData);
}

function checkIfSuccessful(result) {
   for (let r of result) {
      if (!r.success) return false;
   }
   return true;
}

function generateTimeFactor(time) {
   if (time.includes("h")) {
      return 60;
   }

   return parseInt(time.slice(0, time.length - 1));
}

compare();
