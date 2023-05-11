; define the species
breed [fishesA fishA]
breed [fishesB fishB]
breed [linesA lineA]
breed [linesB lineB]
fishesA-own [energy]
fishesB-own [energy]
globals [a] ;<- what the hell is this?

to setup
  clear-all
  if depth [ depthDraw ]
  set-default-shape fishesA "fish 2"
  if UseFishA [
    create-fishesA fishA_number [
      set color red
      set size 1
      setxy random-xcor random-ycor
      set energy random 6  ;start with a random amt. of energy
  ] ]
  if UseFishB [
    set-default-shape fishesB "fish 3"
    create-fishesB fishB_number [
      set color violet
      set size 2
      setxy random-xcor random-ycor
      set energy random 8  ;start with a random amt. of energy
  ] ]
  grow-seaweed
  reset-ticks
end

to go
  if not any? turtles [ stop ]
  if UseFishA [
    if not any? fishesA [ stop ] ]
  if UseFishB [
    if not any? fishesB [ stop ] ]
  grow-seaweed
  ask turtles [ ; go through all fishes concurrently. don't first go though all fishA, then fishB, because then the early bird (fishA) gets all the worms (seaseaweed)
    (ifelse
      is-fishA? self [
        if depth [
          depth_fishesA
        ]
        move_fishesA
        eat-seaweed
        reproduce_fishesA
        death
        check_energyA
      ]
      is-fishB? self [
        if depth [
          depth_fishesB
        ]
        move_fishesB
        eat-seaweed
        reproduce_fishesB
        death
        check_energyB
      ]
    )
  ]
  tick
end

;; grow seaweed randomly. One could consider a more logistic growth approach, in which seaseaweed gives rise to more seaseaweed
to grow-seaweed
  ask patches [
    if pcolor = black and pycor != fishesA_min_depth and pycor != fishesB_max_depth and pycor != fishesA_max_depth and pycor != fishesB_min_depth [
      if depth_seaweed and random-float 100 * ( abs pycor * depth_intensity ) < seaweed-growth-rate
        [ set pcolor green ]
      if not depth_seaweed and random-float 1000 < seaweed-growth-rate
        [ set pcolor green ]
  ] ]
end

to move_fishesA
  repeat fishesA_moves [
    rt random 50
    lt random 50
    fd 1
  ]
  ;; moving takes some energy
  set energy energy - fishesA_movement_energy
end

to move_fishesB
  repeat fishesB_moves [ ; they move more
    rt random 50
    lt random 50
    fd 1
  ]
  ;; moving takes some energy
  set energy energy - fishesB_movement_energy
end

to check_energyA
  if energy > fishesA_max_energy [ set energy fishesA_max_energy ]
end

to check_energyB
  if energy > fishesA_max_energy [ set energy fishesB_max_energy ]
end

to depth_fishesA
  ask fishesA [if ycor > fishesA_max_depth [set ycor fishesA_min_depth + 1]] ;min
  ask fishesA [if ycor < fishesA_min_depth [set ycor fishesA_max_depth - 1]] ;max
end

to depth_fishesB
  ask fishesB [if ycor > fishesB_max_depth [set ycor fishesB_min_depth + 1]] ;min
  ask fishesB [if ycor < fishesB_min_depth [set ycor fishesB_max_depth - 1]] ;max
end

to depthDraw
  if UseFishA [
    create-linesA 1 [
      set color red
      setxy min-pxcor fishesA_max_depth - 0.5
      set pen-size 2
      pen-down
      while [ xcor < max-pxcor ] [ set xcor xcor + 0.5]
      pen-up
      setxy min-pxcor fishesA_min_depth - 0.5
      pen-down
      while [ xcor < max-pxcor ] [ set xcor xcor + 0.5]
      hide-turtle
  ] ]
  if UseFishB [
    create-linesB 1 [
      set color violet
      setxy min-pxcor fishesB_max_depth
      set pen-size 2
      pen-down
      while [ xcor < max-pxcor ] [ set xcor xcor + 0.5]
      pen-up
      setxy min-pxcor fishesB_min_depth
      pen-down
      while [ xcor < max-pxcor ] [ set xcor xcor + 0.5]
      hide-turtle
  ] ]
