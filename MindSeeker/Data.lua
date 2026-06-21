-- MindSeeker: data for the Mind-Seeker secret.
-- The private addon table (MS) is shared between all of this addon's files.
local ADDON, MS = ...

MS.ACHIEVEMENT_ID = 62189   -- Mind-Seeker (Feat of Strength)
MS.REQUIRED       = 17      -- secrets needed to join the cabal

-- ---------------------------------------------------------------------------
-- Authoritative collectible IDs (from the WoW Secret Finding community).
-- These are resolved to names + collected status AT RUNTIME, so detection is
-- exact and we never have to guess which id is which collectible.
--   Mounts: C_MountJournal.GetMountInfoByID(id)            -> name, ..., collected
--   Pets:   C_PetJournal.GetNumCollectedInfo(speciesID) > 0 -> owned
-- ---------------------------------------------------------------------------

MS.mountIDs = { 802, 838, 947, 961, 1025, 1057, 1260, 1414, 1441, 1445,
                1482, 1503, 1656, 1813, 1943, 1948, 2322 }          -- 17 mounts

MS.petIDs   = { 2136, 2352, 2411, 2795, 2888, 3065, 3292, 4263 }    -- 8 pets

-- Collectibles that aren't mounts or pets, detected by their own API.
MS.extras = {
  { name = "Enlightened Hearthstone",        kind = "toy",         id = 190196 },
  { name = "Black Dragon's Challenge Dummy", kind = "toy",         id = 201933 },
  { name = "Waist of Time",                  kind = "transmog",    id = 162690 },
  { name = "Memory of Scholomance",          kind = "achievement", id = 18368  },
  { name = "Wan'be's Buried Goods",          kind = "manual" },
  { name = "Doug Roberts, Enigmatic Explorer", kind = "manual" },
}

-- ---------------------------------------------------------------------------
-- Guides, keyed by normalized collectible name. Resolved names are matched
-- against these keys, so each guide attaches to the right row automatically.
-- ---------------------------------------------------------------------------

function MS.norm(s)
  return (s or ""):lower():gsub("[^%a%d]", "")
end

MS.guides = {}
local function G(names, record, links, text)
  local g = { record = record, links = links, text = text }
  for _, n in ipairs(names) do MS.guides[MS.norm(n)] = g end
end

function MS:FindGuide(name)
  return self.guides[MS.norm(name)]
end

local WS = "https://warcraft-secrets.com/guides/"

-- ----- Mounts --------------------------------------------------------------

G({ "Slime Serpent" }, "Record of the Secrets Behind You",
  { { "warcraft-secrets guide", WS.."slime-serpent" } },
[[Where: Plaguefall dungeon, Maldraxxus (Shadowlands).

1. Set difficulty to Heroic or Mythic and enter Plaguefall solo.
2. Defeat all four bosses: Globgrog, Doctor Ickus, Domina Venomblade and Margrave Stradama.
3. After the last boss, take the transport pad back up to the surface.
4. Find the Curious Slime Serpent in the nearby slime pools and interact with it to learn the mount.]])

G({ "Fathom Dweller" }, "Record of Drak'Thul's Madness",
  { { "warcraft-secrets guide", WS.."kosumoth-the-hungering" } },
[[Where: Broken Isles (Legion). Unlocks the bi-weekly World Quest "DANGER: Kosumoth the Hungering".

1. Find the orc Drak'thul on the southern shoreline of the Broken Shore. Talk to him until he tells you to leave.
2. Go to Feldust Cavern (58.5, 54); at the end, click the mound of dirt for the Weathered Relic. Return and talk to Drak'thul again.
3. Click the 10 hidden pinkish Orbs across the Broken Isles in the correct order (use a coordinate guide).
4. This unlocks the World Quest in the outdoor Eye of Azshara. Kill Kosumoth; reward is the Fathom Dweller (mount) OR Hungering Claw (pet). Repeats every 2 weeks.]])

