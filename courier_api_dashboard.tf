resource "datadog_dashboard_json" "courier_api_overview" {
  count = var.create_dashboards? 1 : 0
  dashboard = <<DASHBOARD
{
  "title": "Carrier API Overview",
  "description": "[Background of Courier/Integrations](https://shippit.atlassian.net/wiki/spaces/PCI/pages/2407989446/Carrier+Integration+External+Resource+Summary)",
  "widgets": [
    {
      "id": 4728430730205880,
      "definition": {
        "title": "Total API Requests by Carrier",
        "title_size": "16",
        "title_align": "left",
        "type": "toplist",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1",
                "limit": {
                  "count": 100,
                  "order": "desc"
                }
              }
            ],
            "response_format": "scalar",
            "queries": [
              {
                "search": {
                  "query": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value"
                },
                "data_source": "logs",
                "compute": {
                  "aggregation": "count"
                },
                "name": "query1",
                "indexes": [
                  "*"
                ],
                "group_by": [
                  {
                    "facet": "@carrier",
                    "sort": {
                      "aggregation": "count",
                      "order": "desc"
                    },
                    "limit": 100
                  }
                ]
              }
            ]
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 0,
        "width": 2,
        "height": 4
      }
    },
    {
      "id": 2491868600542690,
      "definition": {
        "title": "Total Request by Response Code",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "search": {
                  "query": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value"
                },
                "data_source": "logs",
                "compute": {
                  "interval": 600000,
                  "aggregation": "count"
                },
                "name": "query1",
                "indexes": [
                  "*"
                ],
                "group_by": [
                  {
                    "facet": "@http.status_code",
                    "sort": {
                      "aggregation": "count",
                      "order": "desc"
                    },
                    "limit": 10
                  }
                ]
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": false
        }
      },
      "layout": {
        "x": 2,
        "y": 0,
        "width": 5,
        "height": 4
      }
    },
    {
      "id": 7653671038494847,
      "definition": {
        "title": "Total Request by Function",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "search": {
                  "query": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value"
                },
                "data_source": "logs",
                "compute": {
                  "interval": 600000,
                  "aggregation": "count"
                },
                "name": "query1",
                "indexes": [
                  "*"
                ],
                "group_by": [
                  {
                    "facet": "@action",
                    "sort": {
                      "aggregation": "count",
                      "order": "desc"
                    },
                    "limit": 10
                  }
                ]
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": false
        }
      },
      "layout": {
        "x": 7,
        "y": 0,
        "width": 5,
        "height": 4
      }
    },
    {
      "id": 4609952293691370,
      "definition": {
        "title": "Onboarding",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "horizontal",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "search": {
                  "query": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value @action:(\"Others::RequestAccessToken\" OR \"Others::RequestAccountDetails\" OR \"Others::RegisterOrder\")"
                },
                "data_source": "logs",
                "compute": {
                  "interval": 600000,
                  "aggregation": "count"
                },
                "name": "query1",
                "indexes": [
                  "*"
                ],
                "group_by": [
                  {
                    "facet": "@http.status_code",
                    "sort": {
                      "aggregation": "count",
                      "order": "desc"
                    },
                    "limit": 10
                  }
                ]
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 4,
        "width": 3,
        "height": 3
      }
    },
    {
      "id": 8645135611152623,
      "definition": {
        "title": "Quoting",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "horizontal",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "search": {
                  "query": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value @action:Quote"
                },
                "data_source": "logs",
                "compute": {
                  "interval": 600000,
                  "aggregation": "count"
                },
                "name": "query1",
                "indexes": [
                  "*"
                ],
                "group_by": [
                  {
                    "facet": "@http.status_code",
                    "sort": {
                      "aggregation": "count",
                      "order": "desc"
                    },
                    "limit": 10
                  }
                ]
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ]
      },
      "layout": {
        "x": 3,
        "y": 4,
        "width": 3,
        "height": 3
      }
    },
    {
      "id": 2492572912521433,
      "definition": {
        "title": "Labeling",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "horizontal",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "search": {
                  "query": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value @action:Label"
                },
                "data_source": "logs",
                "compute": {
                  "interval": 600000,
                  "aggregation": "count"
                },
                "name": "query1",
                "indexes": [
                  "*"
                ],
                "group_by": [
                  {
                    "facet": "@http.status_code",
                    "sort": {
                      "aggregation": "count",
                      "order": "desc"
                    },
                    "limit": 10
                  }
                ]
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ]
      },
      "layout": {
        "x": 6,
        "y": 4,
        "width": 3,
        "height": 3
      }
    },
    {
      "id": 1017509461130446,
      "definition": {
        "title": "Other Functions",
        "title_size": "16",
        "title_align": "left",
        "requests": [
          {
            "query": {
              "query_string": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value -@action:(\"Others::RequestAccessToken\" OR \"Others::RequestAccountDetails\" OR Quote OR Label OR Booking OR Manifest OR Pickup OR Track OR Status OR Tracking)",
              "group_by": [
                {
                  "facet": "@action"
                },
                {
                  "facet": "@http.status_code"
                }
              ],
              "data_source": "logs_pattern_stream",
              "indexes": []
            },
            "columns": [
              {
                "field": "status_line",
                "width": "auto"
              },
              {
                "field": "@action",
                "width": "auto"
              },
              {
                "field": "@http.status_code",
                "width": "auto"
              },
              {
                "field": "volume",
                "width": "auto"
              },
              {
                "field": "matches",
                "width": "auto"
              }
            ],
            "response_format": "event_list"
          }
        ],
        "type": "list_stream"
      },
      "layout": {
        "x": 9,
        "y": 4,
        "width": 3,
        "height": 6
      }
    },
    {
      "id": 8973168331641095,
      "definition": {
        "title": "Booking",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "horizontal",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "search": {
                  "query": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value @action:(Book OR Booking OR Manifest)"
                },
                "data_source": "logs",
                "compute": {
                  "interval": 600000,
                  "aggregation": "count"
                },
                "name": "query1",
                "indexes": [
                  "*"
                ],
                "group_by": [
                  {
                    "facet": "@http.status_code",
                    "sort": {
                      "aggregation": "count",
                      "order": "desc"
                    },
                    "limit": 10
                  }
                ]
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 7,
        "width": 3,
        "height": 3
      }
    },
    {
      "id": 2055497390499325,
      "definition": {
        "title": "Pickup",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "horizontal",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "search": {
                  "query": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value @action:Pickup"
                },
                "data_source": "logs",
                "compute": {
                  "interval": 600000,
                  "aggregation": "count"
                },
                "name": "query1",
                "indexes": [
                  "*"
                ],
                "group_by": [
                  {
                    "facet": "@http.status_code",
                    "sort": {
                      "aggregation": "count",
                      "order": "desc"
                    },
                    "limit": 10
                  }
                ]
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ]
      },
      "layout": {
        "x": 3,
        "y": 7,
        "width": 3,
        "height": 3
      }
    },
    {
      "id": 4835089498400518,
      "definition": {
        "title": "Tracking",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "horizontal",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "response_format": "timeseries",
            "queries": [
              {
                "search": {
                  "query": "env:$env.value \"Requesting External Service\" @carrier:$carrier.value @action:(Track OR Status OR Tracking)"
                },
                "data_source": "logs",
                "compute": {
                  "interval": 600000,
                  "aggregation": "count"
                },
                "name": "query1",
                "indexes": [
                  "*"
                ],
                "group_by": [
                  {
                    "facet": "@http.status_code",
                    "sort": {
                      "aggregation": "count",
                      "order": "desc"
                    },
                    "limit": 10
                  }
                ]
              }
            ],
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ]
      },
      "layout": {
        "x": 6,
        "y": 7,
        "width": 3,
        "height": 3
      }
    }
  ],
  "template_variables": [
    {
      "name": "env",
      "prefix": "env",
      "available_values": [],
      "default": "prd"
    },
    {
      "name": "carrier",
      "prefix": "@carrier",
      "available_values": [],
      "default": "*"
    }
  ],
  "layout_type": "ordered",
  "is_read_only": false,
  "notify_list": [],
  "reflow_type": "fixed",
  "id": "x3y-buf-8ur"
}
DASHBOARD
}