end

to eat-seaweed
  ;; gain "seaweed-energy" by eating seaweed
  if pcolor = green
  [ set pcolor black
    set energy energy + seaweed-energy ]
end

to reproduce_fishesA
  ;; give birth to three new fishes, which takes half of energy
  if MatingSeasons and energy > fishesA_birth_threshold and ticks mod fishesA_mating_days = 1
    [ set energy energy * fishesA_birth_efficiency
      hatch fishesA_hatchlings [ fd 2 ] ] ; three fish get born and move a little bit away
  if not MatingSeasons and energy > fishesA_birth_threshold
    [ set energy energy * fishesA_birth_efficiency
      hatch fishesA_hatchlings [ fd 2 ] ] ; three fish get born and move a little bit away
end

to reproduce_fishesB
  ;; give birth to new fish, which takes half of energy
  if MatingSeasons and energy > fishesB_birth_threshold and ticks mod fishesB_mating_days = 1
    [ set energy energy * fishesB_birth_efficiency
      hatch fishesB_hatchlings [ fd 2 ] ] ; one fish gets born and move a little bit away
  if not MatingSeasons and energy > fishesB_birth_threshold
    [ set energy energy * fishesB_birth_efficiency
      hatch fishesB_hatchlings [ fd 2 ] ] ; one fish gets born and move a little bit away
end

to death
  ;; die if you run out of energy
  if energy < 0 [ die ]
end


; modified after 2001 Uri Wilensky.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
1439
15
1890
467
-1
-1
10.805
1
10
1
1
1
0
1
1
1
0
40
-40
0
1
1
1
ticks
30.0

BUTTON
395
47
450
80
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
395
10
450
43
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
71
522
209
555
seaweed-growth-rate
seaweed-growth-rate
0.0
20.0
14.0
1.0
1
NIL
HORIZONTAL

SLIDER
211
522
342
555
seaweed-energy
seaweed-energy
0.0
10.0
4.5
0.5
1
NIL
HORIZONTAL

SLIDER
95
10
232
43
fishA_number
fishA_number
0.0
500.0
250.0
1.0
1
NIL
HORIZONTAL

SLIDER
18
122
220
155
fishesB_birth_threshold
fishesB_birth_threshold
0.0
fishesB_max_energy
100.0
1.0
1
NIL
HORIZONTAL

PLOT
459
11
1418
716
Populations
Time
Population
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"seaweed" 1.0 0 -10899396 true "" "plot count patches with [pcolor = green] / 4"
"fish species A" 1.0 0 -2674135 true "" "plot count fishesA"
"fish species B" 1.0 0 -8630108 true "" "plot count fishesB"

MONITOR
494
39
605
84
count species A
count fishesA
1
1
11

SLIDER
95
45
233
78
fishB_number
fishB_number
0
500
110.0
1
1
NIL
HORIZONTAL

SLIDER
18
88
220
121
fishesA_birth_threshold
fishesA_birth_threshold
0
fishesA_max_energy
30.0
1
1
NIL
HORIZONTAL

MONITOR
608
39
718
84
count species B
count fishesB
17
1
11

SLIDER
235
87
441
120
fishesA_movement_energy
fishesA_movement_energy
0.01
2
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
235
121
441
154
fishesB_movement_energy
fishesB_movement_energy
0.01
2
0.45
0.01
1
NIL
HORIZONTAL

SLIDER
236
270
421
303
fishesA_mating_days
fishesA_mating_days
0
730
240.0
1
1
NIL
HORIZONTAL

SLIDER
236
304
421
337
fishesB_mating_days
fishesB_mating_days
0
730
575.0
1
1
NIL
HORIZONTAL

SLIDER
235
423
407
456
fishesA_max_depth
fishesA_max_depth
fishesA_min_depth
max-pycor
0.0
1
1
NIL
HORIZONTAL

