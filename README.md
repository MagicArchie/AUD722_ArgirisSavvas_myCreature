# Kickdrum

**Kickdrum** (*EvoLab Sound Creature – AUD722*) is a generative sound entity developed in **SuperCollider** for the **EvoLab multichannel sound installation framework**.  
The system combines rhythmic sample-based playback with a continuous, noise-driven texture to form an autonomous sonic agent capable of responding to both external environmental states and internally generated events.

The project investigates how sound can function as a medium for expressing **movement**, **emotional state**, and **perceptual experience** within a shared generative environment.

---

## Overview

Kickdrum operates within EvoLab as an **independent sound creature**.  
Its behavior emerges from the interaction of two distinct but interdependent control layers:

- **Global environmental states** transmitted by the EvoLab system  
- **Internal encounter events** generated autonomously by the creature  

While EvoLab establishes the global temporal and structural framework of the installation, Kickdrum maintains its own internal decision-making processes, allowing for continuous sonic evolution over extended durations.

---

## Objectives

The primary objectives of the Kickdrum project are to:

- Investigate **autonomous sound behavior** in a multichannel installation context  
- Translate **environmental conditions** and **affective states** into sonic parameters  
- Demonstrate **event-driven sound synthesis and control** using SuperCollider  
- Explore the balance between **external system control** and **local generative autonomy**  

The project emphasizes a hybrid model in which global constraints coexist with internally driven sonic agency.

---

## Conceptual Framework

Kickdrum is conceptually framed as a **sonic creature** navigating an environment and reacting emotionally to perceived encounters.

Its sound identity is structured around two primary layers:

### Body Layer

- Rhythmic playback based on a kick-drum sample  
- Represents physical presence, locomotion, and corporeal activity  
- Rhythm density, amplitude, and temporal behavior are influenced by EvoLab states  

### Soul Layer

- Continuous breath-like noise texture processed through filtering and modulation  
- Represents internal states such as emotion, memory, and perception  
- Temporarily reshaped through encounter-driven parameter changes  

The interaction between these layers produces a dynamically evolving sonic behavior that reflects both movement and affect.

---

## EvoLab Global States

EvoLab communicates a set of predefined global states to Kickdrum, influencing its overall behavioral tendencies.

| State  | Description |
|------|-------------|
| dawn | Awakening, sensitivity, exploratory behavior |
| day | Social activity, increased movement and energy |
| dusk | Reflection, deceleration |
| night | Solitude, inward focus |
| danger | Overstimulation, urgency, heightened tension |

Each state affects rhythmic density, dynamic intensity, and the probability of internal events.

---

## Internal Encounter System

In addition to global states, Kickdrum generates **internal encounters** that introduce short-term modifications to its sonic output.

### Encounter Categories

#### People
- `stranger`
- `friend`
- `crowd`

#### Walking (Spatial Contexts)
- `cityStreet`
- `forest`
- `lake`
- `sea`

#### Eating
- `comfort`
- `bitter`

#### Movie (Narrative / Emotional Stimuli)
- `scary`
- `funny`
- `neutral`
- `awe`
- `sad`

Encounters influence envelope characteristics, filtering, rhythmic behavior, spatial movement, and the spectral qualities of the noise layer.

---

## Event Distribution Model

Internal encounters are probabilistically selected based on the current EvoLab global state.

### Dawn
- walking — 40%
- people — 25%
- eating — 20%
- movie — 15%

### Day
- people — 35%
- walking — 30%
- movie — 20%
- eating — 15%

### Dusk
- walking — 35%
- movie — 30%
- people — 20%
- eating — 15%

### Night
- movie — 40%
- walking — 25%
- eating — 20%
- people — 15%

### Danger
- people — 45%
- walking — 35%
- movie — 15%
- eating — 5%

This distribution model allows the creature’s internal behavior to remain contextually coherent with the broader installation environment.

---

## Auto-Event System

Kickdrum includes an **automatic event system** responsible for triggering internal encounters.

- Auto-events are **enabled by default**
- Event frequency is modulated by the active EvoLab state
- Auto-events operate as an additional behavioral layer rather than replacing global control
- The system may be manually enabled or disabled

---

## Audio Configuration


### Required Audio File

- `kickdrum.wav`

### Audio Specifications

- Mono (single channel)
- WAV format
- Lowercase filename
All audio resources must be placed in the following directory:

---

## Control Interface


### Auto-Event Control

The automatic encounter system may be enabled or disabled manually using the following commands:

```supercollider
Kickdrum.default.autoOn;
Kickdrum.default.autoOff;
```

### Manual Encounter Triggers

Encounter categories may be triggered manually, bypassing the automatic encounter-selection mechanism:

```supercollider
Kickdrum.default.people;
Kickdrum.default.walking;
Kickdrum.default.eating;
Kickdrum.default.movie;
```

### Explicit Encounter Invocation

Specific encounters can be triggered directly by explicitly defining both the encounter category and the encounter type:

```supercollider
Kickdrum.default.encounter(\people, \crowd);
Kickdrum.default.encounter(\walking, \sea);
Kickdrum.default.encounter(\movie, \scary);
Kickdrum.default.encounter(\eating, \comfort);
```

### Termination

All active processes and sound generation within the Kickdrum system can be halted using the following command:

```supercollider
Kickdrum.default.stop;
```

---

## Conclusion

Kickdrum functions as a **reactive generative sound agent** that integrates structured environmental input with autonomous internal processes.
Through the interaction of rhythmic and textural sound layers, the system demonstrates how sonic behavior can be employed to model **emotion**, **movement**, and **situated interaction** within a multichannel installation context.
