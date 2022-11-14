# Adam's Parslows Thesis Code

This GitHub repository is where you can find all the code relating to my thesis. The files in this repo are described below: 
- `carrier-api-failure-analysis`: the node project that emulates the outages to determine which parameters will work. 
- `courier_api_dashboard.tf`: the terraform code for the courier dashboard. A visual depiction of this dashboard can be found in autoref{sec:dashboards}.
- `http_client.rb`: a generic HTTP client used within Shippit. 
- `label_client.rb`: a specific label client that produces the errors used for the alert seen in autoref{fig:labelFailAlert}.
- `label_failure.tf`: the terraform code for the label failure alert seen in autoref{fig:labelFailAlert}.
- `logs_to_metrics.tf`: the terraform code that sets up the parsing of the logs to create the metrics. 
- `outage_detection_alert.tf`: the terraform code for the outage detection alert.
- `tracing_setup.rb`: the ruby configuration code to enable tracing over our http clients. 
