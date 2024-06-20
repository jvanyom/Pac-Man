Understanding Pac-Man Ghost Behavior  
======================================================================================================

About the Game
--------------

> "All the computer games available at the time were of the violent type - war games and space invader types. There were no games that everyone could enjoy, and especially none for women. I wanted to come up with a "comical" game women could enjoy."
> 
> \- Toru Iwatani, Pac-Man creator

Pac-Man is one of the most iconic video games of all time, and most people (even non-gamers) have at least a passing familiarity with it. The purpose of the game is very simple — the player is placed in a maze filled with food (depicted as pellets or dots) and needs to eat all of it to advance to the next level. This task is made difficult by four ghosts that pursue Pac-Man through the maze. If Pac-Man makes contact with any of the ghosts, the player loses a life and the positions of Pac-Man and the ghosts are reset back to their starting locations, though any dots that were eaten remain so. Other than simply avoiding them, Pac-Man's only defense against the ghosts are the four larger "energizer" pellets located at the corners of the maze. Eating one causes the ghosts to become frightened and retreat for a short time, and in the early levels of the game Pac-Man can even eat the ghosts for bonus points during this period. An eaten ghost is not completely eliminated, but is returned to its starting position before resuming its pursuit. Other than eating dots and ghosts, the only other source of points are the two pieces of fruit which appear during each level near the middle of the maze. The first fruit appears when Pac-Man has eaten 70 of the dots in the maze, and the second when 170 have been eaten.

