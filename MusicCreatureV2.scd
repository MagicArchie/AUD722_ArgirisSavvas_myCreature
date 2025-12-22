///////////////////////////////////////////////////////////////////////
// 0. BOOT & LOAD SAMPLES
///////////////////////////////////////////////////////////////////////

(
Server.default.options.numOutputBusChannels = 1;
Server.default.reboot;
~creatureNode = nil;
)

(
"C:/Users/User/Desktop/MusicCode/Samples/*.wav"
    .standardizePath
    .pathMatch
    .do { |p|
        currentEnvironment.put(
            PathName(p).fileNameWithoutExtension.asSymbol,
            Buffer.read(Server.default, p)
        );
};
)

// optional: list all loaded files
(
"C:/Users/User/Desktop/MusicCode/Samples/*.wav"
    .standardizePath
    .pathMatch
    .do(_.postln);
)

// buffer test
~kick_drum_mono;
~kick_drum_mono.numChannels.postln;


///////////////////////////////////////////////////////////////////////
// 1. CREATURE BEHAVIOR (Body + Soul + ADSR) – mono output, updatable
///////////////////////////////////////////////////////////////////////

(
~creature = { |bufnum, soulFreq = 180, rate = 1,
    lagTime = 0.3,
    atk = 0.03, dec = 0.3, sus = 0.6, rel = 1.5|

    var body, soul, ring, env;

    // Simple amplitude envelope, always on (no gate, we free from language)
    env = EnvGen.kr(
        Env.adsr(atk, dec, sus, rel),
        gate: 1,
        doneAction: 0
    );

    // BODY (looping sample) – smooth rate changes
    body = PlayBuf.ar(
        numChannels: 1,
        bufnum: bufnum,
        rate: BufRateScale.kr(bufnum) * Lag.kr(rate, lagTime),
        loop: 1
    );

    // SOUL (sine wave) – smooth pitch changes
    soul = SinOsc.ar(Lag.kr(soulFreq, lagTime), 0, 0.2);

    // INTERTWINING (ring modulation)
    ring = body * soul;

    // MONO OUTPUT
    ring * env;
};
)


///////////////////////////////////////////////////////////////////////
// 2. STATE → SOUND + LOGS (.set to morph one creature)
///////////////////////////////////////////////////////////////////////

(
~playState = { |buf, daySym, eventType, eventDetail|
    var baseFreq, baseRate, soulFreq, rate, atk, dec, sus, rel, lagTime;

    // ---------- base per DAY ----------
    switch(daySym,
        \sunrise,   { baseFreq = 250; baseRate = 1.1; },
        \morning,   { baseFreq = 200; baseRate = 1.0; },
        \afternoon, { baseFreq = 230; baseRate = 1.2; },
        \sunset,    { baseFreq = 180; baseRate = 0.9; },
        \night,     { baseFreq = 90;  baseRate = 0.7; },
        { baseFreq = 180; baseRate = 1.0; }
    );

    // default ADSR & modifiers
    soulFreq = baseFreq;
    rate     = baseRate;
    atk = 0.03; dec = 0.3; sus = 0.6; rel = 1.5;
    lagTime = 0.3;

    // ---------- EVENTS + DETAILS ----------
    switch(eventType,
        \people, {
            if(eventDetail == \nervous, {
                soulFreq = baseFreq + 300;
                atk = 0.01; dec = 0.1; sus = 0.7; rel = 0.3;
                lagTime = 0.05;
            }, { // happy
                soulFreq = baseFreq + 150;
                atk = 0.05; dec = 0.3; sus = 0.5; rel = 1.0;
                lagTime = 0.15;
            });
        },

        \walking, {
            if(eventDetail == \road_cars, {
                soulFreq = baseFreq + 200;
                rate = baseRate * 1.3;
                lagTime = 0.1;
            }, {
                if(eventDetail == \forest, {
                    soulFreq = baseFreq - 40;
                    rate = baseRate * 0.9;
                    lagTime = 0.5;
                }, {
                    if(eventDetail == \lake, {
                        soulFreq = baseFreq - 20;
                        rate = baseRate * 0.8;
                        lagTime = 0.6;
                    }, { // sea
                        soulFreq = baseFreq - 10;
                        rate = baseRate * 0.85;
                        lagTime = 0.7;
                    });
                });
            });
        },

        \eating, {
            if(eventDetail == \tasty, {
                soulFreq = baseFreq + 80;
                sus = 0.7;
                lagTime = 0.2;
            }, { // disgusting
                soulFreq = baseFreq + 400;
                atk = 0.01; dec = 0.2; sus = 0.2; rel = 0.5;
                lagTime = 0.1;
            });
        },

        \movie, {
            switch(eventDetail,
                \scary, {
                    soulFreq = baseFreq + 350;
                    atk = 0.01; dec = 0.2; sus = 0.6; rel = 0.7;
                    lagTime = 0.1;
                },
                \funny, {
                    soulFreq = baseFreq + 120;
                    atk = 0.05; dec = 0.3; sus = 0.5; rel = 1.2;
                    lagTime = 0.2;
                },
                \neutral, {
                    // close to base
                },
                \impressive, {
                    soulFreq = baseFreq + 250;
                    rate = baseRate * 1.1;
                    lagTime = 0.25;
                }
            );
        }
    );

    // ---------- LOGS ----------
    (
        "\n------------------------\n" ++
        "[DAY]    %\n[EVENT]  % → %\n[PARAMS] freq:%  rate:%  ADSR:%  lag:%\n"
        .format(daySym, eventType, eventDetail, soulFreq, rate, [atk, dec, sus, rel], lagTime)
    ).postln;

    // ---------- CREATE / UPDATE CREATURE ----------
    // create once
    if(~creatureNode.isNil) {
        ~creatureNode = ~creature.play(args: [\bufnum, buf.bufnum]);
    };

    // then just update its parameters
    ~creatureNode.set(
        \soulFreq, soulFreq,
        \rate, rate,
        \lagTime, lagTime,
        \atk, atk, \dec, dec, \sus, sus, \rel, rel
    );
};
)

