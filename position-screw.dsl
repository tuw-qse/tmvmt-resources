// Quality
Attribute "quality.id": {description: "Quality view id", defaultValue: "", type: "String", unit: ""}
Attribute "quality.cycle_time": {description: "Measured cycle_time", defaultValue: 0.0, type: "Number", unit: "mills"}
Attribute "quality.required_torque": {description: "Required torque", defaultValue: 0.0, type: "Number", unit: "Nm"}
Attribute "quality.tension": {description: "Mechanical torque", defaultValue: 0.0, type: "Number", unit: "Nm"}

// Mechanical
Attribute "mechanical.id": {description: "Mechanical view id", defaultValue: "", type: "String", unit: ""}
Attribute "mechanical.torque": {description: "torque", defaultValue: 0.0, type: "Number", unit: "Nm"}
Attribute "mechanical.bit_type": {description: "Bit Type", defaultValue: "", type: "String", unit: ""}
Attribute "mechanical.bit_size": {description: "Bit Size", defaultValue: 0, type: "integer", unit: ""}
Attribute "mechanical.material": {description: "Material", defaultValue: "", type: "String", unit: ""}
Attribute "mechanical.position_accuracy": {description: "Process accuracy", defaultValue: 0.0, type: "Number", unit: "mm"}

// Electrical
Attribute "electrical.id": {description: "Electrical view id", defaultValue: "", type: "String", unit: ""}
Attribute "electrical.power_supply": {description: "Electrical power supply", defaultValue: 0, type: "Number", unit: "Kw"}
Attribute "electrical.power_consumption": {description: "Electrical power supply", defaultValue: 0, type: "Number", unit: "Kw"}
Attribute "electrical.fieldbus_type": {description: "Fieldbus type", defaultValue: "", type: "String", unit: ""}

// Automation
Attribute "automation.id": {description: "Automation view id", defaultValue: "", type: "String", unit: ""}
Attribute "automation.screwdriver_curve": {description: "Screwdriver Curve Function Name", defaultValue: "", type: "String", unit: ""}
Attribute "automation.motion_acceleration": {description: "Motion Acceleration", defaultValue: 0.0, type: "Number", unit: "m/s"}

// Resource
Resource "WorkCell1": { name: "Work Cell 1",
                        children: ["TransportResource", "PositioningCell"],
                        mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]}
                      }

Resource "TransportResource": { name: "Transport Resource",
                                quality.id: {relations: [{	type: "source", mimeType: "xml", semantic: "QualityExport?name;id", reference: "@name" }]},
                                mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]},
                              }

Resource "PositioningCell": {   name: "Positioning Cell", children: ["Drive1", "Drive2"],
                                quality.id: {relations: [{	type: "source", mimeType: "xml", semantic: "QualityExport?name;id", reference: "@name" }]},
                                mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]},
                            }

Resource "Drive1": {    name: "Drive1", requires: ["Drive2"],
                        mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]},
                    }

Resource "Drive2": {    name: "Drive2",
                        mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]},
                    }

Resource "WorkCell2": { name: "WorkCell 2", children: ["ScrewDriver", "Robot"],
                        mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]}
                        }

Resource "ElectricScrewdriver": {name: "ElectricScrewdriver",
                                children: ["Bit", "Drive3", "Robot"],
                                quality.id: {relations: [{	type: "source", mimeType: "xml", semantic: "QualityExport?name;id", reference: "@name" }]},
                                mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]},
                                mechanical.torque: { relations: [{	type: "source",
                                                   					mimeType: "xml",
                                                   					semantic: "MechExport",
                                                   					reference: "@torque"
                                                   				},
                                                   				{   type: "propagate",
                                                                    mimeType: "aml",
                                                                    semantic: "SUMProject",
                                                                    reference: "${FastenScrewMeasure}.mechanical@torque"
                                                                }
                                                   			 ]
                                                   },
                                electrical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "ElectricExport?name;id", reference: "@name" }]},
                                electrical.power_consumption: { relations: [{	type: "source",
                                                                                mimeType: "xml",
                                                                                semantic: "ElectricExport",
                                                                                reference: "@power-consumption"
                                                                            }
                                                                          ]
                                                              }
                                }

Resource "Bit": { name: "Bit",
  mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]},
  mechanical.material: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport", reference: "@material" }]},
  mechanical.bit_type: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport", reference: "@type" }]}
}

Resource "Drive3": {name: "Drive 3", children: ["Transformer"],
  mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]}
}

Resource "Transformer": {name: "Transformer", children: ["ScrewdriverController"], requires: ["HighPowerSupply"] }

Resource "HighPowerSupply": { name: "HighPowerSupply",
                              electrical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "ElectricExport?name;id", reference: "@name" }]},
                              electrical.power_supply: { relations: [{	type: "source",
                                                                        mimeType: "xml",
                                                                        semantic: "ElectricExport?name",
                                                                        reference: "@power_supply"
                                                                      }
                                                                    ]
                                                       }
                            }

