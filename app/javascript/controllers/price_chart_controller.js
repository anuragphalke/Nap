import { Controller } from "@hotwired/stimulus"
import ApexCharts from 'apexcharts'
// const costs = JSON.parse(this.data.get('costs'));

// Connects to data-controller="price-chart"
export default class extends Controller {
  static values = { costs: Array }
  connect() {
    console.log('connected');
    console.log(this.costsValue);


    const data = this.costsValue;

    const options = {
      "annotations": {},
      "chart": {
          "animations": {
              "enabled": false
          },
          "background": "#343436",
          "foreColor": "#FFFFFF",
          "fontFamily": "Space Grotesk",
          "height": 200,
          "id": "Cvklo",
          "stackOnlyBar": true,
          "toolbar": {
              "show": false
          },
          "width": "100%",
          "zoom": {
              "allowMouseWheelZoom": true
          },
          "fontUrl": null
      },
      "plotOptions": {
          "line": {
              "isSlopeChart": false,
              "colors": {
                  "threshold": 0
              }
          },
          "bar": {
              "borderRadius": 10,
              "borderRadiusApplication": "end",
              "borderRadiusWhenStacked": "last",
              "hideZeroBarsWhenGrouped": false,
              "isDumbbell": false,
              "isFunnel": false,
              "isFunnel3d": true,
              "dataLabels": {
                  "total": {
                      "enabled": false,
                      "offsetX": 0,
                      "offsetY": 0,
                      "style": {
                          "color": "#373d3f",
                          "fontSize": "12px",
                          "fontWeight": 600
                      }
                  }
              }
          },
          "bubble": {
              "zScaling": true
          },
          "treemap": {
              "borderRadius": 4,
              "dataLabels": {
                  "format": "scale"
              }
          },
          "radialBar": {
              "hollow": {
                  "background": "#fff"
              },
              "dataLabels": {
                  "name": {},
                  "value": {},
                  "total": {}
              },
              "barLabels": {
                  "enabled": false,
                  "offsetX": 0,
                  "offsetY": 0,
                  "useSeriesColors": true,
                  "fontWeight": 600,
                  "fontSize": "16px"
              }
          },
          "pie": {
              "donut": {
                  "labels": {
                      "name": {},
                      "value": {},
                      "total": {}
                  }
              }
          }
      },
      "colors": [
          "#0097B8",
          "#c7f464",
          "#81D4FA",
          "#fd6a6a",
          "#546E7A"
      ],
      "dataLabels": {
          "enabled": false,
          "style": {
              "fontWeight": 700
          },
          "background": {
              "foreColor": "#FFFFFF",
              "dropShadow": {}
          }
      },
      "grid": {
          "show": false,
          "padding": {
              "right": 31,
              "left": 31
          }
      },
      "legend": {
          "fontSize": 14,
          "offsetY": 0,
          "markers": {
              "size": 7
          },
          "itemMargin": {
              "vertical": 0
          }
      },
      "markers": {
          "hover": {
              "size": 0,
              "sizeOffset": 6
          }
      },
      "series": [
          {
              "name": "Price",
              "data": data,
              "group": "apexcharts-axis-0",
              "zIndex": 0
          }
      ],
      "states": {
          "hover": {
              "filter": {}
          },
          "active": {
              "filter": {}
          }
      },
      "stroke": {
          "curve": "straight",
          "width": 4,
          "fill": {
              "type": "solid",
              "opacity": 0.85,
              "gradient": {
                  "shade": "dark",
                  "type": "horizontal",
                  "shadeIntensity": 0.5,
                  "inverseColors": true,
                  "opacityFrom": 1,
                  "opacityTo": 1,
                  "stops": [
                      0,
                      50,
                      100
                  ],
                  "colorStops": []
              }
          }
      },
      "tooltip": {
          "hideEmptySeries": false
      },
      "xaxis": {
          "type": "numeric",
          "labels": {
              "trim": true,
              "style": {}
          },
          "group": {
              "groups": [],
              "style": {
                  "colors": [],
                  "fontSize": "12px",
                  "fontWeight": 400,
                  "cssClass": ""
              }
          },
          "tickAmount": 2,
          "title": {
              "style": {
                  "fontWeight": 700
              }
          }
      },
      "yaxis": {
          "show": false,
          "tickAmount": 5,
          "labels": {
              "showDuplicates": false,
              "style": {}
          },
          "title": {
              "style": {
                  "fontWeight": 700
              }
          }
      }
  }

    const chart = new ApexCharts(this.element, options)
    chart.render()

  }
}
