# Dyce
A game by Dylan Tompkins and Bryce Raymundo, built for SLO Hacks 2022

## Inspiration
We were inspired by games like Pokemon Go and Ingress which use the players location to create a more engaging gaming experience. We also wanted to find a way to enjoy the simple time-waster mobile games without intrusive ads. Finally, we wanted the future of our idea to be integral to the Cal Poly campus we have gotten to know very well over the past 2 quarters.

## What it does
Dyce places mini-games around Cal Poly's campus, which you can only play when in close proximity.
Our current game lineup is as follows:
- Pong at OCOB
- Ice Jump at Pilling
- Brick Breaker at tšɨłkukunɨtš

## How we built it
Dyce's development was centered around Flutter, a frontend SDK made by Google which is programmed in Dart. Flutter compiles to many different platforms, including mobile and desktop, but we chose to deploy as a Web App on Firebase, a service of the Google Cloud Platform, so it would be easier for everyone to play. We source our map from Open Street Map, and created our games with the help of Flame, a game engine built on top of Flutter.

## Challenges we ran into
Dylan Tompkins, Cal Poly Software Engineering '25
> I spent a lot of time trying to get a cloud database working in the early hours of Sunday morning. I really wanted to have shared leader boards, so that players could get competitive with each other. I initially tried using CockroachDB, but discovered after a few hours that I could not access it from within a Web App. By the time I decided to pivot to Firestore, we were running out of time. Leaderboards would be the first thing I worked on if I continued this project.

Bryce Raymundo, Cal Poly Computer Science '25
> I struggled with the physics associated with Brick Breaker. I wanted the balls to bounce realistically, and also wanted to use them as a pointer for where you were lining up your shot. Ultimately, I had to make the tough choice to narrow the scope of Brick Breaker in the interest of the overall project. This was tough because I put a lot of time into development that won't be seen as part of our submission.

## Accomplishments that we're proud of
- Paying close attention to our time management and project scope to ensure that we had a polished product at the end
- Bryce had not downloaded Flutter until a couple days before, and then proceeded to make 3 games in 24 hours.
- Dylan had never deployed a project to the internet before, and is very proud to see people actually using something he created.

## What we learned
- Our eyes are bigger than our stomachs!
- Hackathon strategy for trying to be competitive and fast is far from what we are expected of in industry.
- Taking a step back to discuss the big picture of the project or to whiteboard out a problem often leads to more simple and elegant solutions.

## What's next for Dyce
- Monetization through offering organizations the opportunity to buy custom mini games to promote their on-campus presence.
- Cal Poly club to provide continuous content to Dyce and teach students game and app development. This content would also feed the monetization strategy.
- Increase competitive potential through more games and shared leader boards.