// quick manual test
~playState.(~kick_drum_mono, \morning, \people, \happy);


///////////////////////////////////////////////////////////////////////
// 3. WORLD: day cycle + random events + logs
///////////////////////////////////////////////////////////////////////

// WORLD TIMING CONTROLS
~dayDuration   = 240.0;
~eventMinWait  = 8.0;
~eventMaxWait  = 18.0;

(
~scenario2min = Routine {
    var maxTime   = ~dayDuration   ? 180.0;
    var minWait   = ~eventMinWait  ? 6.0;
    var maxWait   = ~eventMaxWait  ? 12.0;

    var elapsed = 0.0;

    var dayPhases = [\sunrise, \morning, \afternoon, \sunset, \night];
    var currentPhaseIndex = 0;
    var phaseDur = maxTime / dayPhases.size;
    var nextPhaseTime = phaseDur;

    var buf = ~kick_drum_mono;
    var eventType, eventDetail, waitTime, day;

    ("[SCENARIO] Starting world. Duration:" + maxTime).postln;
    ("[SCENARIO] Event interval: " ++ minWait ++ "–" ++ maxWait ++ " seconds").postln;

    while({ elapsed < maxTime }, {

        day = dayPhases[currentPhaseIndex];

        // event type
        eventType = [\people, \walking, \eating, \movie].choose;

        // event detail
        switch(eventType,
            \people,  { eventDetail = [\nervous, \happy].choose; },
            \walking, { eventDetail = [\road_cars, \forest, \lake, \sea].choose; },
            \eating,  { eventDetail = [\tasty, \disgusting].choose; },
            \movie,   { eventDetail = [\scary, \funny, \neutral, \impressive].choose; }
        );

        // apply state
        ~playState.(buf, day, eventType, eventDetail);

        // wait between events
        waitTime = rrand(minWait, maxWait);
        waitTime.wait;
        elapsed = elapsed + waitTime;

        // day phase progression
        if(elapsed >= nextPhaseTime) {
            if(currentPhaseIndex < (dayPhases.size - 1)) {
                currentPhaseIndex = currentPhaseIndex + 1;
                nextPhaseTime = nextPhaseTime + phaseDur;
                ("[DAY-CYCLE] Switching to " ++ dayPhases[currentPhaseIndex]).postln;
            };
        };
    });

    "[SCENARIO] Finished world.".postln;

    // free creature at end
    if(~creatureNode.notNil) {
        ~creatureNode.free;
        ~creatureNode = nil;
    };
};
)


///////////////////////////////////////////////////////////////////////
// 4. CONTROL
///////////////////////////////////////////////////////////////////////

// Start world
~scenario2min.play;

// Stop world early (hard stop, no tail)
(
~scenario2min.stop;
if(~creatureNode.notNil) {
    ~creatureNode.free;
    ~creatureNode = nil;
};
)

// Restart from beginning
(
~scenario2min.reset;
~scenario2min.play;
)

// PANIC if something is still stuck:
(
Server.default.freeAll;
~creatureNode = nil;
)
