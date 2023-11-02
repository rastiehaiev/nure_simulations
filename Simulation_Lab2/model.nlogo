breed [rabbits rabbit]
rabbits-own [ energy health isMale age ]

to setup
  clear-all
  grow-grass-and-weeds
  set-default-shape rabbits "rabbit"
  create-rabbits number [
    set age 0
    set health 3
    set isMale one-of [ true false ]
    ifelse isMale
      [ set color blue ]
      [ set color pink ]
    setxy random-xcor random-ycor
    set energy random 10  ;start with a random amt. of energy
  ]
  reset-ticks
end

to go
  if not any? rabbits [ stop ]
  grow-grass-and-weeds
  ask rabbits
  [
    move
    eat-grass
    eat-weeds
    reproduce
    death
  ]
  tick
end

to grow-grass-and-weeds
  ask patches [
    if pcolor = black or pcolor = green [
      if random-float 1000 < grass-grow-rate
        [ set pcolor green ]
      if random-float 1000 < weeds-grow-rate
        [ set pcolor violet ]
    ]
  ]
end

to move  ;; rabbit procedure
  set age age + 1
  ifelse health = 3
  [
    if color = yellow
    [
      ifelse isMale
        [ set color blue ]
        [ set color pink ]
    ]
    rt random 50
    lt random 50
    fd 1
    ;; moving takes some energy
    set energy energy - 0.5
  ]
  [
    set health health + 1
  ]
end

to eat-grass  ;; rabbit procedure
  ;; gain "grass-energy" by eating grass
  if pcolor = green
  [
    set pcolor black
    set energy energy + grass-energy
  ]
end

to eat-weeds  ;; rabbit procedure
  ;; gain "weed-energy" by eating weeds
  if pcolor = violet
  [
    ifelse random 3 = 1
    [
      set color yellow
      set health 0
      set pcolor black
    ]
    [
      set pcolor black
      set energy energy + weed-energy
    ]
  ]
end

to reproduce     ;; rabbit procedure
  if energy > birth-threshold and health = 3
  [
    if isMale = true and any? rabbits in-radius 1 with [isMale = false and health = 3 and energy > birth-threshold]
    [
      ;; male rabbits only lose energy
      set energy energy / 2
    ]
    if isMale = false and any? rabbits in-radius 1 with [isMale = true and health = 3 and energy > birth-threshold]
    [
      ;; female rabbits lose energy and give birth
      set energy energy / 2
      if one-of [ true false ] = true
      [
        hatch one-of [1 2] [
          set age 0
          set health 3
          set isMale one-of [ true false ]
          ifelse isMale
            [ set color blue ]
            [ set color pink ]
          setxy random-xcor random-ycor
          set energy random 10
          fd 1
        ]
      ]
    ]
  ]
end

to death     ;; rabbit procedure
  ;; die if you run out of energy
  if energy < 0 or age > 200 [ die ]
end
