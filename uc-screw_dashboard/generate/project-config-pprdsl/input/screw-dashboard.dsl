// Quality
Attribute "quality.id": {description: "Quality view id", defaultValue: "", type: "String", unit: ""}
Attribute "quality.required_torque": {description: "Required torque", defaultValue: 0.0, type: "Number", unit: "Nm"}
Attribute "quality.screw_tension": {description: "Set Mechanical torque", defaultValue: 0.0, type: "Number", unit: "Nm"}

// Mechanical
Attribute "mechanical.id": {description: "Mechanical view id", defaultValue: "", type: "String", unit: ""}
Attribute "mechanical.torque": {description: "torque", defaultValue: 0.0, type: "Number", unit: "Nm"}
Attribute "mechanical.bit_type": {description: "Bit Type", defaultValue: "", type: "String", unit: ""}
Attribute "mechanical.position_accuracy": {description: "Process accuracy", defaultValue: 0.0, type: "Number", unit: "mm"}

// Electrical
Attribute "electrical.id": {description: "Electrical view id", defaultValue: "", type: "String", unit: ""}
Attribute "electrical.power_supply": {description: "Electrical power supply", defaultValue: 0, type: "Number", unit: "Kw"}
Attribute "electrical.current_supply": {description: "Electrical power supply", defaultValue: 0, type: "Number", unit: "Kw"}
Attribute "electrical.power_consumption": {description: "Electrical power supply", defaultValue: 0, type: "Number", unit: "Kw"}
Attribute "electrical.fieldbus_type": {description: "Fieldbus type", defaultValue: "", type: "String", unit: ""}

// Automation
Attribute "automation.id": {description: "Automation view id", defaultValue: "", type: "String", unit: ""}
Attribute "automation.screwdriver_curve": {description: "Screwdriver Curve Function Name", defaultValue: "", type: "String", unit: ""}
Attribute "automation.motion_acceleration": {description: "Motion Acceleration", defaultValue: 0.0, type: "Number", unit: "m/s"}



// Resource

// Main CPPS Resources

// Robot
Resource "Robot": { name: "Robot",
                    children: [ "RobotController" ],
                    requires: [ "HighPowerSupply" ],
                    mechanical.id:  {  relations: [
                                                    {   type: "source", semantic: "MechExport?name;id", reference: "@name" }
                                                  ]
                    },
                    mechanical.position_accuracy:  {  relations:  [ 
                                                                    { type: "source", semantic: "MechExport", reference: "@position_accuracy" },
                                                                    { type: "dependency",
                                                                      semantic: "SUMProject",
                                                                      reference: "${RobotController}.automation@motion_acceleration"
                                                                    },
                                                                    { type: "propagate",
                                                                      semantic: "SUMProject",
                                                                      reference: "${FastenScrewMeasure}.mechanical@position_accuracy"
                                                                    }
                                                                  ]
                    }
                  }

// Electric Screwdriver
Resource "ElectricScrewdriver": { name: "ElectricScrewdriver",
                                  children: ["Bit", "Drive", "Robot"],
                                  mechanical.id: {  relations:  [ 
                                                                  {	type: "source", semantic: "MechExport?name;id", reference: "@name" }
                                                                ]
                                },
                                  mechanical.torque: {  relations: [
                                                                    {	type: "source", semantic: "MechExport", reference: "@torque" },
                                                                    { type: "dependency",
                                                                      semantic: "SUMProject",
                                                                      reference: "${ScrewdriverController}.automation@screw_curve"
                                                                    },
                                                     				        { type: "propagate",
                                                                      semantic: "SUMProject",
                                                                      reference: "${FastenScrewMeasure}.mechanical@torque"
                                                                    }
                                                     			        ]
                                                      },
                                  electrical.id: {  relations:  [ 
                                                                  {	type: "source", semantic: "ElectricExport?name;id", reference: "@name" }
                                                                ]
                                },
                                  electrical.power_consumption: { relations:  [
                                                                                {	type: "source", semantic: "ElectricExport", reference: "@power_consumption"},
                                                                                { type: "dependency",
                                                                                  semantic: "SUMProject",
                                                                                  reference: "${Transformer}.electrical@current_supply"
                                                                                }
                                                                              ]
                                }
}


// CPPS Sub Resources                                

// Bit
Resource "Bit": { name: "Bit",
                  mechanical.id:  {relations: [  
                                                {	type: "source", semantic: "MechExport?name;id", reference: "@name" }
                                              ]
                },
                  mechanical.bit_type:  { relations: [  
                                                        {	type: "source", semantic: "MechExport", reference: "@type" }
                                                      ]
                }
}

// Drive
Resource "Drive": { name: "Drive", children: ["Transformer"],
                    mechanical.id: {  relations: [  
                                                    {	type: "source", semantic: "MechExport?name;id", reference: "@name" }
                                                  ]
                  }
}


// Automation Resources

