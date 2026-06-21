-- MindSeeker: data for the Mind-Seeker secret.
-- The private addon table (MS) is shared between all of this addon's files.
local ADDON, MS = ...

MS.ACHIEVEMENT_ID = 62189   -- Mind-Seeker (Feat of Strength)
MS.REQUIRED       = 17      -- secrets needed to join the cabal

-- Detection per record:
--   kind = "collectible" -> matched by name against your Mount Journal AND Pet
--                           Journal (so it works whether the secret yields a
--                           mount or a pet, and even if names differ slightly --
--                           use `aliases` for extra names to try).
--   kind = "toy"         -> PlayerHasToy(id)
--   kind = "transmog"    -> you own the appearance of item `id`
--   kind = "achievement" -> the achievement `id` is completed
--   kind = "manual"      -> no reliable API; you tick it yourself in the window.
--
-- You can ALWAYS click the checkbox in the detail panel to manually mark any
-- record as done (handy if auto-detection ever misses one).
--
-- `record` is the name shown on the mural. `name` is the actual collectible.
-- Guides are condensed from community walkthroughs (warcraft-secrets.com,
-- Wowhead). For the long ones, use those sites for every micro-detail.

MS.records = {
  { record = "Record of the Secrets Behind You", name = "Slime Serpent", kind = "collectible",
    guide = [[Where: Plaguefall dungeon, Maldraxxus (Shadowlands).

1. Set difficulty to Heroic or Mythic and enter Plaguefall solo.
2. Defeat all four bosses: Globgrog, Doctor Ickus, Domina Venomblade and Margrave Stradama.
3. After the last boss, take the transport pad back up to the surface.
4. Find the Curious Slime Serpent in the nearby slime pools and interact with it to learn the mount.]] },

  { record = "Record of Drak'Thul's Madness", name = "Fathom Dweller", kind = "collectible",
    guide = [[Where: Broken Isles (Legion). Unlocks the bi-weekly World Quest "DANGER: Kosumoth the Hungering".

1. Find the orc Drak'thul on the southern shoreline of the Broken Shore. Talk to him until he tells you to leave.
2. Go to Feldust Cavern (58.5, 54); at the end, click the mound of dirt for the Weathered Relic. Return and talk to Drak'thul again.
3. Click the 10 hidden pinkish Orbs across the Broken Isles in the correct order (use a coordinate guide).
4. This unlocks the World Quest in the outdoor Eye of Azshara. Kill Kosumoth; reward is the Fathom Dweller (mount) OR Hungering Claw (pet). Repeats every 2 weeks.]] },

  { record = "Record of Taming the Maw", name = "Bound Shadehound", kind = "collectible",
    guide = [[Where: The Maw (Shadowlands). Needs Ve'nari rep and lots of Stygia.

1. Finish the Maw intro plus dailies "Rule 5: Be Audacious" and "Rule 6: Concealment is Everything"; reach Appreciative with Ve'nari.
2. From Ve'nari buy the Animated Levitating Chain (grapple) and the Stygia Dowser.
3. At the Altar of Domination (24.2, 75.8) grapple up and solve the rune-chest puzzle; loot the Crumbling Stele (note its rune order!).
4. Buy the Partial Rune Codex, gather 3 pages (Death's Howl cave, Perdition Hold, above Tremaculum) and combine into the Intact Rune Codex.
5. Kill Soulforger Rhovus (35.8, 42.6) for Soulforger's Tools (daily).
6. Find the ghost wolf patrolling the River of Souls; interact for the Willing Wolf Soul.
7. With the Stygia Dowser, farm 200 Stygia Dust + 200 Stygia Sliver (best in The Beastwarrens).
8. At the Soulsteel Anvil (20.0, 66.8) craft 20 Stygia Bars, then the Armored Husk.
9. At the Binding Altar (45.2, 48.3) combine Armored Husk + Willing Wolf Soul into the Feral Shadehound.
10. Summon the Feral Shadehound and enter the runes in the Crumbling Stele's order to tame the Bound Shadehound.]] },

  { record = "Record of the Riddler", name = "Riddler's Mind-Worm", kind = "collectible",
    guide = [[Where: 8 hidden Pages across Azeroth; reward in Westfall.

Read the 8 Pages (order matters):
1. Dalaran - Legerdemain Lounge bookshelf (ground floor)
2. Duskwood - table by the moonwell, Twilight Grove (49, 33)
3. Firelands - platform edge near Ragnaros
4. Uldum (Cataclysm timeline via Zidormi) - east of Lost City of Tol'vir (70, 78)
5. Siege of Orgrimmar - Sha of Pride room
6. Well of Eternity dungeon (Caverns of Time)
7. Kun-Lai Summit - near Shado-Pan Monastery (34.6, 50.9)
8. Uldum (Cataclysm timeline) - base of statue (76.4, 53.6)

Then go to Westfall's west coast (30.5, 28) and interact with the Gift of the Mind-Seekers for the mount.]] },

  { record = "Record of Abyssal Blood", name = "Nazjatar Blood Serpent", kind = "collectible",
    guide = [[Where: Stormsong Valley (BfA).

1. Collect 20 Abyssal Fragments (drop in Kul Tiras/Zandalar, or buy on the Auction House - not soulbound).
2. Go to the Altar of the Abyss in a cave behind a waterfall in Stormsong Valley (74.6, 21.8); use it to turn the 20 fragments into the Abhorrent Essence of the Abyss.
3. Go to The Abyssal Flame at Warfang Hold (45.1, 36.8) and use the Essence to summon the Adherent of the Abyss.
4. Defeat the Adherent (tough solo when undergeared) - it drops the Nazjatar Blood Serpent for the summoner.]] },

  { record = "Record of Rising Ashes", name = "Phoenix Wishwing", kind = "collectible",
    guide = [[Type: Battle Pet.

1. Build the Phoenix Ash Talisman: 1 Glittering Phoenix Ember from Alysrazor (Firelands, Cataclysm Timewalking); 20 Inert Phoenix Ash (Scorching Elementals / Living Blaze in Un'Goro); 10 Sacred Phoenix Ash from "Small Pile of Ash" cooking pots in Spires of Arak.
2. Trade them to Zektar in Spires of Arak (52.1, 50.5) for the Phoenix Ash Talisman.
3. Farm 15 Smoldering Phoenix Ash from phoenixes in Neltharus (clear to Chargath, reset, repeat).
4. Buy the Ash Feather Amulet from Griftah in the Waking Shores; use it to spawn and collect 20 Ash Feathers on the platform above the Obsidian Throne.
5. Turn everything in to Tarjin the Blind in the Waking Shores (16.2, 62.6) to finish "Tale of the Phoenix" and get the Phoenix Wishwing.]] },

  { record = "Record of the Cavern of Consumption", name = "Sun Darter Hatchling", kind = "collectible",
    guide = [[Where: Caverns of Consumption, Winterspring (57.2, 13.9). Bring a bag of consumables.

1. Elemental Gates: drink a Major Fire Protection Potion, then the other five Major Protection Potions (Arcane, Frost, Holy, Nature, Shadow).
2. Diligent Watcher: drink Noggenfogger Elixirs until you turn into a skeleton to slip past the gargoyle.
3. Wall of Vines: use Scotty's Lucky Coin to become a sprite; loot the Water Stone from the pool.
4. Water Barrier: use the Water Stone to pass.
5. Stone Watcher: drink Dire Brew to become an Iron Dwarf and pass the golem.
6. Wisdom Cube: drink ~20 Pygmy Oil (gnome-sized), summon Perky Pug, equip the "Little Princess" Costume, click the cube for "Sign of the First".
7. Strange Stone: drink Ethereal Oil, equip the Gordok Ogre Suit + Winterfall Firewater, click the stone for "Sign of the Second".
8. With both buffs, go downstairs, read the Tarnished Plaque, remove Winterfall Firewater, use a Scroll of Intellect, then loot the Oddly-Colored Egg (Sun Darter Hatchling).]] },

  { record = "Record of Collective Courage", name = "Courage", kind = "collectible",
    guide = [[Where: Nemea's Retreat, Bastion. Group secret (about 5 players).

1. Gather ~5 players and spread out to the 9 Larion Cub locations around Nemea's Retreat.
2. On a countdown, interact with at least 5 Larion Cubs within 10 seconds.
3. Courage spawns briefly near Nemea - interact with him within 30 seconds to get the pet.]] },

  { record = "Trophy of Revelations", name = "Mind-Seeker", kind = "collectible",
    guide = [[This is the reward itself - the title and the Mind-Seeker.

1. Solve at least 17 of the 33 secrets in this list.
2. Travel to the alternate Seat of Knowledge in the Vale of Eternal Blossoms.
3. Speak with Anakron and choose "I am ready" to join the cabal and earn the Mind-Seeker.]] },

  { record = "Record of Collaborative Cogitation", name = "Enlightened Hearthstone", kind = "toy", id = 190196,
    guide = [[Where: Zereth Mortis. Group secret (6 players).

1. Each of the 6 players must have the Sphere of Enlightened Cogitation.
2. All six stand on the hexagon pillars surrounding the central pool in Zereth Mortis.
3. Use the Sphere at the same time to unlock the Enlightened Hearthstone toy for everyone.]] },

  { record = "Record of Ephemeral Crystals", name = "Long-Forgotten Hippogryph", kind = "collectible",
    aliases = { "Reins of the Long-Forgotten Hippogryph" },
    guide = [[Where: Azsuna (Legion). Patience required.

1. Click any Ephemeral Crystal in Azsuna for the "Crystal Dummy Aura" (8-hour buff).
2. Find and click four more Ephemeral Crystals (10+ possible spawn spots; the HandyNotes addon helps) before the 8 hours run out.
3. Do NOT die - dying removes the buff and you start over.
4. Clicking the 5th crystal awards the Long-Forgotten Hippogryph. Crystals respawn every 2-8h and reset weekly, so just after weekly maintenance is best.]] },

  { record = "Record of Buried Treasure", name = "Wan'be's Buried Goods", kind = "manual",
    guide = [[Where: Zuldazar (a treasure hunt). No collection API - tick this manually when done.

1. Follow the clue trail around Zuldazar.
2. Dig up Wan'be's Buried Goods at the final spot.

Full clue chain: warcraft-secrets.com/guides/treasure-hunt-wanbes-buried-goods]] },

  { record = "Record of a Friend in the Darkness", name = "Uuna", kind = "collectible",
    aliases = { "Uuna's Doll" },
    guide = [[Where: starts on Argus (Antoran Wastes), then a long world-tour questline.

1. In Antoran Wastes gather: Call of the Devourer (mobs at Scavenger's Boneyard 52,38), Ur'zul Bone (50.4, 56.1), Imp Bone (cave 65.9, 19.4), Fiend Bone (52.4, 35.3).
2. Click the Bone Effigy (54.8, 39.2) with all four items to summon and kill The Many-Faced Devourer; loot Uuna's Doll.
3. Summon Uuna and complete her 12-step questline: bond with emotes (whistle/roar/cry), visit A'dal in Shattrath, Lake Falathim (Ashenvale), Nuu in Eredath, Blood Watch (Bloodmyst), Shadowmoon Valley (Draenor).
4. Finish the "Dark Place" steps (die, talk to the Spirit Healer, find the Shadow Tear in Dragonblight, cheer, place a cooking fire, survive 3 min, hug Uuna), then complete the 8-stop World Tour to earn the Uuna pet.]] },

  { record = "Record of Cartel Cyphers", name = "Xy Trustee's Gearglider", kind = "collectible",
    guide = [[Where: Manaforge Omega raid + K'aresh (The War Within). ~3 weeks (weekly gate).

1. Reach Renown 8 with Manaforge Vandals.
2. Get three deals (craft / Auction House): Deal: Cartel Ba, Deal: Cartel Zo, Deal: Cartel Om - you can only use one deal per week.
3. After joining each cartel, grab its hidden cypher:
   - Cartel Ba: edge of the platform after Plexus Sentinel (The Forge Core).
   - Cartel Zo: on a mana vent in Technomancers' Terrace (keep Forgeweaver Araz alive).
   - Cartel Om: on a rock in the northern Wastes of K'aresh (after Fractillus).
4. Speak with Zo'turu in K'aresh to complete "Someone Like Me" for the mount (and Cartel Transmorpher toy).]] },

  { record = "Record of Ominously Ordinary Pebbles", name = "Baa'l", kind = "collectible",
    guide = [[Where: BfA zones + Frostfire Ridge. Requires Uuna's storyline finished (yours or a friend's).

1. Grab the Conspicuous Note at the Heart of Darkness temple in Nazmir (51.8, 59.1).
2. Collect 13 Pebbles hidden in caves across BfA zones (Broken Shore, Boralus, Zuldazar, Drustvar, Vol'dun, Stormsong, Tiragarde, underwater caves - use a coordinate guide).
3. Rearrange the capitalized letters on the pebbles (anagram) - they spell "Kurgthuk the Merciless" / "Get Back to Work".
4. Go to the volcano in Frostfire Ridge, Draenor (62.2, 22.8).
5. Summon Uuna (to weaken it), then summon and defeat Baa'l to get Baa'ls Darksign; use it to learn the Baa'l pet. (Baa'l is the prerequisite for Waist of Time.)]] },

  { record = "Record of Time Waisted", name = "Waist of Time", kind = "transmog", id = 162690,
    guide = [[Where: Arathi Highlands. Requires Baa'l first.

1. After obtaining Baa'l, start the Waist of Time chain: solve the anagram and perform the required emotes/steps around Azeroth.
2. Finish at the unnamed dwarven farm in Arathi Highlands and loot the Waist of Time belt from Grimmy's Rusty Lockbox.

Exact emote/step order: warcraft-secrets.com/guides/waist-of-time]] },

  { record = "Record of Karazhan's Kitten", name = "Jenafur", kind = "collectible",
    guide = [[Where: starts in Ashenvale/Elwynn, finishes in Return to Karazhan. Soloable.

1. Talk to Amara Lunastar in Ashenvale (17.4, 49.3) about her missing cat.
2. Go to Donni Anthania's house in Elwynn Forest (44.2, 53.1) and click the Empty Dish.
3. In Return to Karazhan, collect from the Banquet Hall / Guest Chambers: 2 Juicy Drumsticks, 2 Marbled Steaks, 2 Fishy Bits, 1 Meaty Morsel, 1 Slathered Rib (items vanish after ~5 min - be quick).
4. In the Opera Hall, place the 8 food items on the floor tiles in the musical-staff pattern (see a guide image).
5. When "Amara's Wish" plays, interact with Jenafur to get the pet.]] },

  { record = "Record of Slippery Find", name = "Otto", kind = "collectible",
    guide = [[Where: Dragon Isles (Dragonflight). Lots of fishing.

1. Get a Gold Coin of the Isles (fishing pools, or kill Sir Pinchalot in the Forbidden Reach using Elusive Croaking Crabs).
2. Trade it to The Great Swog in Ohn'ahran Plains (82.2, 73.2) for an Immaculate Sac of Swog Treasures; open it for the Aquatic Shades toy.
3. Go to The Bubble Bath (Thaldraszus 19.6, 36.5), equip the Aquatic Shades, dive in and stand on the dance stage until "Dance, Dance 'Til You're Dead" expires - you teleport to Hissing Grotto.
4. Pick up the Empty Fish Barrel, then fish: 100 Frigid Floe Fish (near Iskaara), 25 Calamitous Carp (Obsidian Citadel lava), 1 Kingfin (Algeth'ar Academy dock).
5. Return the filled barrel to Hissing Grotto (20.3, 39.7) and complete "The Way to an Otto's Heart" for the mount.]] },

  { record = "Record of a Dominant Hand", name = "Hand of Nilganihmaht", kind = "collectible",
    aliases = { "Nilganihmaht Control Ring", "Nilganihmaht" },
    guide = [[Where: The Maw (Shadowlands). Collect 5 rings, then assemble.

1. Stone Ring: during a Necrolord Assault, collect 4 Quartered Ancient Rings (Mawsworn Caches, "Clearing the Walls" reward, the Maw Mad Construct, Perdition Hold ground) and reforge at the Soulsteel Forge.
2. Runed Band: kill Torglluun, visible only in the Rift phase (use Collapsing Riftstone / Repaired Riftkey).
3. Signet Ring: defeat Exos, Herald of Domination atop the Altar of Domination (reach via Domination's Calling or grapple).
4. Silver Ring: open the Domination Sealed Chest using 4 Seal Breaker Keys (Maldraxxi Defector, Harrower's Key Ring, Helgarde Supply Caches, Ylva).
5. Gold Band: atop the mountain in Calcis (grapple + mountain path).
6. Take all 5 rings to the Hand of Nilganihmaht NPC in the Rift-phase cave and complete "Gotta Hand It To Ya" for the mount.]] },

  { record = "Record of Mimiron's Master Mind", name = "Mimiron's Jumpjets", kind = "toy", id = 210022,
    guide = [[Where: Secrets of Azeroth event areas. Group needed for the parts.

1. First Booster Part: Cape of Stranglethorn (59.4, 79.0) - with 2 friends, light the 3 Jaguero Braziers with the Torch of Pyrreth to summon Enigma Ward; it drops the part.
2. Second Booster Part: Feralas (50.6, 26.0) - a group of 4; one player controls the Water Elemental and sucks up the others, it explodes, then loot the part.
3. Third Booster Part: Blasted Lands, on the Dark Portal steps (54.8, 52.1) - long interact; hover on a flying mount to loot safely.
4. Go to the Empowered Forge (36.68, 61.85) and click a Booster Part to assemble Mimiron's Jumpjets.]] },

  { record = "Record of the Siren's Song", name = "Thrayir, Eyes of the Siren", kind = "collectible",
    guide = [[Where: Siren Isle (The War Within). Collect 5 runekeys.

1. Use the Singing Tablet on Siren Isle to enter the Forgotten Vault (Thrayir is in stasis here).
2. Cyclonic Runekey: low-chance drop from the rare Zek'ul the Shipbreaker.
3. Turbulent Runekey: combine 3 Turbulent Fragments found across the isle (dirt piles, etc.).
4. Whirling Runekey: drops from Ksvir the Forgotten in the southern room of the Vault.
5. Torrential Runekey: 7 Torrential Fragments from Brinebound Wraiths / Kvaldir (north).
6. Thunderous Runekey: 5 Thunderous Fragments from Rune Storm Caches (finish "A Song of Secrets" first for the Runecaster's Eye).
7. With all 5 runekeys, break the seal to claim Thrayir.]] },

  { record = "Record of Grggly Stash", name = "Crimson Tidestallion", kind = "collectible",
    guide = [[Where: Nazjatar (BfA), from the secret vendor Mrrl. Daily-gated.

1. Rescue Mrrl from Dragon's Teeth Basin (48.1, 45.3) and complete the Nazjatar story to unlock him.
2. Get the Azsh'ari Stormsurger Cape: buy Benthic Cloaks (5 Prismatic Manapearl each) until one becomes the cape - you must WEAR it to see the mount on Mrrl.
3. Via the murloc trading game (vendors Mrrglrlr, Grrmrlg, Flrgrrl, Hurlgrl) collect 4 Cultist Pinky Finger + 2 Pulsating Blood Stone (these expire in 24h - only get them when the mount is actually for sale).
4. Complete Murloco's event (cave ~46.3, 32.6, cape equipped) to buy the Hungry Herald's Tentacle Taco.
5. When the Crimson Tidestallion appears on Mrrl (rotates daily), buy it with 4 fingers + 2 stones + 1 taco.]] },

  { record = "Record of a Bad Horse", name = "Sinrunner Blanchy", kind = "collectible",
    aliases = { "Blanchy", "Blanchy's Reins" },
    guide = [[Where: Revendreth (Shadowlands). 6 steps, one per day.

1. Find Dead Blanchy on the river in Endmire, Revendreth (1-2h respawn, up ~5 min; use Group Finder to realm-hop).
2. Day 1: feed 8 Handful of Oats from Saldean's Farm, Westfall.
3. Day 2: bring the Grooming Brush from Snickersnee in Darkhaven.
4. Day 3: bring 4 Sturdy Horseshoes from Discarded Horseshoes on Darkhaven roads.
5. Day 4: fill the Empty Water Bucket (from near Snickersnee) at a water source in Bastion/Ardenweald and deliver.
6. Day 5: buy the Comfortable Saddle Blanket from Ta'tru (south Revendreth).
7. Day 6: bring 3 Dredhollow Apples from Mims (Hole in the Wall) to get Blanchy's Reins. One step per day; missing a day only delays you - no penalty.]] },

  { record = "Record of the Hivemind", name = "The Hivemind", kind = "collectible",
    guide = [[Where: across Azeroth, then group puzzles in Suramar / Court of Stars. 5-player secret.

1. Solo: buy the Talisman of True Treasure Tracking from Griftah (Shattrath) and earn 4 colored monocles (Red - Vashj'ir, Blue - anagram, Green - Skyreach, Yellow - Halls of Origination).
2. Group of 5: in Suramar, equip monocles matching each Wild Withered's color and bring all four to 1 HP at once; a 5th player grabs the Lost Cat Toy and notes the damage taken.
3. Court of Stars: pet 5 Mana Kittens to stack purrs matching that damage number, then click the Ominous Orb.
4. Cross the phaseshifting platforms together (players activate platforms for each other).
5. Solve the Lightlocked river-crossing logic puzzle (1 driver, 2 adults, 2 children).
6. All 5 stand in the final room's purple spots and channel together to get The Hivemind.]] },

  { record = "Record of the Endless Nightmare", name = "Lucid Nightmare", kind = "collectible",
    guide = [[Where: a chain of 7 puzzles across the world. Soloable but long.

1. Dalaran clue (Curiosities & Moore) -> Ulduar Scrapyard: pull the Rusty Lever and draw the gear pattern on the Scrapyard Lights grid.
2. AQ40: at the Mind Larva past C'thun, win the Mindcraft "connect 5 brains" game.
3. Deepholm: get a Shadoweave Mask, enter the Dark Fissure, equip the mask and click the Strange Skull.
4. Gnomeregan Engineering Labs: enter 1222176597 across the ten Numeric Consoles.
5. Val'sharah: at the Nightmare Tumor, uncross Il'gynoth's optic nerves (Eyecraft).
6. Kun-Lai (Tomb of Secrets): in the 8x8 Endless Halls maze, place 5 colored orbs on matching runes.
7. Karazhan's Forgotten Crypts: loot the Lucid Nightmare from the chest in the Pit of Criminals.]] },

  { record = "Record of Necromantic Knowledge", name = "Memory of Scholomance", kind = "achievement", id = 18368,
    guide = [[Where: Scholomance (Caer Darrow, Western Plaguelands).

1. Get Krastinov's Bag of Horrors - drops from the rare Doctor Theolen Krastinov in Heroic Scholomance.
2. Use the bag to perform the ritual that reopens the old (pre-revamp) Scholomance, earning the Memory of Scholomance achievement.

Ritual details: warcraft-secrets.com/guides/memory-of-scholomance]] },

  { record = "Record of Lost Obsidian Treasures", name = "Black Dragon's Challenge Dummy", kind = "toy", id = 201933,
    guide = [[Where: Obsidian Citadel area, Dragon Isles.

1. Obtain the Lost Cache Key (from the Lost Obsidian Treasures chain - follow the Blacktalon / Sour Apple clues).
2. Use it to open the Lost Obsidian Cache and loot the Black Dragon's Challenge Dummy toy.]] },

  { record = "Record of Drust Rituals", name = "Wicker Pup", kind = "collectible",
    aliases = { "Spooky Bundle of Sticks" },
    guide = [[Where: Drustvar (BfA). Quick and easy.

1. Collect 4 hidden parts in Drustvar:
   - Bundle of Wicker Sticks (18.5, 51.4)
   - Miniature Stag Skull (67.8, 73.7)
   - Wolf Pup Spine (25.4, 24.1)
   - Spooky Incantation (55.5, 51.8)
2. Click any one of the parts in your bags to combine them into the Spooky Bundle of Sticks, which teaches the Wicker Pup pet.]] },

  { record = "Record of Visions of Void", name = "Voidfire Deathcycle", kind = "collectible",
    aliases = { "Felreaver Deathcycle" },
    guide = [[Where: Revisited Horrific Visions (Stormwind / Orgrimmar).

1. Enter the Vision of Stormwind with at least 1 mask; in the Dwarven District, attack the Voidfire Deathcycle to start the fight with Haymar the Devout.
2. Defeat Haymar; interact with the downed cycle to send it to Dornogal.
3. Speak to the Deathcycle in Dornogal - it lists 6 missing components.
4. Gather the 6 components from Visions of Stormwind and Orgrimmar, then rebuild it to learn the Voidfire Deathcycle.]] },

  { record = "Record of Glimmering Hope", name = "Glimr", kind = "collectible",
    guide = [[Where: Northrend (Borean Tundra / Grizzly Hills). A short murloc questline.

1. Scare the Glimmerfin Scout off its iceberg in Grizzly Hills (18.4, 88.2) and pick up the Glimmerfin Scale.
2. Take it to King Mrgl-Mrgl in Borean Tundra (43.5, 13.9), then return to Glimmergut in Grizzly Hills (17.8, 93.2).
3. Work through the murloc quests: 10 Meaty Crab Chunk, the Horker's Pile of Blubberfat (10.3, 85.1), the Giant Pearl (22.3, 93.0; needs an aquatic mount), a Trainer's Test pet battle, and 3 seaweed stalks.
4. Defeat the elite Great Mua'kin (8.8, 91.1) and return to the Glimmerfin Oracle for Glimr's Cracked Egg (the Glimr pet).]] },

  { record = "Record of Indecipherable Mo'arg Technology", name = "Incognitro, the Indecipherable Felcycle", kind = "collectible",
    aliases = { "Incognitro" },
    guide = [[The most involved secret - many sub-puzzles. High-level outline:

1. Prerequisite: earn "Azeroth's Greatest Detective".
2. Get the Torch of Pyrreth and the Peculiar Key, then enter the Karazhan Catacombs scenario.
3. Solve the nine puzzles: Anagram, Old Gods (Vale ritual), Decryption Consoles (9 codes), Doom (Uther's Tomb), Golden Muffin (pet battle vs Jeremy Feasel), Altars of Acquisition, Owl of the Watchers (Azsuna), Enigma Machine, Cryptic Plaque.
4. Optional extensions: Oddsight Focus, Radiant Singer, Dusk Lily.
5. Assemble the Keys to Incognitro to unlock the Felcycle.

This one is huge - follow a full written walkthrough step by step.]] },

  { record = "Record of Rumors", name = "Tobias", kind = "collectible",
    aliases = { "Tobias' Leash" },
    guide = [[Type: Battle Pet. From the Secrets of Azeroth world event.

1. Make sure the Torch of Pyrreth is out so you can see Loose Dirt Mounds.
2. Find 10 of the 17 Buried Satchels in dirt mounds around the world (use community rumor coordinates).
3. This earns the Community Rumor Mill achievement and the Tobias pet. Satchels can be found in any order.]] },

  { record = "Record of Doug Roberts, Enigmatic Explorer", name = "Doug Roberts", kind = "manual",
    guide = [[An easter egg, not a required secret.

1. In the Sanctuary of the Mind-Seekers, look behind the westernmost pillar to find Doug Roberts, Enigmatic Explorer.
2. Say hello, then tick this box manually.]] },
}

MS.TOTAL = #MS.records
