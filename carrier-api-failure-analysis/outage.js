const csv = require("csvtojson");

module.exports = async function getOutages(
   data,
   cutoff,
   alertCount,
   resolveCount
) {
   const times = data.map((d) => new Date(d.time));
   const events = data.map((d) => d.failure_rate);

   let inOutage = false;
   const outages = [];
   for (let i = 0; i < events.length; i++) {
      if (!inOutage) {
         if (checkLastNForAlert(i, alertCount, cutoff, events)) {
            inOutage = true;
            outages.push({
               outage: true,
               time: times[i],
            });
         }
         continue;
      }

      if (checkLastNForResolve(i, resolveCount, cutoff, events)) {
         inOutage = false;

         outages.push({
            outage: false,
            time: times[i],
         });
      }
   }

   return outages;
};

function checkLastNForAlert(i, n, alertCutoff, events) {
   let j = i - n + 1;
   if (j < 0) {
      j = 0;
   }

   for (; j <= i; j++) {
      if (events[j] <= alertCutoff) {
         return false;
      }
   }

   return true;
}

function checkLastNForResolve(i, n, resolveCutoff, events) {
   let j = i - n + 1;
   if (j < 0) {
      j = 0;
   }

   for (; j <= i; j++) {
      if (events[j] > resolveCutoff) {
         return false;
      }
   }

   return true;
}