![Initial playfield layout](https://media.gameinternals.com/pacman-ghosts/initial-playfield.png)

Every level of Pac-Man uses the same maze layout, containing 240 regular "food" dots and 4 energizers. The tunnels that lead off of the left and right edges of the screen act as shortcuts to the opposite side of the screen, and are usable by both Pac-Man and the ghosts, though the ghosts' speed is greatly reduced while they are in the tunnel. Even though the layout is always the same, the levels become increasingly difficult due to modifications to Pac-Man's speed, as well as changes to both the speed and behavior of the ghosts. After reaching level 21, no further changes to the game's mechanics are made, and every level from 21 onwards is effectively identical.

Common Elements of Ghost Behaviour
----------------------------------

> "Well, there's not much entertainment in a game of eating, so we decided to create enemies to inject a little excitement and tension. The player had to fight the enemies to get the food. And each of the enemies has its own character. The enemies are four little ghost-shaped monsters, each of them a different colour - blue, yellow, pink and red. I used four different colours mostly to please the women who play - I thought they would like the pretty colours."
> 
> \- Toru Iwatani, Pac-Man creator

Each of the ghosts is programmed with an individual "personality", a different algorithm it uses to determine its method of moving through the maze. Understanding how each ghost behaves is extremely important to be able to effectively avoid them. However, before discussing their individual behaviors, let's first examine the logic that they share.

### The Ghost House

When a player begins a game of Pac-Man, they are not immediately attacked by all four of the ghosts. As shown on the diagram of the initial game position, only one ghost begins in the actual maze, while the others are inside a small area in the middle of the maze, often referred to as the "ghost house". Other than at the beginning of a level, the ghosts will only return to this area if they are eaten by an energized Pac-Man, or as a result of their positions being reset when Pac-Man dies. The ghost house is otherwise inaccessible, and is not a valid area for Pac-Man or the ghosts to move into. Ghosts always move to the left as soon as they leave the ghost house, but they may reverse direction almost immediately due to an effect that will be described later.

The conditions that determine when the three ghosts that start inside the ghost house are able to leave it are actually fairly complex. Because of this, I'm going to consider them outside the scope of this article, especially since they become much less relevant after completing the first few levels. If you're interested in reading about these rules (and an interesting exploit of them), the Pac-Man Dossier [covers them in-depth (under the "Home Sweet Home" heading)](https://www.gamasutra.com/view/feature/132330/the_pacman_dossier.php?page=4), as always.

### Target Tiles

![Playfield split into tiles](https://media.gameinternals.com/pacman-ghosts/tiled-playfield.png)

Much of Pac-Man's design and mechanics revolve around the idea of the board being split into tiles. "Tile" in this context refers to an 8 x 8 pixel square on the screen. Pac-Man's screen resolution is 224 x 288, so this gives us a total board size of 28 x 36 tiles, though most of these are not accessible to Pac-Man or the ghosts. As an example of the impact of tiles, a ghost is considered to have caught Pac-Man when it occupies the same tile as him. In addition, every pellet in the maze is in the center of its own tile. It should be noted that since the sprites for Pac-Man and the ghosts are larger than one tile in size, they are never completely contained in a single tile. Due to this, for the game's purposes, the character is considered to occupy whichever tile contains its _center point_. This is important knowledge when avoiding ghosts, since Pac-Man will only be caught if a ghost manages to move its center point into the same tile as Pac-Man's.

The key to understanding ghost behavior is the concept of a target tile. The large majority of the time, each ghost has a specific tile that it is trying to reach, and its behavior revolves around trying to get to that tile from its current one. All of the ghosts use identical methods to travel towards their targets, but the different ghost personalities come about due to the individual way each ghost has of selecting its target tile. Note that there are no restrictions that a target tile must actually be possible to reach, they can (and often are) located on an inaccessible tile, and many of the common ghost behaviors are a direct result of this possibility. Target tiles will be discussed in more detail in upcoming sections, but for now just keep in mind that the ghosts are almost always motivated by trying to reach a particular tile.

### Ghost Movement Modes

The ghosts are always in one of three possible modes: Chase, Scatter, or Frightened. The "normal" mode with the ghosts pursuing Pac-Man is Chase, and this is the one that they spend most of their time in. While in Chase mode, all of the ghosts use Pac-Man's position as a factor in selecting their target tile, though it is more significant to some ghosts than others. In Scatter mode, each ghost has a fixed target tile, each of which is located just outside a different corner of the maze. This causes the four ghosts to disperse to the corners whenever they are in this mode. Frightened mode is unique because the ghosts do not have a specific target tile while in this mode. Instead, they [pseudorandomly](https://en.wikipedia.org/wiki/Pseudorandom_number_generator) decide which turns to make at every intersection. A ghost in Frightened mode also turns dark blue, moves much more slowly and can be eaten by Pac-Man. However, the duration of Frightened mode is shortened as the player progresses through the levels, and is completely eliminated from level 19 onwards.

> "To give the game some tension, I wanted the monsters to surround Pac Man at some stage of the game. But I felt it would be too stressful for a human being like Pac Man to be continually surrounded and hunted down. So I created the monsters' invasions to come in waves. They'd attack and then they'd retreat. As time went by they would regroup, attack, and disperse again. It seemed more natural than having constant attack."
> 
> \- Toru Iwatani, Pac-Man creator

Changes between Chase and Scatter modes occur on a fixed timer, which causes the "wave" effect described by Iwatani. This timer is reset at the beginning of each level and whenever a life is lost. The timer is also paused while the ghosts are in Frightened mode, which occurs whenever Pac-Man eats an energizer. When Frightened mode ends, the ghosts return to their previous mode, and the timer resumes where it left off. The ghosts start out in Scatter mode, and there are four waves of Scatter/Chase alternation defined, after which the ghosts will remain in Chase mode indefinitely (until the timer is reset). For the first level, the durations of these phases are:

1.  Scatter for 7 seconds, then Chase for 20 seconds.
2.  Scatter for 7 seconds, then Chase for 20 seconds.
3.  Scatter for 5 seconds, then Chase for 20 seconds.
4.  Scatter for 5 seconds, then switch to Chase mode permanently.

The durations of these phases are changed somewhat when the player reaches level 2, and once again when they reach level 5. Starting on level 2, the third Chase mode lengthens considerably, to 1033 seconds (17 minutes and 13 seconds), and the following Scatter mode lasts just 1/60 of a second before the ghosts proceed to their permanent Chase mode. The level 5 changes build on top of this, additionally reducing the first two Scatter lengths to 5 seconds, and adding the 4 seconds gained here to the third Chase mode, lengthening it to 1037 seconds (17:17). Regarding the 1/60-of-a-second Scatter mode on every level except the first, even though it may seem that switching modes for such an insignificant amount of time is pointless, there is a reason behind it, which shall be revealed shortly.

### Basic Ghost Movement Rules

The next step is understanding exactly _how_ the ghosts attempt to reach their target tiles. The ghosts' AI is very simple and short-sighted, which makes the complex behavior of the ghosts even more impressive. Ghosts only ever plan one step into the future as they move about the maze. Whenever a ghost enters a new tile, it looks ahead to the next tile that it will reach, and makes a decision about which direction it will turn when it gets there. These decisions have one very important restriction, which is that ghosts may never choose to reverse their direction of travel. That is, a ghost cannot enter a tile from the left side and then decide to reverse direction and move back to the left. The implication of this restriction is that whenever a ghost enters a tile with only two exits, it will always continue in the same direction.

However, there is one exception to this rule, which is that whenever ghosts change from Chase or Scatter to any other mode, they are _forced_ to reverse direction as soon as they enter the next tile. This forced instruction will overwrite whatever decision the ghosts had previously made about the direction to move when they reach that tile. This effectively acts as a notifier to the player that the ghosts have changed modes, since it is the only time a ghost can possibly reverse direction. Note that when the ghosts leave Frightened mode they do not change direction, but this particular switch is already obvious due to the ghosts reverting to their regular colors from the dark blue of Frightened. So then, the 1/60-of-a-second Scatter mode on every level after the first will cause all the ghosts to reverse their direction of travel, even though their target effectively remains the same. This forced direction-reversal instruction is also applied to any ghosts still inside the ghost house, so a ghost that hasn't yet entered the maze by the time the first mode switch occurs will exit the ghost house with a "reverse direction as soon as you can" instruction already pending. This causes them to move left as usual for a very short time, but they will almost immediately reverse direction and go to the right instead.

![Simplified map showing intersection tiles](https://media.gameinternals.com/pacman-ghosts/intersection-map.png)

The diagram above shows a simplified representation of the maze layout. Decisions are only necessary at all when approaching "intersection" tiles, which are indicated in green on the diagram.

![A ghost making a decision](https://media.gameinternals.com/pacman-ghosts/decision.png)

When a decision about which direction to turn is necessary, the choice is made based on which tile adjoining the intersection will put the ghost nearest to its target tile, measured in a straight line. The distance from every possibility to the target tile is measured, and whichever tile is closest to the target will be selected. In the diagram to the left, the ghost will turn upwards at the intersection. If two or more potential choices are an equal distance from the target, the decision between them is made in the order of up > left > down. A decision to exit right can never be made in a situation where two tiles are equidistant to the target, since any other option has a higher priority.

![A ghost making the wrong decision](https://media.gameinternals.com/pacman-ghosts/bad-decision.png)

Since the only consideration is which tile will immediately place the ghost closer to its target, this can result in the ghosts selecting the "wrong" turn when the initial choice places them closer, but the overall path is longer. An example is shown to the right, where straight-line measurement makes exiting left appear to be a better choice. However, this will result in an overall path length of 26 tiles to reach the target, when exiting right would have had a path only 8 tiles long.

One final special case to be aware of are the four intersections that were colored yellow on the simplified maze diagram. These specific intersections have an extra restriction — ghosts can not choose to turn upwards from these tiles. If entering them from the right or left side they will always proceed out the opposite side (excepting a forced direction-reversal). Note that this restriction does not apply to Frightened mode, and Frightened ghosts may turn upwards here if that decision occurs randomly. A ghost entering these tiles from the top can also reverse direction back out the top if a mode switch occurs as they are entering the tile, the restriction is only applied during "regular" decision-making. If Pac-Man is being pursued closely by ghosts, he can gain some ground on them by making an upwards turn in one of these intersections, since they will be forced to take a longer route around.

Individual Ghost Personalities
------------------------------

> "This is the heart of the game. I wanted each ghostly enemy to have a specific character and its own particular movements, so they weren't all just chasing after Pac Man in single file, which would have been tiresome and flat."
> 
> \- Toru Iwatani, Pac-Man creator

![The ghosts and their names in English and Japanese](https://media.gameinternals.com/pacman-ghosts/ghost-names.png)

As has been previously mentioned, the only differences between the ghosts are their methods of selecting target tiles in Chase and Scatter modes. The only official description of each ghost's personality comes from the one-word "character" description shown in the game's attract mode. We'll first take a look at how the ghosts behave in Scatter mode, since it's extremely straightforward, and then look at each ghost's approach to targeting in Chase mode.

### Scatter Mode

![The ghosts' Scatter mode targets](https://media.gameinternals.com/pacman-ghosts/scatter-targets.png)

Each ghost has a pre-defined, fixed target tile while in this mode, located just outside the corners of the maze. When Scatter mode begins, each ghost will head towards their "home" corner using their regular path-finding methods. However, since the actual target tiles are inaccessible and the ghosts cannot stop moving or reverse direction, they are forced to continue past the target, but will turn back towards it as soon as possible. This results in each ghost's path eventually becoming a fixed loop in their corner. If left in Scatter mode, each ghost would remain in its loop indefinitely. In practice, the duration of Scatter mode is always quite short, so the ghosts often do not have time to even reach their corner or complete a circuit of their loop before reverting back to Chase mode. The diagram shows each ghost's target tile and eventual looping path, color-coded to match their own color.

### The Red Ghost

![The red ghost's targeting method](https://media.gameinternals.com/pacman-ghosts/blinky-targeting.png)

The red ghost starts outside of the ghost house, and is usually the first one to be seen as a threat, since he makes a beeline for Pac-Man almost immediately. He is referred to as "Blinky", and the game describes his personality as _shadow_. In Japanese, his personality is referred to as 追いかけ, _oikake_, which translates as "pursuer" or "chaser". Both languages' descriptions are accurate, since Blinky's target tile in Chase mode is defined as Pac-Man's current tile. This ensures that Blinky almost always follows directly behind Pac-Man, unless the short-sighted decision-making causes him to take an inefficient path.

Even though Blinky's targeting method is very simple, he does have one idiosyncrasy that the other ghosts do not; at two defined points in each level (based on the number of dots remaining), his speed increases by 5% and his behavior in Scatter mode changes. The timing of the speed change varies based on the level, with the change occurring earlier and earlier as the player progresses. The change to Scatter targeting is perhaps more significant than the speed increases, since it causes Blinky's target tile to remain as Pac-Man's position even while in Scatter mode, instead of his regular fixed tile in the upper-right corner. This effectively keeps Blinky in Chase mode permanently, though he will still be forced to reverse direction as a result of a mode switch. When in this enhanced state, Blinky is generally referred to as "Cruise Elroy", though the origin of this term seems to be unknown. Not even the almighty Pac-Man Dossier has an answer here. If Pac-Man dies while Blinky is in Cruise Elroy mode, he reverts back to normal behavior temporarily, but returns to Elroy mode as soon as all other ghosts have exited the ghost house.

### The Pink Ghost

![The pink ghost's targeting method](https://media.gameinternals.com/pacman-ghosts/pinky-targeting.png) ![The pink ghost's targeting error when Pac-Man faces upwards](https://media.gameinternals.com/pacman-ghosts/pinky-targeting2.png)

The pink ghost starts inside the ghost house, but always exits immediately, even in the first level. His nickname is "Pinky", and his personality is described as _speedy_. This is a considerable departure from his Japanese personality description, which is 待ち伏せ, _machibuse_, which translates as "ambusher". The Japanese version is much more appropriate, since Pinky does not move faster than any of the other ghosts (and slower than Blinky in Cruise Elroy mode), but his targeting scheme attempts to move him to the place where Pac-Man is going, instead of where he currently is. Pinky's target tile in Chase mode is determined by looking at Pac-Man's current position and orientation, and selecting the location four tiles straight ahead of Pac-Man. At least, this was the intention, and it works when Pac-Man is facing to the left, down, or right, but when Pac-Man is facing upwards, an [overflow error](https://en.wikipedia.org/wiki/Integer_overflow) in the game's code causes Pinky's target tile to actually be set as four tiles ahead of Pac-Man _and_ four tiles to the left of him. I don't want to frighten off non-programmers, but if you're interested in the technical details behind this bug, [Don Hodges has written a great explanation](http://donhodges.com/pacman_pinky_explanation.htm), including the actual assembly code for Pinky's targeting, as well as a fixed version.

![Causing the pink ghost's target tile to be behind him](https://media.gameinternals.com/pacman-ghosts/pinky-chicken.png)

One important implication of Pinky's targeting method is that Pac-Man can often win a game of "chicken" with him. Since his target tile is set four tiles in front of Pac-Man, if Pac-Man heads directly towards him, Pinky's target tile will actually be _behind_ himself once they are less than four tiles apart. This will cause Pinky to choose to take any available turn-off in order to loop back around to his target. Because of this, it is a common strategy to momentarily "fake" back towards Pinky if he starts following closely. This will often send him off in an entirely different direction.

### The Blue Ghost

![The blue ghost's targeting method](https://media.gameinternals.com/pacman-ghosts/inky-targeting.png)

The blue ghost is nicknamed Inky, and remains inside the ghost house for a short time on the first level, not joining the chase until Pac-Man has managed to consume at least 30 of the dots. His English personality description is _bashful_, while in Japanese he is referred to as 気紛れ, _kimagure_, or "whimsical". Inky is difficult to predict, because he is the only one of the ghosts that uses a factor other than Pac-Man's position/orientation when determining his target tile. Inky actually uses both Pac-Man's position/facing as well as Blinky's (the red ghost's) position in his calculation. To locate Inky's target, we first start by selecting the position two tiles in front of Pac-Man in his current direction of travel, similar to Pinky's targeting method. From there, imagine drawing a vector from Blinky's position to this tile, and then doubling the length of the vector. The tile that this new, extended vector ends on will be Inky's actual target.

As a result, Inky's target can vary wildly when Blinky is not near Pac-Man, but if Blinky is in close pursuit, Inky generally will be as well. Note that Inky's "two tiles in front of Pac-Man" calculation suffers from exactly the same overflow error as Pinky's four-tile equivalent, so if Pac-Man is heading upwards, the endpoint of the initial vector from Blinky (before doubling) will actually be two tiles up and two tiles left of Pac-Man.

### The Orange Ghost

![The orange ghost's distant targeting method](https://media.gameinternals.com/pacman-ghosts/clyde-targeting2.png) ![The orange ghost's nearby targeting method](https://media.gameinternals.com/pacman-ghosts/clyde-targeting.png)

The orange ghost, "Clyde", is the last to leave the ghost house, and does not exit at all in the first level until over a third of the dots have been eaten. Clyde's English personality description is _pokey_, whereas the Japanese description is お惚け, _otoboke_ or "feigning ignorance". As is typical, the Japanese version is more accurate, since Clyde's targeting method can give the impression that he is just "doing his own thing", without concerning himself with Pac-Man at all. The unique feature of Clyde's targeting is that it has two separate modes which he constantly switches back and forth between, based on his proximity to Pac-Man. Whenever Clyde needs to determine his target tile, he first calculates his distance from Pac-Man. If he is _farther_ than eight tiles away, his targeting is identical to Blinky's, using Pac-Man's current tile as his target. However, as soon as his distance to Pac-Man becomes _less_ than eight tiles, Clyde's target is set to the same tile as his fixed one in Scatter mode, just outside the bottom-left corner of the maze.

![The orange ghost's targeting mode switching](https://media.gameinternals.com/pacman-ghosts/clyde-targeting3.png)

The combination of these two methods has the overall effect of Clyde alternating between coming directly towards Pac-Man, and then changing his mind and heading back to his corner whenever he gets too close. On the diagram above, the X marks on the path represent the points where Clyde's mode switches. If Pac-Man somehow managed to remain stationary in that position, Clyde would indefinitely loop around that T-shaped area. As long as the player is not in the lower-left corner of the maze, Clyde can be avoided completely by simply ensuring that you do not block his "escape route" back to his corner. While Pac-Man is within eight tiles of the lower-left corner, Clyde's path will end up in exactly the same loop as he would eventually maintain in Scatter mode.

Wrapping Up
-----------

If you've made it this far, you should now have a fairly complete understanding of the logic behind Pac-Man's ghost movement. Understanding the ghosts' behavior is probably the single most important step towards becoming a skilled Pac-Man player, and even a general idea of where they are likely to move next should greatly improve your abilities. I've never been good at Pac-Man, but while I was researching this article and testing a few things, I found that I was able to avoid the ghosts much more easily than before. Even small things make a huge difference, such as recognizing a switch to Scatter mode and knowing that you have a few seconds where the ghosts won't (deliberately) try to kill you.

Pac-Man is an amazing example of seemingly-complex behavior arising from only a few cleverly-designed rules, with the result being a deep and challenging game that players still strive to master, 30 years after its release.

Sources
-------

*   [The Pac-Man Dossier](https://www.gamasutra.com/view/feature/132330/the_pacman_dossier.php), Jamey Pittman - practically the only source you need for anything related to Pac-Man. I did some original research to confirm a few statements here and there, but honestly, most of this article is just rearranged and reworded from Jamey's amazing work on the Dossier. Highly recommended reading if you enjoyed this article and would like to learn about the other aspects of the game.
*   [Pac-Man's Ghost Behaviour Analyzed and Fixed](http://donhodges.com/pacman_pinky_explanation.htm), Don Hodges - explanation of Pinky and Inky's targeting bug and some of the relevant Z80 assembly code.
*   All Toru Iwatani quotes come from an interview in _Programmers at Work_ by Susan M. Lammers. [The entire interview is available online here](https://programmersatwork.wordpress.com/toru-iwatani-1986-pacman-designer/).
