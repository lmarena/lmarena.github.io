---
layout: distill
title: RedTeam Arena
description: An Open-Source, Community-driven Jailbreaking Platform
giscus_comments: true
date: 2024-09-13
featured: false
thumbnail: assets/img/blog/redteam_arena/logo.png
authors:
  - name: Anastasios Angelopoulos*
    url: "http://angelopoulos.ai/"
    affiliations:
      name: UC Berkeley
  - name: Luca Vivona*
    url: "https://vivona.xyz/"
  - name: Wei-Lin Chiang*
    url: "https://infwinston.github.io/"
  - name: Aryan Vichare
    url: "https://www.aryanvichare.dev/"
  - name: Lisa Dunlap
    url: "https://www.lisabdunlap.com/"
  - name: Sal Vivona
    url: "https://www.linkedin.com/in/salvivona/"
  - name: Pliny
    url: "https://x.com/elder_plinius"
  - name: Ion Stoica
    url: "https://people.eecs.berkeley.edu/~istoica/"
---

We are excited to launch [RedTeam Arena](https://redarena.ai), a community-driven redteaming platform, built in collaboration with [Pliny](https://x.com/elder_plinius) and the [BASI](https://discord.gg/Y6GxC59G) community!

<img src="/assets/img/blog/redteam_arena/badwords.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>
<p style="color:gray; text-align: center;">Figure 1: RedTeam Arena with Bad Words at <a href="https://redarena.ai">redarena.ai</a></p>

RedTeam Arena is an [open-source](https://github.com/redteaming-arena/redteam-arena) red-teaming platform for LLMs. Our plan is to provide games that people can play to have fun, while sharpening their red-teaming skills. The first game we created is called _[Bad Words](https://redarena.ai)_, challenging players to convince models to say target "bad words”. It already has strong community adoption, with thousands of users participating and competing for the top spot on the jailbreaker leaderboard.

We plan to open the data after a short responsible disclosure delay. We hope this data will help the community determine the boundaries of AI models—how they can be controlled and convinced.

This is not a bug bounty program, and it is not your grandma’s jailbreak arena. Our goal is to serve and grow the redteaming community. To make this one of the most massive crowdsourced red teaming initiatives of all time. From our perspective, models that are easily persuaded are not worse: they are just more controllable, and less resistant to persuasion. This can be good or bad depending on your use-case; it’s not black-and-white.

We need your help. Join our jailbreaking game at [redarena.ai](https://redarena.ai). All the code is open-sourced on [Github](https://github.com/redteaming-arena/redteam-arena). You can open issues and also send feedback on [Discord](https://discord.gg/6GXcFg3TH8). You are welcome to propose new games, or new bad words on X (just tag @[lmsysorg](https://x.com/lmsysorg) and @[elder_plinius](https://x.com/elder_plinius) so we see it)!

## The Leaderboard

<img src="/assets/img/blog/redteam_arena/leaderboard.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>
<p style="color:gray; text-align: center;">Figure 2. Leaderboard screenshot. Latest version at <a href="https://redarena.ai/leaderboard">redarena.ai/leaderboard</a></p>

People have been asking how we compute the leaderboard of players, models, and prompts. The idea is to treat every round of Bad Words as a 1v1 game between a player and a (prompt, model) combination, and calculate the corresponding Elo score. Doing this naively is sample-inefficient and would result in slow convergence, so we instead designed a new statistical method for this purpose (writeup coming!) and we’ll describe it below.

_Observation model._ Let $$T$$ be the number of battles (“time-steps”), $$M$$ be the number of models, $$P$$ be the number of players, and $$R$$ be the number of prompts. For each battle $$i \in [n]$$, we have a player, a model, and a prompt, encoded as following:

- $$X_i^{\rm Model} \in \{0,1\}^M$$, a one-hot vector with 1 on the entry of the model sampled in battle $$i$$.
- $$X_i^{\rm Player} \in \{0,1\}^P$$, a one-hot vector with 1 on the entry of the player in battle $$i$$.
- $$X_i^{\rm Prompt} \in \{0,1\}^R$$, a one-hot vector with 1 on the entry of the prompt sampled in battle $$i$$.
- $$Y_i \in \{0,1\}$$, a binary outcome taking the value 1 if the player won (or forfeited) and 0 otherwise.

We then compute the [Extended Online Arena Score](https://blog.lmarena.ai/blog/2024/extended-arena/), with the feature $$X_i$$ being the concatenation of $$X_i^{\rm Model}$$, $$X_i^{\rm Player}$$, and $$X_i^{\rm Prompt}$$, and the label $$Y_i$$ being the outcome of battle $$i$$.

That’s it! After updating the model coefficients in this way, we report them in the tables in the [RedTeam Arena](https://redarena.ai/leaderboard).

## What’s next?

[RedTeam Arena](https://redarena.ai) is a community-driven project, and we’re eager to grow it further with your help! Whether through raising Github issues, creating PRs [here](https://github.com/redteaming-arena/redteam-arena), or providing feedback on [Discord](https://discord.gg/6GXcFg3TH8), we welcome all your contributions!

## Citation

```
@misc{chiang2024chatbot,
    title={Chatbot Arena: An Open Platform for Evaluating LLMs by Human Preference},
    author={Wei-Lin Chiang and Lianmin Zheng and Ying Sheng and Anastasios Nikolas Angelopoulos and Tianle Li and Dacheng Li and Hao Zhang and Banghua Zhu and Michael Jordan and Joseph E. Gonzalez and Ion Stoica},
    year={2024},
    eprint={2403.04132},
    archivePrefix={arXiv},
    primaryClass={cs.AI}
}
```

---