// Robot Controller
Resource "RobotController": { name: "Robot Controller",
                              requires: ["LowPowerSupply", "FieldbusNetwork"],
                              automation.id:  { relations:  [ 
                                                              { type: "source", semantic: "AutomationExport?name;id", reference: "@name" }
                                                            ]
                            },
                              automation.motion_acceleration: { relations:  [ 
                                                                              { type: "source", semantic: "AutomationExport", reference: "@motion_acceleration" }
                                                                            ]
                                                              }
                            }

// ScrewdriverController
Resource "ScrewdriverController": { name: "Screwdriver Controller",
                                    requires: ["RobotController", "LowPowerSupply", "FieldbusNetwork"],
                                    electrical.id: {  relations:  [ 
                                                                  { type: "source", semantic: "ElectricExport?name;id", reference: "@name" }
                                                                ]
                                  },
                                    electrical.power_consumption: { relations:  [
                                                                                  { type: "source", semantic: "ElectricExport", reference: "@power_consumption"},
                                                                                  { type: "dependency",
                                                                                    semantic: "SUMProject",
                                                                                    reference: "${LowPowerSupply}.electrical@power_supply"
                                                                                  }
                                                                                ]
                                  },
                                     automation.id: {relations:  [
                                                                  { type: "source", semantic: "AutomationExport?name;id", reference: "@name" }
                                                                ]
                                  },
                                    automation.screwdriver_curve: { relations:  [
                                                                                  { type: "source", semantic: "AutomationExport", reference: "@screwdriver_curve" }
                                                                                ]
                                                                  }
                                  }

// Transformer
Resource "Transformer": { name: "Transformer", 
                          children: ["ScrewdriverController"], 
                          requires: ["HighPowerSupply"],
                          electrical.current_supply: { relations: [
                                                                    { type: "source", semantic: "ElectricExport", reference: "@current_supply"},
                                                                    { type: "dependency",
                                                                      semantic: "SUMProject",
                                                                      reference: "${HighPowerSupply}.electrical@power_supply"
                                                                    }
                                                                  ]
                                                      }
                        }


// Automation Resources

// HighPowerSupply
Resource "HighPowerSupply": { name: "HighPowerSupply",
                              electrical.id: {relations: [{	type: "source", semantic: "ElectricExport?name;id", reference: "@name" }]},
                              electrical.power_supply: { relations: [
                                                                      {	type: "source", semantic: "ElectricExport", reference: "@power_supply"}
                                                                    ]
                                                       }
                            }

// LowPowerSupply
Resource "LowPowerSupply": { name: "LowPowerSupply",
                             electrical.id: { relations: [
                                                          {	type: "source", semantic: "ElectricExport?name;id", reference: "@name" }
                                                        ]
                                            },
                             electrical.power_supply: { relations: [
                                                                      {	type: "source", semantic: "ElectricExport", reference: "@power_supply" }
                                                                   ]
                                                      }
                            }

// FieldbusNetwork                            
Resource "FieldbusNetwork": { name: "FieldbusNetwork",
                              electrical.id: {  relations: [
                                                            {	type: "source", semantic: "ElectricExport?name;id", reference: "@name" }
                                                          ]
                                              },
                              electrical.fieldbus_type: { relations: [
                                                                        {	type: "source", semantic: "ElectricExport", reference: "@fieldbus_type" }
                                                                     ]
                                                        }
                            }




// Products
Product "car_body_with_dashboard": {name: "Car Body with positioned on Dashboard"}
Product "car_body_with_screwed_on_dashboard": {name: "Car Body with screwd on Dashboard"}


// Processes
Process "FastenScrewMeasure": {
  name: "Fasten Screw & Measure",
  inputs: [
   {productId: "car_body_with_dashboard"}
  ],
  outputs: [
   {CBwSoDOut: {productId: "car_body_with_screwed_on_dashboard", costWeight: 0.0}}
  ],
  resources: [
   {resourceId: "ElectricScrewdriver", minCost: 0.0, maxCost: 0.0}
  ],
  quality.id: {relations: [{  type: "source", semantic: "QualityExport?name;id", reference: "@name" }]},
  quality.cycle_time: { value: 10 },
  quality.required_torque: { relations: [ { type: "source",
                                            semantic: "QualityExport",
                                            reference: "@required-torque"
                                          }
                                        ]
                            },
  quality.screw_tension: { relations: [ {    type: "source",
                                             semantic: "SUMProject",
                                             reference: "this.mechanical@torque"
                                          }
                                        ]},
  mechanical.id: {relations:  [
                                { type: "source", semantic: "MechExport?name;id", reference: "@name" }
                              ]
  },
  mechanical.torque: { relations: [ 
                                    { 
                                      type: "source",
                                      semantic: "SUMProject",
                                      reference: "${ElectricScrewdriver}.mechanical@torque"
                                    }
                                  ]
  },
  mechanical.pos_accuracy: { relations: [ 
                                          { 
                                            type: "source",
                                            semantic: "SUMProject",
                                            reference: "${Robot}.mechanical@pos_accuracy"
                                          }
                                        ]
                      }
  }