SLIDER
15
425
187
458
fishesB_max_depth
fishesB_max_depth
fishesB_min_depth
max-pycor
-10.0
1
1
NIL
HORIZONTAL

SLIDER
235
456
407
489
fishesA_min_depth
fishesA_min_depth
min-pycor
fishesA_max_depth
-24.0
1
1
NIL
HORIZONTAL

SLIDER
15
457
187
490
fishesB_min_depth
fishesB_min_depth
min-pycor
fishesB_max_depth
-40.0
1
1
NIL
HORIZONTAL

SWITCH
109
375
212
408
depth
depth
1
1
-1000

SWITCH
261
235
400
268
MatingSeasons
MatingSeasons
0
1
-1000

SLIDER
178
158
310
191
fishesA_hatchlings
fishesA_hatchlings
1
3
2.0
1
1
NIL
HORIZONTAL

SLIDER
178
191
310
224
fishesB_hatchlings
fishesB_hatchlings
1
3
1.0
1
1
NIL
HORIZONTAL

SLIDER
318
157
442
190
fishesA_moves
fishesA_moves
1
3
1.0
1
1
NIL
HORIZONTAL

SLIDER
318
191
442
224
fishesB_moves
fishesB_moves
1
3
2.0
1
1
NIL
HORIZONTAL

SLIDER
12
157
169
190
fishesA_birth_efficiency
fishesA_birth_efficiency
0.1
0.9
0.8
0.1
1
NIL
HORIZONTAL

SLIDER
12
190
169
223
fishesB_birth_efficiency
fishesB_birth_efficiency
0.1
0.9
0.2
0.1
1
NIL
HORIZONTAL

SLIDER
238
10
388
43
fishesA_max_energy
fishesA_max_energy
1
200
52.0
1
1
NIL
HORIZONTAL

SLIDER
238
44
389
77
fishesB_max_energy
fishesB_max_energy
1
200
120.0
1
1
NIL
HORIZONTAL

SWITCH
72
556
209
589
depth_seaweed
depth_seaweed
1
1
-1000

TEXTBOX
241
647
391
689
depth_seaweed concentrates more of the seaweed near the top
11
0.0
1

TEXTBOX
228
362
378
418
depth creates boundaries for each fish species that are shown on the world map as coloured lines
11
0.0
1

TEXTBOX
26
302
176
344
matingseasons makes it so that the fish can only reproduce once every x days
11
0.0
1

TEXTBOX
18
243
200
313
hatchlings is how many offspring the fish create\nbirth efficiency is how much of the energy is retained after giving birth
11
0.0
1

SLIDER
70
588
209
621
depth_intensity
depth_intensity
1
2
1.0
0.1
1
NIL
HORIZONTAL

TEXTBOX
73
638
223
694
depth_intensity affects how much of the seaweed grows near the top\nhigher number = less seaweed
11
0.0
1

SWITCH
2
10
92
43
UseFishA
UseFishA
0
1
-1000

SWITCH
1
45
91
78
UseFishB
UseFishB
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

This project explores a simple ecosystem made up of two fish species that feed on sea grass. The fish swim around randomly, and the grass grows at random.   When a fish bumps into some grass, it eats the grass and gains energy. If the fish gains enough energy, it reproduces. If it doesn't gain enough energy, it dies. 

The grass can be adjusted to grow at different rates and give the fish differing amounts of energy.  The two fish species differ in a few particular ways the larger white fish move faster and lose less energy when they move, however, when they reproduce they only have a single offspring. The smaller red fish (species 1) move more slowly and use more energy in movement but they produce three offspring whenever they breed.

## HOW TO USE IT

Click the SETUP button to setup the fish species (red & white), and the grass (green). Click the GO button to start the simulation.

The fish numbers sliders controls the initial number of each fish species. The birth threshold sliders set the energy level at which the two fish species reproduce.  The GRASS-GROWTH-RATE slider controls the rate at which the grass grows. 


