#define SHEET_MATERIAL_AMOUNT 2000
#define SHEET_UNIT "<small>cm<sup>3</sup></small>"

#define REAGENT_WORTH_MULTIPLIER  1 //0.01
#define GAS_WORTH_MULTIPLIER 1 //0.001
#define MATERIAL_WORTH_MULTIPLIER 1 //0.005

#define REAGENT_UNITS_PER_MATERIAL_SHEET 20
#define REAGENT_UNITS_PER_GAS_MOLE 10
#define REAGENT_UNITS_PER_MATERIAL_UNIT (REAGENT_UNITS_PER_MATERIAL_SHEET / SHEET_MATERIAL_AMOUNT)
#define MATERIAL_UNITS_TO_REAGENTS_UNITS(AMT) (AMT * REAGENT_UNITS_PER_MATERIAL_UNIT)
#define MOLES_PER_MATERIAL_UNIT(AMT) round(MATERIAL_UNITS_TO_REAGENTS_UNITS(AMT) / REAGENT_UNITS_PER_GAS_MOLE)

#define MATTER_AMOUNT_PRIMARY       SHEET_MATERIAL_AMOUNT
#define MATTER_AMOUNT_SECONDARY     (MATTER_AMOUNT_PRIMARY * 0.75)
#define MATTER_AMOUNT_REINFORCEMENT (MATTER_AMOUNT_PRIMARY * 0.5)
#define MATTER_AMOUNT_TRACE         (MATTER_AMOUNT_PRIMARY * 0.1)

#define HOLLOW_OBJECT_MATTER_MULTIPLIER 0.05
#define BASE_OBJECT_MATTER_MULTPLIER    0.25

#define LOW_SMELTING_HEAT_POINT     1150 CELSIUS // Reachable with coal in a kiln on the medieval maps.
#define GENERIC_SMELTING_HEAT_POINT 1350 CELSIUS // Reachable with coal and a bellows in a kiln on medieval maps.
#define HIGH_SMELTING_HEAT_POINT    4000 CELSIUS // must be at least 4074K (3800 C) to melt graphite

#define TECH_MATERIAL      "materials"
#define TECH_ENGINEERING   "engineering"
#define TECH_EXOTIC_MATTER "exoticmatter"
#define TECH_POWER         "powerstorage"
#define TECH_WORMHOLES     "wormholes"
#define TECH_BIO           "biotech"
#define TECH_COMBAT        "combat"
#define TECH_MAGNET        "magnets"
#define TECH_DATA          "programming"
#define TECH_ESOTERIC      "esoteric"
