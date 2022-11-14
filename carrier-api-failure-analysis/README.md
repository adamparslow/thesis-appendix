This repo has a few scripts to analyse outage data collected for Sumologic (and in the future datadog) and determine what is the best algorithm for detecting these outages. 

# `npm run analyse`
This command will run a script that takes the outage data in `Processed Data` and emulates outages based on a set of parameters. It compares what the emulated outage would alert with the true outage, and determines if it has done so successfully. 