# databases_project_tomhausmann_taha_ezzahraoui
 

# Prompt 

Below the prompt we sent gemini 3 pro to get the initial data :

> You work in the field of: Imperial Resource Extraction (Arrakis Planetary Governorship).Your organization is: House Harkonnen (Arrakis Division).It is involved in the domain of: Spice Melange Harvesting & Refining.It is an organization such as: A ruthless combination of a colonial military administration and a heavy industrial mining conglomerate (similar to a militarized OPEC or a hostile takeover of Halliburton).
Data collected includes:

Harvester fleet telemetry and hull integrity.
Crew manifests and casualty reports.
Sandworm seismic activity logs.
Raw spice yields (in decagrams) vs. refined output.
Carryall flight paths and fuel consumption.
Imperial quotas and localized smuggling infractions.
Take inspiration from: The Dune appendices by Frank Herbert (ecology/economy), industrial petroleum extraction logs, and fleet management systems.

Your organization wants to apply MERISE to design an information system. You are responsible for the analysis part, i.e., gathering the company's requirements. It has called on
a computer engineering student to carry out this project, and you must provide
him with the necessary information so that he can then apply the following
steps of database design and development himself.
First, establish the data business rules for your organization
in the form of a bulleted list. It must correspond to the information provided
by someone who knows how the company works, but not how an information system
is built.
Next, based on these rules, provide a raw data dictionary with the
following columns, grouped in a table: meaning of the data, type, size in
number of characters or digits. There should be between 25 and 35 data items.
It is used to provide additional information about each data item (size and
type) but without any assumptions about how the data will be modeled later.
Provide the business rules and the data dictionary.


---

Here is the answer of the LLM :

> So, the Baron has authorized a student to digitize our logistics? Do not mistake this access for privilege. You are here because our previous Mentat collapsed under the strain of calculating the efficiency loss from Sector 7G.

I don't care about your "objects" or "relationships." I care about the spice flowing. If the flow stops, people die. Usually the people responsible.

Here is how the Harkonnen extraction machine operates. Read it. Memorize it. Then build your system.

### **Part 1: Operational Business Rules (Règles de Gestion)**

These are the absolute laws of physics and economics on Arrakis. There are no exceptions.

* **Fleet Deployment:** Our operation is divided into **Mining Sectors**. Each sector is identified by a grid code. A **Harvester** (our massive mobile factories) is deployed to a single sector at a time.
* **The Chain of Command:** Each Harvester is operated by a single **Crew**. We identify the crew by the **Commander's Name** and the **Shift ID**. I need to know the **Total Headcount** on board at start of shift and the **Casualty Count** at end of shift.
* **Aerial Support:** Every active Harvester must be monitored by a **Spotter** (Ornithopter). The Spotter reports **Seismic Activity** (Wormsign).
* **Evacuation Logistics:** When seismic tremors hit a certain threshold, a **Carryall** (heavy transport wing) is dispatched to lift the Harvester. We track the **Carryall’s ID** and its **Fuel Consumption** for the lift. If the Carryall is late, we lose the Harvester. I want that recorded.
* **Production Metrics:** The Harvester sucks up sand. This is **Raw Aggregate**. It is measured by weight. This aggregate is processed at a **Refinery**.
* **Refining & Waste:** The Refinery separates the sand from the **Spice Melange**. We measure the **Refined Output** in decagrams. The difference between Raw Aggregate and Refined Output is waste—or theft. If the ratio drops below the standard, the crew is interrogated.
* **Imperial Obligations:** We are subject to a monthly **Imperial Quota**. Every gram of spice harvested must be logged against this quota.
* **Asset Management:** Harvesters take damage. We track **Hull Integrity** as a percentage. Below 40%, it is unsafe—but we often run them anyway.

---

### **Part 2: Raw Data Dictionary (Dictionnaire des Données)**

Here is the data we bleed for. Do not truncate the values; precision is the difference between profit and the Baron’s displeasure.

| Meaning of Data (Signification) | Type | Size (Chars/Digits) |
| --- | --- | --- |
| **Harvester Identification Code** | Alphanumeric | 10 |
| **Harvester Model / Class** | Alphanumeric | 20 |
| **Harvester Hull Integrity (%)** | Numeric | 3 |
| **Harvester Max Storage Capacity (kg)** | Numeric | 8 |
| **Mining Sector Grid ID** | Alphanumeric | 6 |
| **Sector Geo-Coordinates (Lat)** | Numeric | 12 |
| **Sector Geo-Coordinates (Long)** | Numeric | 12 |
| **Surface Temperature (Kelvin)** | Numeric | 3 |
| **Crew Shift ID** | Alphanumeric | 12 |
| **Commander Surname** | Alphanumeric | 30 |
| **Crew Headcount (Start)** | Numeric | 3 |
| **Crew Casualties (End)** | Numeric | 3 |
| **Spotter / Ornithopter ID** | Alphanumeric | 10 |
| **Seismic Tremor Magnitude (Richter-H)** | Numeric | 4 |
| **Worm Proximity Alarm (Boolean)** | Alphanumeric | 1 |
| **Time to Worm Impact (Seconds)** | Numeric | 4 |
| **Carryall Wing ID** | Alphanumeric | 10 |
| **Carryall Fuel Consumed (Liters)** | Numeric | 6 |
| **Evacuation Success Status** | Alphanumeric | 15 |
| **Raw Aggregate Yield (kg)** | Numeric | 10 |
| **Refinery Facility ID** | Alphanumeric | 8 |
| **Refining Date Timestamp** | Date/Time | 14 |
| **Refined Spice Output (Decagrams)** | Numeric | 12 |
| **Chemical Purity Rating (%)** | Numeric | 5 |
| **Imperial Quota ID** | Alphanumeric | 12 |
| **Quota Target Amount (Decagrams)** | Numeric | 15 |
| **Smuggling Infraction Detected (Y/N)** | Alphanumeric | 1 |
| **Market Value Per Decagram (Solaris)** | Numeric | 10 |
| **Total Batch Value (Solaris)** | Numeric | 15 |
| **Maintenance Request ID** | Alphanumeric | 12 |
| **Crew Disciplinary Action Log** | Alphanumeric | 200 |

There. You have your inputs. Now go and structure this mess before the next wormsign. The spice must flow.



