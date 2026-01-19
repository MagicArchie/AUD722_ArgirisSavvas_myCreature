Kickdrum Creature — Concept & Control Notes
1. Concept (Short Description)

Kickdrum is a sound creature living inside the EvoLab environment.
Its behavior is driven by the global EvoLab states (dawn, day, dusk, night, danger) and by an internal system of personal encounters.

The creature has two sonic layers:

Body — a rhythmic kick-based sound representing physical movement.

Soul — a breathy noise texture representing emotional and environmental response.

While EvoLab controls the global time and danger states, the creature autonomously generates internal events (encounters with people, places, food, and stories), which temporarily modify its sound and emotional state.

2. EvoLab States → Behavioral Meaning
EvoLab State	Interpretation
dawn	Waking up, sensitivity, curiosity
day	Social activity, movement, energy
dusk	Reflection, slowing down
night	Solitude, inner thoughts
danger	Overstimulation, fear, urgency

Each EvoLab state biases which internal encounters are more likely to occur.

3. Internal Encounter Types

The creature experiences four types of encounters:

people → stranger, friend, crowd

walking → cityStreet, forest, lake, sea

eating → comfort, bitter

movie → scary, funny, neutral, awe, sad

Encounters temporarily alter rhythm density, tone brightness, envelope shapes, and noise texture.

4. Randomizer Logic (Percentages per EvoLab State)
Dawn

walking — 40%

people — 25%

eating — 20%

movie — 15%

Bias: forest/lake walks, strangers, comfort food, neutral/awe movies

Day

people — 35%

walking — 30%

movie — 20%

eating — 15%

Bias: friends & crowds, city streets, funny/awe movies

Dusk

walking — 35%

movie — 30%

people — 20%

eating — 15%

Bias: sea/lake walks, sad/neutral movies, strangers

Night

movie — 40%

walking — 25%

eating — 20%

people — 15%

Bias: scary/sad movies, slow sea walks, comfort food

Danger

people — 45%

walking — 35%

movie — 15%

eating — 5%

Bias: crowds & strangers, city streets, scary movies

5. Auto-Event System

The creature includes an auto-event engine:

When ON, encounters are triggered automatically.

Frequency depends on EvoLab state:

Faster during day and danger

Slower during night

Auto-events do not replace day/night behavior — they overlay it.

Auto-events can be manually enabled or disabled.

6. Available Commands (User Control)
EvoLab-triggered states
Kickdrum.default.dawn;
Kickdrum.default.day;
Kickdrum.default.dusk;
Kickdrum.default.night;
Kickdrum.default.danger;

Auto-event control
Kickdrum.default.autoOn;
Kickdrum.default.autoOff;

Random encounters (manual)
Kickdrum.default.people;
Kickdrum.default.walking;
Kickdrum.default.eating;
Kickdrum.default.movie;

Detailed encounter control
Kickdrum.default.encounter(\people, \crowd);
Kickdrum.default.encounter(\walking, \sea);
Kickdrum.default.encounter(\movie, \scary);
Kickdrum.default.encounter(\eating, \comfort);

Stop all activity
Kickdrum.default.stop;

7. Summary (One Sentence)

Kickdrum is a reactive sound creature whose rhythmic body and breathy soul evolve through autonomous encounters shaped by the global states of the EvoLab environment.