Resource "LowPowerSupply": { name: "LowPowerSupply",
                             electrical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "ElectricExport?name;id", reference: "@name" }]},
                             electrical.power_supply: { relations: [{	type: "source",
                                                                        mimeType: "xml",
                                                                        semantic: "ElectricExport?name",
                                                                        reference: "@power_supply"
                                                                    }
                                                                   ]
                                                      }
                            }
Resource "FieldbusNetwork": { name: "FieldbusNetwork",
                              electrical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "ElectricExport?name;id", reference: "@name" }]},
                              electrical.fieldbus_type: { relations: [{	type: "source",
                                                                        mimeType: "csv",
                                                                        semantic: "PPRExport?name;id",
                                                                        reference: "F_PXNAME"
                                                                      }
                                                                     ]
                                                        }
                            }

Resource "ScrewdriverController": { name: "Screwdriver Controller",
                                    requires: ["RobotController", "LowPowerSupply", "FieldbusNetwork"],
                                    automation.id: {relations: [{	type: "source", mimeType: "xml", semantic: "AutomationExport?name;id", reference: "@name" }]},
                                    automation.screwdriver_curve: { value: "DefaultScrewingCurve" }
                                  }

Resource "Robot": { name: "Robot",
                    children: [ "RobotController" ],
                    requires: ["HighPowerSupply"],
                    quality.id: {relations: [{	type: "source", mimeType: "xml", semantic: "QualityExport?name;id", reference: "@name" }]},
                    mechanical.id: {relations: [{   type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]},
                    mechanical.torque: { relations: [{	type: "source",
                                                        mimeType: "xml",
                                                        semantic: "MechExport",
                                                        reference: "@torque"
                                                      }
                                                     ]
                    },
                    electrical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "ElectricExport?name;id", reference: "@name" }]},
                    electrical.power_supply: { relations: [{	type: "propagate",
                                                                mimeType: "aml",
                                                                semantic: "SUMProject",
                                                                reference: "${HighPowerSupply}.electrical@power_supply"
                                                            }
                                                           ]
                    }
                  }

Resource "RobotController": { name: "Robot Controller",
                              requires: ["LowPowerSupply", "FieldbusNetwork"],
                              automation.id: {relations: [{	type: "source", mimeType: "xml", semantic: "AutomationExport?name;id", reference: "@name" }]},
                              automation.motion_acceleration: { relations: [{
                                                                                type: "source",
                                                                                mimeType: "xml",
                                                                                semantic: "AutomationExport",
                                                                                reference: "@motion-acceleration"
                                                                            }
                                                                           ]
                                                              }
                                }




Product "screw": {name: "Screw"}
Product "dashboard": {name: "Dashboard"}
Product "car_body": {name: "Car Body"}
Product "car_body_with_dashboard": {name: "Car Body with Dashboard"}
Product "car_body_with_screwed_on_dashboard": {name: "Car Body with screwd on Dashboard"}


Process "PositionScrewDashboard": {
  name: "Position Screw Dashboard",
  inputs: [
    {productId: "screw", minCost: 0.0, maxCost: 0.0},
    {productId: "dashboard", minCost: 0.0, maxCost: 0.0},
    {productId: "car_body", minCost: 0.0, maxCost: 0.0}
  ],
  outputs: [
    {CBwDOut: {productId: "car_body_with_dashboard", costWeight: 0.0}}
  ],
  resources: [
    {resourceId: "WorkCell1", minCost: 0.0, maxCost: 0.0}
  ],
  quality.id: {relations: [{	type: "source", mimeType: "xml", semantic: "QualityExport?name;id", reference: "@name" }]},
  quality.cycle_time: { value: 10 },
  mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]},
  mechanical.position_accuracy: { value: 0 }
}


Process "FastenScrewMeasure": {
  name: "Fasten Screw & Measure",
  inputs: [
	 {productId: "car_body_with_dashboard", comesFrom: "CBwDOut"}
  ],
  outputs: [
	 {CBwSoDOut: {productId: "car_body_with_screwed_on_dashboard", costWeight: 1.0}}
  ],
  resources: [
	 {resourceId: "WorkCell2", minCost: 0.0, maxCost: 0.0}
  ],
  quality.id: {relations: [{	type: "source", mimeType: "xml", semantic: "QualityExport?name;id", reference: "@name" }]},
  quality.cycle_time: { value: 10 },
  quality.required_torque: { relations: [ { type: "source",
                                            mimeType: "xml",
                                            semantic: "QualityExport",
                                            reference: "@required-torque"
                                          }
                                        ]
                            },
  quality.tension: { relations: [ {   type: "map",
                                             mimeType: "aml",
                                             semantic: "SUMProject",
                                             reference: "this.mechanical@torque"
                                          }
                                        ]},
  mechanical.id: {relations: [{	type: "source", mimeType: "xml", semantic: "MechExport?name;id", reference: "@name" }]},
  mechanical.torque: { value: 0 }
}
