
# Simple Engine Game-play

A simple, playable example that can be scrapped out I think will present the
kind of playable experience you might expect.  This will also provide some early
abstractions and help uncover unforeseen problems in an basic end-to-end demo.

## Game-play Breakdown

### Joining the Game

Players can join an "unstarted" game.  This simple demo engine doesn't currently
have any plans for allowing player starting selection and instead limits users
to a max of six players per game.  Each player is placed in one of the corners
of the board; since this is a hexagon that is where max players of six comes
from.

### High Level Mechanics

Players can issue commands and issue query requests against the game to progress
their reach and observe what other players are doing.

### Unit and Structure Overview

  * **Village** :
    * Limit: one per location
    * Description: Responsible for producing villagers when requested at the
        rate of 1 villager every 4 `ticks`.  A village starts with 10 villagers
        and 20 food and can store up to 50 of each resource.  It passively
        produces up to two food per tick, per villager up to a max of 20
        food per tick.

  * **Villager** :
    * Limit: 1 per food per `tick` in a location
    * Description: Overall workforce and population.  Villagers are assigned to
        harvest needed resources and trained to become experts in other areas.
        They may harvest one of any resource per `tick`.

  * **Farm** :
    * Limit: 5 per location
    * Description: Villagers can be assigned to work on a farm.  While assigned
        to a farm they can harvest food at a rate of five per `tick`.  A maximum
        of 20 villagers may be assigned to a single farm.  Each farm increases
        the amount of food that can be stored on a location by 100.  The cost to
        create a farm is 20 food, 30 lumber, 30 stone, and 30 ore with 5
        villagers over the course of 10 `ticks`.

  * **Lumber Yard** :
    * Limit: 2 per location
    * Description: Villagers can be assigned to the lumberyard with a limit of
        10 villagers max per yard.  While assigned each villager produces lumber
        at a rate of five per `tick`.  Any non-assigned villagers harvesting
        lumber have an increased rate of an additional  1 lumber per `tick` with
        a max of five villagers for every villager assigned to the lumberyard.
        Each lumberyard increases the amount of lumber that can be stored on a
        location by 250.  The cost to create a yard is 100 food, 50 lumber, 25
        ore.

  * **Stone Quarry** :
    * Limit: 1 per location
    * Description: Villagers can be assigned to the quarry with a limit of 10
        per level of the quarry.  Each villager assigned produces stone at the
        rate of 3 stone per `tick`. Each level of the quarry increases the
        amount of stone that can be stored by this location by 200 per level.
        The cost for the quarry is as follows:
      1. Level 1 - 10 villagers at 10 `ticks`, 200 food, 250 lumber
      2. Level 2 - 10 villagers at 15 `ticks`, 300 food, 300 lumber, 100 ore
      2. Level 3 - 15 villagers at 15 `ticks`, 300 food, 300 lumber, 200 ore

  * **Ore Mine** :
    * Limit: 2 per location
    * Description: Villagers can be assigned to the mines with no set limit;
        however there is a cost of 1 additional food, 2 lumber, and 2 stone per
        `tick` per villager.  Each villager assigned produces 5 ore per `tick`.
        The amount of ore that can be stored increases by 200 per mine, per
        location.  The cost to create a mine is 20 villagers 20 `ticks` with 300
        food, 300 lumber, and 300 stone.