G({ "Bound Shadehound" }, "Record of Taming the Maw",
  { { "warcraft-secrets guide", WS.."bound-shadehound" } },
[[Where: The Maw (Shadowlands). Needs Ve'nari rep and lots of Stygia.

1. Finish the Maw intro plus dailies "Rule 5: Be Audacious" and "Rule 6: Concealment is Everything"; reach Appreciative with Ve'nari.
2. From Ve'nari buy the Animated Levitating Chain (grapple) and the Stygia Dowser.
3. At the Altar of Domination (24.2, 75.8) grapple up and solve the rune-chest puzzle; loot the Crumbling Stele (note its rune order!).
4. Buy the Partial Rune Codex, gather 3 pages (Death's Howl cave, Perdition Hold, above Tremaculum) and combine into the Intact Rune Codex.
5. Kill Soulforger Rhovus (35.8, 42.6) for Soulforger's Tools (daily).
6. Find the ghost wolf patrolling the River of Souls; interact for the Willing Wolf Soul.
7. With the Stygia Dowser, farm 200 Stygia Dust + 200 Stygia Sliver (best in The Beastwarrens).
8. At the Soulsteel Anvil (20.0, 66.8) craft 20 Stygia Bars, then the Armored Husk.
9. At the Binding Altar (45.2, 48.3) combine Armored Husk + Willing Wolf Soul into the Feral Shadehound.
10. Summon the Feral Shadehound and enter the runes in the Crumbling Stele's order to tame the Bound Shadehound.]])

G({ "Riddler's Mind-Worm" }, "Record of the Riddler",
  { { "warcraft-secrets guide", WS.."riddlers-mind-worm" } },
[[Where: 8 hidden Pages across Azeroth; reward in Westfall.

Read the 8 Pages (order matters):
1. Dalaran - Legerdemain Lounge bookshelf (ground floor)
2. Duskwood - table by the moonwell, Twilight Grove (49, 33)
3. Firelands - platform edge near Ragnaros
4. Uldum (Cataclysm timeline via Zidormi) - east of Lost City of Tol'vir (70, 78)
5. Siege of Orgrimmar - Sha of Pride room
6. Well of Eternity dungeon (Caverns of Time)
7. Kun-Lai Summit - near Shado-Pan Monastery (34.6, 50.9)
8. Uldum (Cataclysm timeline) - base of statue (76.4, 53.6)

Then go to Westfall's west coast (30.5, 28) and interact with the Gift of the Mind-Seekers for the mount.]])

G({ "Nazjatar Blood Serpent" }, "Record of Abyssal Blood",
  { { "warcraft-secrets guide", WS.."nazjatar-blood-serpent" } },
[[Where: Stormsong Valley (BfA).

1. Collect 20 Abyssal Fragments (drop in Kul Tiras/Zandalar, or buy on the Auction House - not soulbound).
2. Go to the Altar of the Abyss in a cave behind a waterfall in Stormsong Valley (74.6, 21.8); use it to turn the 20 fragments into the Abhorrent Essence of the Abyss.
3. Go to The Abyssal Flame at Warfang Hold (45.1, 36.8) and use the Essence to summon the Adherent of the Abyss.
4. Defeat the Adherent (tough solo when undergeared) - it drops the Nazjatar Blood Serpent for the summoner.]])

G({ "Long-Forgotten Hippogryph", "Reins of the Long-Forgotten Hippogryph" }, "Record of Ephemeral Crystals",
  { { "warcraft-secrets guide", WS.."long-forgotten-hippogryph" } },
[[Where: Azsuna (Legion). Patience required.

1. Click any Ephemeral Crystal in Azsuna for the "Crystal Dummy Aura" (8-hour buff).
2. Find and click four more Ephemeral Crystals (10+ possible spawn spots; the HandyNotes addon helps) before the 8 hours run out.
3. Do NOT die - dying removes the buff and you start over.
4. Clicking the 5th crystal awards the Long-Forgotten Hippogryph. Crystals respawn every 2-8h and reset weekly, so just after weekly maintenance is best.]])

G({ "Xy Trustee's Gearglider" }, "Record of Cartel Cyphers",
  { { "warcraft-secrets guide", WS.."xy-trustees-gearglider" } },
[[Where: Manaforge Omega raid + K'aresh (The War Within). ~3 weeks (weekly gate).

1. Reach Renown 8 with Manaforge Vandals.
2. Get three deals (craft / Auction House): Deal: Cartel Ba, Deal: Cartel Zo, Deal: Cartel Om - you can only use one deal per week.
3. After joining each cartel, grab its hidden cypher:
   - Cartel Ba: edge of the platform after Plexus Sentinel (The Forge Core).
   - Cartel Zo: on a mana vent in Technomancers' Terrace (keep Forgeweaver Araz alive).
   - Cartel Om: on a rock in the northern Wastes of K'aresh (after Fractillus).
4. Speak with Zo'turu in K'aresh to complete "Someone Like Me" for the mount (and Cartel Transmorpher toy).]])

G({ "Otto" }, "Record of Slippery Find",
  { { "warcraft-secrets guide", WS.."otto" } },
[[Where: Dragon Isles (Dragonflight). Lots of fishing.

1. Get a Gold Coin of the Isles (fishing pools, or kill Sir Pinchalot in the Forbidden Reach using Elusive Croaking Crabs).
2. Trade it to The Great Swog in Ohn'ahran Plains (82.2, 73.2) for an Immaculate Sac of Swog Treasures; open it for the Aquatic Shades toy.
3. Go to The Bubble Bath (Thaldraszus 19.6, 36.5), equip the Aquatic Shades, dive in and stand on the dance stage until "Dance, Dance 'Til You're Dead" expires - you teleport to Hissing Grotto.
4. Pick up the Empty Fish Barrel, then fish: 100 Frigid Floe Fish (near Iskaara), 25 Calamitous Carp (Obsidian Citadel lava), 1 Kingfin (Algeth'ar Academy dock).
5. Return the filled barrel to Hissing Grotto (20.3, 39.7) and complete "The Way to an Otto's Heart" for the mount.]])

G({ "Hand of Nilganihmaht", "Nilganihmaht Control Ring", "Nilganihmaht" }, "Record of a Dominant Hand",
  { { "warcraft-secrets guide", WS.."hand-of-nilganihmaht" } },
[[Where: The Maw (Shadowlands). Collect 5 rings, then assemble.

1. Stone Ring: during a Necrolord Assault, collect 4 Quartered Ancient Rings (Mawsworn Caches, "Clearing the Walls" reward, the Maw Mad Construct, Perdition Hold ground) and reforge at the Soulsteel Forge.
2. Runed Band: kill Torglluun, visible only in the Rift phase (use Collapsing Riftstone / Repaired Riftkey).
3. Signet Ring: defeat Exos, Herald of Domination atop the Altar of Domination (reach via Domination's Calling or grapple).
4. Silver Ring: open the Domination Sealed Chest using 4 Seal Breaker Keys (Maldraxxi Defector, Harrower's Key Ring, Helgarde Supply Caches, Ylva).
5. Gold Band: atop the mountain in Calcis (grapple + mountain path).
6. Take all 5 rings to the Hand of Nilganihmaht NPC in the Rift-phase cave and complete "Gotta Hand It To Ya" for the mount.]])

G({ "Mimiron's Jumpjets" }, "Record of Mimiron's Master Mind",
  { { "Secrets of Azeroth guide", WS.."secrets-of-azeroth-world-event" } },
[[Where: Secrets of Azeroth event areas. Group needed for the parts.

1. First Booster Part: Cape of Stranglethorn (59.4, 79.0) - with 2 friends, light the 3 Jaguero Braziers with the Torch of Pyrreth to summon Enigma Ward; it drops the part.
2. Second Booster Part: Feralas (50.6, 26.0) - a group of 4; one player controls the Water Elemental and sucks up the others, it explodes, then loot the part.
3. Third Booster Part: Blasted Lands, on the Dark Portal steps (54.8, 52.1) - long interact; hover on a flying mount to loot safely.
4. Go to the Empowered Forge (36.68, 61.85) and click a Booster Part to assemble Mimiron's Jumpjets.]])

G({ "Thrayir, Eyes of the Siren" }, "Record of the Siren's Song",
  { { "warcraft-secrets guide", WS.."thrayir-eyes-of-the-siren" } },
[[Where: Siren Isle (The War Within). Collect 5 runekeys.

1. Use the Singing Tablet on Siren Isle to enter the Forgotten Vault (Thrayir is in stasis here).
2. Cyclonic Runekey: low-chance drop from the rare Zek'ul the Shipbreaker.
3. Turbulent Runekey: combine 3 Turbulent Fragments found across the isle (dirt piles, etc.).
4. Whirling Runekey: drops from Ksvir the Forgotten in the southern room of the Vault.
5. Torrential Runekey: 7 Torrential Fragments from Brinebound Wraiths / Kvaldir (north).
6. Thunderous Runekey: 5 Thunderous Fragments from Rune Storm Caches (finish "A Song of Secrets" first for the Runecaster's Eye).
7. With all 5 runekeys, break the seal to claim Thrayir.]])

G({ "Crimson Tidestallion" }, "Record of Grggly Stash",
  { { "warcraft-secrets guide", WS.."mrrls-secret-stash" } },
[[Where: Nazjatar (BfA), from the secret vendor Mrrl. Daily-gated.

1. Rescue Mrrl from Dragon's Teeth Basin (48.1, 45.3) and complete the Nazjatar story to unlock him.
2. Get the Azsh'ari Stormsurger Cape: buy Benthic Cloaks (5 Prismatic Manapearl each) until one becomes the cape - you must WEAR it to see the mount on Mrrl.
3. Via the murloc trading game (vendors Mrrglrlr, Grrmrlg, Flrgrrl, Hurlgrl) collect 4 Cultist Pinky Finger + 2 Pulsating Blood Stone (these expire in 24h - only get them when the mount is actually for sale).
4. Complete Murloco's event (cave ~46.3, 32.6, cape equipped) to buy the Hungry Herald's Tentacle Taco.
5. When the Crimson Tidestallion appears on Mrrl (rotates daily), buy it with 4 fingers + 2 stones + 1 taco.]])

G({ "Sinrunner Blanchy", "Blanchy's Reins" }, "Record of a Bad Horse",
  { { "warcraft-secrets guide", WS.."sinrunner-blanchy" } },
[[Where: Revendreth (Shadowlands). 6 steps, one per day.

1. Find Dead Blanchy on the river in Endmire, Revendreth (1-2h respawn, up ~5 min; use Group Finder to realm-hop).
2. Day 1: feed 8 Handful of Oats from Saldean's Farm, Westfall.
3. Day 2: bring the Grooming Brush from Snickersnee in Darkhaven.
4. Day 3: bring 4 Sturdy Horseshoes from Discarded Horseshoes on Darkhaven roads.
5. Day 4: fill the Empty Water Bucket (from near Snickersnee) at a water source in Bastion/Ardenweald and deliver.
6. Day 5: buy the Comfortable Saddle Blanket from Ta'tru (south Revendreth).
7. Day 6: bring 3 Dredhollow Apples from Mims (Hole in the Wall) to get Blanchy's Reins. One step per day; missing a day only delays you - no penalty.]])

G({ "The Hivemind" }, "Record of the Hivemind",
  { { "warcraft-secrets guide", WS.."the-hivemind" } },
[[Where: across Azeroth, then group puzzles in Suramar / Court of Stars. 5-player secret.

1. Solo: buy the Talisman of True Treasure Tracking from Griftah (Shattrath) and earn 4 colored monocles (Red - Vashj'ir, Blue - anagram, Green - Skyreach, Yellow - Halls of Origination).
2. Group of 5: in Suramar, equip monocles matching each Wild Withered's color and bring all four to 1 HP at once; a 5th player grabs the Lost Cat Toy and notes the damage taken.
3. Court of Stars: pet 5 Mana Kittens to stack purrs matching that damage number, then click the Ominous Orb.
4. Cross the phaseshifting platforms together (players activate platforms for each other).
5. Solve the Lightlocked river-crossing logic puzzle (1 driver, 2 adults, 2 children).
6. All 5 stand in the final room's purple spots and channel together to get The Hivemind.]])

G({ "Lucid Nightmare" }, "Record of the Endless Nightmare",
  { { "warcraft-secrets guide", WS.."lucid-nightmare" } },
[[Where: a chain of 7 puzzles across the world. Soloable but long.

1. Dalaran clue (Curiosities & Moore) -> Ulduar Scrapyard: pull the Rusty Lever and draw the gear pattern on the Scrapyard Lights grid.
2. AQ40: at the Mind Larva past C'thun, win the Mindcraft "connect 5 brains" game.
3. Deepholm: get a Shadoweave Mask, enter the Dark Fissure, equip the mask and click the Strange Skull.
4. Gnomeregan Engineering Labs: enter 1222176597 across the ten Numeric Consoles.
5. Val'sharah: at the Nightmare Tumor, uncross Il'gynoth's optic nerves (Eyecraft).
6. Kun-Lai (Tomb of Secrets): in the 8x8 Endless Halls maze, place 5 colored orbs on matching runes.
7. Karazhan's Forgotten Crypts: loot the Lucid Nightmare from the chest in the Pit of Criminals.]])

G({ "Voidfire Deathcycle", "Felreaver Deathcycle" }, "Record of Visions of Void",
  { { "Warcraft Wiki", "https://warcraft.wiki.gg/wiki/Felreaver_Deathcycle" } },
[[Where: Revisited Horrific Visions (Stormwind / Orgrimmar).

1. Enter the Vision of Stormwind with at least 1 mask; in the Dwarven District, attack the Voidfire Deathcycle to start the fight with Haymar the Devout.
2. Defeat Haymar; interact with the downed cycle to send it to Dornogal.
3. Speak to the Deathcycle in Dornogal - it lists 6 missing components.
4. Gather the 6 components from Visions of Stormwind and Orgrimmar, then rebuild it to learn the Voidfire Deathcycle.]])

G({ "Incognitro, the Indecipherable Felcycle", "Incognitro" }, "Record of Indecipherable Mo'arg Technology",
  { { "warcraft-secrets guide", WS.."incognitro-the-indecipherable-felcycle" } },
[[The most involved secret - many sub-puzzles. High-level outline:

1. Prerequisite: earn "Azeroth's Greatest Detective".
2. Get the Torch of Pyrreth and the Peculiar Key, then enter the Karazhan Catacombs scenario.
3. Solve the nine puzzles: Anagram, Old Gods (Vale ritual), Decryption Consoles (9 codes), Doom (Uther's Tomb), Golden Muffin (pet battle vs Jeremy Feasel), Altars of Acquisition, Owl of the Watchers (Azsuna), Enigma Machine, Cryptic Plaque.
4. Optional extensions: Oddsight Focus, Radiant Singer, Dusk Lily.
5. Assemble the Keys to Incognitro to unlock the Felcycle.

This one is huge - follow a full written walkthrough step by step.]])

G({ "Mind-Seeker" }, "Trophy of Revelations",
  { { "warcraft-secrets guide", WS.."mind-seeker" } },
[[This is the reward itself - the title and the Mind-Seeker.

1. Solve at least 17 of the secrets in this list.
2. Travel to the alternate Seat of Knowledge in the Vale of Eternal Blossoms.
3. Speak with Anakron and choose "I am ready" to join the cabal and earn the Mind-Seeker.]])

-- ----- Battle Pets ---------------------------------------------------------

G({ "Phoenix Wishwing" }, "Record of Rising Ashes",
  { { "warcraft-secrets guide", WS.."phoenix-wishwing" } },
[[Type: Battle Pet.

1. Build the Phoenix Ash Talisman: 1 Glittering Phoenix Ember from Alysrazor (Firelands, Cataclysm Timewalking); 20 Inert Phoenix Ash (Scorching Elementals / Living Blaze in Un'Goro); 10 Sacred Phoenix Ash from "Small Pile of Ash" cooking pots in Spires of Arak.
2. Trade them to Zektar in Spires of Arak (52.1, 50.5) for the Phoenix Ash Talisman.
3. Farm 15 Smoldering Phoenix Ash from phoenixes in Neltharus (clear to Chargath, reset, repeat).
4. Buy the Ash Feather Amulet from Griftah in the Waking Shores; use it to spawn and collect 20 Ash Feathers on the platform above the Obsidian Throne.
5. Turn everything in to Tarjin the Blind in the Waking Shores (16.2, 62.6) to finish "Tale of the Phoenix" and get the Phoenix Wishwing.]])

G({ "Sun Darter Hatchling" }, "Record of the Cavern of Consumption",
  { { "warcraft-secrets guide", WS.."sun-darter-hatchling" } },
[[Where: Caverns of Consumption, Winterspring (57.2, 13.9). Bring a bag of consumables.

1. Elemental Gates: drink a Major Fire Protection Potion, then the other five Major Protection Potions (Arcane, Frost, Holy, Nature, Shadow).
2. Diligent Watcher: drink Noggenfogger Elixirs until you turn into a skeleton to slip past the gargoyle.
3. Wall of Vines: use Scotty's Lucky Coin to become a sprite; loot the Water Stone from the pool.
4. Water Barrier: use the Water Stone to pass.
5. Stone Watcher: drink Dire Brew to become an Iron Dwarf and pass the golem.
6. Wisdom Cube: drink ~20 Pygmy Oil (gnome-sized), summon Perky Pug, equip the "Little Princess" Costume, click the cube for "Sign of the First".
7. Strange Stone: drink Ethereal Oil, equip the Gordok Ogre Suit + Winterfall Firewater, click the stone for "Sign of the Second".
8. With both buffs, go downstairs, read the Tarnished Plaque, remove Winterfall Firewater, use a Scroll of Intellect, then loot the Oddly-Colored Egg (Sun Darter Hatchling).]])

G({ "Courage" }, "Record of Collective Courage",
  { { "warcraft-secrets guide", WS.."courage" } },
[[Where: Nemea's Retreat, Bastion. Group secret (about 5 players).

1. Gather ~5 players and spread out to the 9 Larion Cub locations around Nemea's Retreat.
2. On a countdown, interact with at least 5 Larion Cubs within 10 seconds.
3. Courage spawns briefly near Nemea - interact with him within 30 seconds to get the pet.]])

G({ "Uuna", "Uuna's Doll" }, "Record of a Friend in the Darkness",
  { { "warcraft-secrets guide", WS.."uuna" } },
[[Where: starts on Argus (Antoran Wastes), then a long world-tour questline.

1. In Antoran Wastes gather: Call of the Devourer (mobs at Scavenger's Boneyard 52,38), Ur'zul Bone (50.4, 56.1), Imp Bone (cave 65.9, 19.4), Fiend Bone (52.4, 35.3).
2. Click the Bone Effigy (54.8, 39.2) with all four items to summon and kill The Many-Faced Devourer; loot Uuna's Doll.
3. Summon Uuna and complete her 12-step questline: bond with emotes (whistle/roar/cry), visit A'dal in Shattrath, Lake Falathim (Ashenvale), Nuu in Eredath, Blood Watch (Bloodmyst), Shadowmoon Valley (Draenor).
4. Finish the "Dark Place" steps (die, talk to the Spirit Healer, find the Shadow Tear in Dragonblight, cheer, place a cooking fire, survive 3 min, hug Uuna), then complete the 8-stop World Tour to earn the Uuna pet.]])

G({ "Baa'l", "Baa'ls Darksign", "Baa'l's Darksign" }, "Record of Ominously Ordinary Pebbles",
  { { "warcraft-secrets guide", WS.."baal" } },
[[Where: BfA zones + Frostfire Ridge. Requires Uuna's storyline finished (yours or a friend's).

1. Grab the Conspicuous Note at the Heart of Darkness temple in Nazmir (51.8, 59.1).
2. Collect 13 Pebbles hidden in caves across BfA zones (Broken Shore, Boralus, Zuldazar, Drustvar, Vol'dun, Stormsong, Tiragarde, underwater caves - use a coordinate guide).
3. Rearrange the capitalized letters on the pebbles (anagram) - they spell "Kurgthuk the Merciless" / "Get Back to Work".
4. Go to the volcano in Frostfire Ridge, Draenor (62.2, 22.8).
5. Summon Uuna (to weaken it), then summon and defeat Baa'l to get Baa'ls Darksign; use it to learn the Baa'l pet. (Baa'l is the prerequisite for Waist of Time.)]])

G({ "Jenafur" }, "Record of Karazhan's Kitten",
  { { "warcraft-secrets guide", WS.."jenafur" } },
[[Where: starts in Ashenvale/Elwynn, finishes in Return to Karazhan. Soloable.

1. Talk to Amara Lunastar in Ashenvale (17.4, 49.3) about her missing cat.
2. Go to Donni Anthania's house in Elwynn Forest (44.2, 53.1) and click the Empty Dish.
3. In Return to Karazhan, collect from the Banquet Hall / Guest Chambers: 2 Juicy Drumsticks, 2 Marbled Steaks, 2 Fishy Bits, 1 Meaty Morsel, 1 Slathered Rib (items vanish after ~5 min - be quick).
4. In the Opera Hall, place the 8 food items on the floor tiles in the musical-staff pattern (see a guide image).
5. When "Amara's Wish" plays, interact with Jenafur to get the pet.]])

G({ "Glimr", "Glimr's Cracked Egg" }, "Record of Glimmering Hope",
  { { "warcraft-secrets guide", WS.."glimr" } },
[[Where: Northrend (Borean Tundra / Grizzly Hills). A short murloc questline.

1. Scare the Glimmerfin Scout off its iceberg in Grizzly Hills (18.4, 88.2) and pick up the Glimmerfin Scale.
2. Take it to King Mrgl-Mrgl in Borean Tundra (43.5, 13.9), then return to Glimmergut in Grizzly Hills (17.8, 93.2).
3. Work through the murloc quests: 10 Meaty Crab Chunk, the Horker's Pile of Blubberfat (10.3, 85.1), the Giant Pearl (22.3, 93.0; needs an aquatic mount), a Trainer's Test pet battle, and 3 seaweed stalks.
4. Defeat the elite Great Mua'kin (8.8, 91.1) and return to the Glimmerfin Oracle for Glimr's Cracked Egg (the Glimr pet).]])

G({ "Wicker Pup", "Spooky Bundle of Sticks" }, "Record of Drust Rituals",
  { { "warcraft-secrets guide", WS.."wicker-pup" } },
[[Where: Drustvar (BfA). Quick and easy.

1. Collect 4 hidden parts in Drustvar:
   - Bundle of Wicker Sticks (18.5, 51.4)
   - Miniature Stag Skull (67.8, 73.7)
   - Wolf Pup Spine (25.4, 24.1)
   - Spooky Incantation (55.5, 51.8)
2. Click any one of the parts in your bags to combine them into the Spooky Bundle of Sticks, which teaches the Wicker Pup pet.]])

G({ "Tobias", "Tobias' Leash" }, "Record of Rumors",
  { { "Secrets of Azeroth guide", WS.."secrets-of-azeroth-world-event" } },
[[Type: Battle Pet. From the Secrets of Azeroth world event.

1. Make sure the Torch of Pyrreth is out so you can see Loose Dirt Mounds.
2. Find 10 of the 17 Buried Satchels in dirt mounds around the world (use community rumor coordinates).
3. This earns the Community Rumor Mill achievement and the Tobias pet. Satchels can be found in any order.]])

-- ----- Other (toys / transmog / achievement / manual) ----------------------

G({ "Enlightened Hearthstone" }, "Record of Collaborative Cogitation",
  { { "warcraft-secrets guide", WS.."enlightened-hearthstone" } },
[[Where: Zereth Mortis. Group secret (6 players).

1. Each of the 6 players must have the Sphere of Enlightened Cogitation.
2. All six stand on the hexagon pillars surrounding the central pool in Zereth Mortis.
3. Use the Sphere at the same time to unlock the Enlightened Hearthstone toy for everyone.]])

G({ "Black Dragon's Challenge Dummy" }, "Record of Lost Obsidian Treasures",
  { { "Warcraft Wiki", "https://warcraft.wiki.gg/wiki/Black_Dragon%27s_Challenge_Dummy" } },
[[Where: Obsidian Citadel area, Dragon Isles.

1. Obtain the Lost Cache Key (from the Lost Obsidian Treasures chain - follow the Blacktalon / Sour Apple clues).
2. Use it to open the Lost Obsidian Cache and loot the Black Dragon's Challenge Dummy toy.]])

G({ "Waist of Time" }, "Record of Time Waisted",
  { { "warcraft-secrets guide", WS.."waist-of-time" } },
[[Where: Arathi Highlands. Requires Baa'l first.

1. After obtaining Baa'l, start the Waist of Time chain: solve the anagram and perform the required emotes/steps around Azeroth.
2. Finish at the unnamed dwarven farm in Arathi Highlands and loot the Waist of Time belt from Grimmy's Rusty Lockbox.]])

G({ "Memory of Scholomance" }, "Record of Necromantic Knowledge",
  { { "warcraft-secrets guide", WS.."memory-of-scholomance" } },
[[Where: Scholomance (Caer Darrow, Western Plaguelands).

1. Get Krastinov's Bag of Horrors - drops from the rare Doctor Theolen Krastinov in Heroic Scholomance.
2. Use the bag to perform the ritual that reopens the old (pre-revamp) Scholomance, earning the Memory of Scholomance achievement.]])

G({ "Wan'be's Buried Goods" }, "Record of Buried Treasure",
  { { "warcraft-secrets guide", WS.."treasure-hunt-wanbes-buried-goods" } },
[[Where: Zuldazar (a treasure hunt). No collection API - tick this manually when done.

1. Follow the clue trail around Zuldazar.
2. Dig up Wan'be's Buried Goods at the final spot.]])

G({ "Doug Roberts, Enigmatic Explorer", "Doug Roberts" }, "Record of Doug Roberts, Enigmatic Explorer",
  { { "warcraft-secrets guide", WS.."mind-seeker" } },
[[An easter egg, not a required secret.

1. In the Sanctuary of the Mind-Seekers, look behind the westernmost pillar to find Doug Roberts, Enigmatic Explorer.
2. Say hello, then tick this box manually.]])
