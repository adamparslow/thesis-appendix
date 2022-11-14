const getOutages = require("./outage");

function processOutage(outages) {
   const processedOutages = [];
   let newOutages = outages;

   if (outages.length % 2 !== 0) {
      newOutages = outages.slice(0, outages.length - 1);
   }

   for (let i = 0; i < newOutages.length; i += 2) {
      processedOutages.push({
         start: newOutages[i].time,
         end: newOutages[i + 1].time,
      });
   }
   return processedOutages;
}

function pushOntoResults(results, tag, value) {
   if (!results[tag]) {
      results[tag] = [];
   }

   results[tag].push(value);
}

async function analyseOutage(file, cutoff, alertCount, resolveCount, results) {
   const outageData = require(file);
   const actualOutages = outageData.trueOutages.map((outage) => {
      return {
         start: new Date(outage.start),
         end: new Date(outage.end),
      };
   });
   const outages = await getOutages(
      outageData.data,
      cutoff,
      alertCount,
      resolveCount
   );
   const tag = `a${alertCount}r${resolveCount}c${cutoff}`;
   const processedOutages = processOutage(outages);

   if (processedOutages.length < actualOutages.length) {
      pushOntoResults(results, tag, {
         success: false,
         message: "FALSE NEGATIVE",
      });
   } else if (processedOutages.length > actualOutages.length) {
      pushOntoResults(results, tag, {
         success: false,
         message: "FALSE POSITIVE",
      });
   } else {
      if (processedOutages.length === 0) {
         pushOntoResults(results, tag, {
            success: true,
         });
      }
      for (let i = 0; i < processedOutages.length; i++) {
         const mtta =
            (processedOutages[i].start.getTime() -
               actualOutages[i].start.getTime()) /
            1000 /
            60;
         const mttra =
            (processedOutages[i].end.getTime() -
               actualOutages[i].end.getTime()) /
            1000 /
            60;
         pushOntoResults(results, tag, {
            success: true,
            mtta: mtta,
            mttra: mttra,
         });
      }
   }
}

module.exports = async function iterateVariables(file) {
   let results = {};
   let promises = [];
   for (let cutoff = 5; cutoff <= 100; cutoff += 5) {
      for (let i = 1; i <= 15; i++) {
         for (let j = 1; j <= i; j++) {
            promises.push(analyseOutage(file, cutoff, i, j, results));
         }
      }
   }

   await Promise.all(promises);
   return results;
};