## THINGS TO NOTICE

Watch the monitors and populations plot to see how the fish and grass populations change over time. Can changing the sliders alter the outcome of the model? Do the species ever co-exist? Can you change the 'winner' by changing the sliders in any way?

## THINGS TO TRY

Apply changes to adapt the model to your personal question. If you have an idea but can't figure out how to implement the code, do seek support. How do the changes you make in the model alter the dynamics of the model? 

## NETLOGO FEATURES

Notice that every black patch has a random chance of growing grass or
weeds each turn, using the rule:

    if random-float 1000 < grass-grow-rate
      [ set pcolor green ]

## HOW TO CITE

This model is adapated from the rabbits-grass-weeds model in the model library 

You should cite the model below and state that this model and your final model(s) is/are adapted from it.

For the model itself:

* Wilensky, U. (2001).  NetLogo Rabbits Grass Weeds model.  http://ccl.northwestern.edu/netlogo/models/RabbitsGrassWeeds.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Modified by Joanne Lello and Stan Marée after 2001 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

The original model was created as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227.

This modified model was created as part of the Systems Biology Module, School of Biosciences, Cardiff University. 

## Vladditions
The birthing season feature works by allowing the fish to reproduce only for a certain number of days per year (well, 364 days for the sake of allowing the user to evenly split the species into two halves of the year).


<!-- 2001, 2023 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

fish 2
false
0
Polygon -1 true false 56 133 34 127 12 105 21 126 23 146 16 163 10 194 32 177 55 173
Polygon -7500403 true true 156 229 118 242 67 248 37 248 51 222 49 168
Polygon -7500403 true true 30 60 45 75 60 105 50 136 150 53 89 56
Polygon -7500403 true true 50 132 146 52 241 72 268 119 291 147 271 156 291 164 264 208 211 239 148 231 48 177
Circle -1 true false 237 116 30
Circle -16777216 true false 241 127 12
Polygon -1 true false 159 228 160 294 182 281 206 236
Polygon -7500403 true true 102 189 109 203
Polygon -1 true false 215 182 181 192 171 177 169 164 152 142 154 123 170 119 223 163
Line -16777216 false 240 77 162 71
Line -16777216 false 164 71 98 78
Line -16777216 false 96 79 62 105
Line -16777216 false 50 179 88 217
Line -16777216 false 88 217 149 230

fish 3
false
0
Polygon -7500403 true true 137 105 124 83 103 76 77 75 53 104 47 136
Polygon -7500403 true true 226 194 223 229 207 243 178 237 169 203 167 175
Polygon -7500403 true true 137 195 124 217 103 224 77 225 53 196 47 164
Polygon -7500403 true true 40 123 32 109 16 108 0 130 0 151 7 182 23 190 40 179 47 145
Polygon -7500403 true true 45 120 90 105 195 90 275 120 294 152 285 165 293 171 270 195 210 210 150 210 45 180
Circle -1184463 true false 244 128 26
Circle -16777216 true false 248 135 14
Line -16777216 false 48 121 133 96
Line -16777216 false 48 179 133 204
Polygon -7500403 true true 241 106 241 77 217 71 190 75 167 99 182 125
Line -16777216 false 226 102 158 95
Line -16777216 false 171 208 225 205
Polygon -1 true false 252 111 232 103 213 132 210 165 223 193 229 204 247 201 237 170 236 137
Polygon -1 true false 135 98 140 137 135 204 154 210 167 209 170 176 160 156 163 126 171 117 156 96
Polygon -16777216 true false 192 117 171 118 162 126 158 148 160 165 168 175 188 183 211 186 217 185 206 181 172 171 164 156 166 133 174 121
Polygon -1 true false 40 121 46 147 42 163 37 179 56 178 65 159 67 128 59 116

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rabbit
false
0
Circle -7500403 true true 76 150 148
Polygon -7500403 true true 176 164 222 113 238 56 230 0 193 38 176 91
Polygon -7500403 true true 124 164 78 113 62 56 70 0 107 38 124 91

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
