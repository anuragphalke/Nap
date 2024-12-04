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
          "fontFamily": "Roboto",
          "height": 378,
          "id": "Zmzmu",
          "stackOnlyBar": true,
          "toolbar": {
              "show": false
          },
          "type": "bar",
          "width": 389,
          "zoom": {
              "allowMouseWheelZoom": true
          }
      },
      "plotOptions": {
          "line": {
              "isSlopeChart": false,
              "colors": {
                  "threshold": 0
              }
          },
          "bar": {
              "distributed": true,
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
          "#EBFF57",
          "#4caf50",
          "#f9ce1d",
          "#FF9800"
      ],
      "dataLabels": {
          "enabled": false,
          "style": {
              "fontWeight": 700
          },
          "background": {
              "dropShadow": {}
          }
      },
      "fill": {
          "opacity": 1
      },
      "grid": {
          "padding": {
              "right": 25,
              "left": 15
          }
      },
      "legend": {
          "fontSize": 14,
          "offsetY": 0,
          "markers": {
              "size": 7,
              "shape": "square"
          },
          "itemMargin": {
              "vertical": 0
          }
      },
      "markers": {},
      "series": [
          {
              "name": "Column",
              "data": [
                  {
                      "x": "Item 1",
                      "y": 10
                  },
                  {
                      "x": "Item 2",
                      "y": 20
                  }
              ],
              "group": "apexcharts-axis-0"
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
          "lineCap": "round",
          "width": 0,
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
          "shared": false,
          "hideEmptySeries": false,
          "intersect": true
      },
      "xaxis": {
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
          "tickPlacement": "between",
          "title": {
              "style": {
                  "fontWeight": 700
              }
          },
          "tooltip": {
              "enabled": false
          }
      },
      "yaxis": {
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
      },
      "theme": {
          "palette": "palette2"
      }
  }

    const chart = new ApexCharts(this.element, options)
    chart.render()

  }
}