---
layout: distill
title: Statistical Extensions of the Bradley-Terry and Elo Models
description:
giscus_comments: true
date: 2024-09-30
featured: false
thumbnail: assets/img/blog/extended_arena/logo.png
authors:
  - name: Anastasios N. Angelopoulos*
    url: "http://angelopoulos.ai/"
    affiliations:
      name: UC Berkeley
  - name: Wei-Lin Chiang*
    url: "https://infwinston.github.io/"
  - name: Shishir G. Patil
    url: "https://shishirpatil.github.io/"
---

Based on our [previous](http://blog.lmarena.ai/blog/2023/leaderboard-elo-update/) [posts](http://blog.lmarena.ai/blog/2024/style-control/), Chatbot Arena uses the Bradley-Terry model for the purposes of statistical inference on the model strength. Recently, we have developed some extensions of the Bradley-Terry model, and the closely related Elo model, for the purpose of binary-comparison inference problems. Our extensions target the case where each of the two players in the comparison may contain more than one subsystem that contributes to their strength. We will develop these extensions in the batch form (Extended Bradley-Terry) and in the online form (Extended Elo).

## Setup

Let $$\ell : [0,1] \times \{0,1\} \to \mathbb{R}$$ denote the binary cross-entropy loss, where the first argument is the predicted probability, and the second argument is the ground-truth binary outcome. As a reminder, for a prediction $$\hat{y} \in [0,1]$$ and a binary label $$y \in \{0,1\}$$, the binary cross-entropy loss is defined as

$$\ell(\hat{y}, y) = -y \log(\hat{y}) - (1-y) \log(1-\hat{y}).$$

Furthermore, let $$M_{A}, M_{B} \in \mathbb{N}$$, $$d_{m_{A}, -1}, d_{m_B, 1} \in \mathbb{N}$$ for all $$m_{A} \in [M_{A}]$$ and $$m_B \in [M_B]$$, and $$d_{\rm total} = \sum\limits_{m_{A} \in [M_{A}]} d_{m_{A}, A} + \sum\limits_{m_{B} \in [M_{B}]} d_{m_{B}, B}$$.
Next, define the set

$$\mathcal{X} = \{ x \in \{-1, 0, 1\}^{d_{\rm total}} : | \{j : x_j = -1 \} | = M_{A} \text{ and } | \{j : x_j = 1 \} | = M_{B}\}.$$

That is, $$\mathcal{X}$$ is the set of vectors of length $$d_{\rm total}$$ with $$M_{A}$$ entries equal to $$-1$$, $$M_{B}$$ entries equal to $$1$$, and the rest equal to $$0$$.
The interpretation is that we have $$M_A$$ subsystems for player $$A$$ and $$M_B$$ subsystems for player $$B$$, and the feature vector $$x \in \mathcal{X}$$ encodes which subsystems are active in the current battle.
The active subsystems for player $$A$$ are those with $$-1$$, and the active subsystems for player $$B$$ are those with $$1$$.
Then, with $$\sigma$$ as the sigmoid function, the extended Bradley-Terry model postulates that the probability that player $$B$$ beats player $$A$$ is given by

$$\mathbb{P}(B \text{ beats } A) = \sigma(x^{\top} \theta^*),$$

for some (unknown) parameter vector $$\theta^* \in \mathbb{R}^{d_{\rm total}}$$.

As in the standard Bradley-Terry model, this parameter vector can be expressed as the solution to a logistic regression:

$$\theta^* = \arg\min\limits_{\theta \in \mathbb{R}^{d_{\rm total}}} \mathbb{E}_{(X,Y) \sim P}\left[ \ell(\sigma(X^\top \theta), Y) \right],$$

where $$P$$ is some joint distribution over $$\mathcal{X} \times \{0,1\}$$.
The standard Bradley-Terry model is recovered when $$M_A=M_B=1$$.
As a side note, we normally report these coefficients after multiplying them by $$400$$ and adding $$1000$$, so that the coefficients are in the same range as the Elo ratings in chess.
This is a purely cosmetic transformation and does not affect the model's predictions.

## Extended Arena Score

To estimate $$\theta^*$$ given a sample $$(X_1,Y_1), \ldots, (X_n,Y_n)$$, we calculate the population logistic regression solution,

$$\hat\theta = \arg\min\limits_{\theta \in \mathbb{R}^{d_{\rm total}}} \sum\limits_{i=1}^n \ell(\sigma(X_i^\top \theta), Y_i) + \lambda \|\theta\|_p,$$

where $$\lambda \geq 0$$ is a regularization parameter and $$\|\cdot\|_p$$ is the $$\ell_p$$ norm (most commonly, we take $$p=1$$ or $$p=2$$).
The regularization term is used to prevent overfitting and to ensure that the solution is unique, especially when the number of samples is small and the solution may not be unique.

## Extended Online Arena Score

The Extended Arena Score from the previous section handles the batch setting, where all the samples are available at once, and they come i.i.d. from a distribution $$P$$. However, in many applications, the samples arrive sequentially, and we would like to update our estimate of $$\theta^*$$ as new samples arrive from a possibly changing distribution. This is the online setting, and we can use the Extended Online Arena Score to update our estimate of $$\theta^*$$ as new samples
arrive.
The Extended Online Arena Score amounts to running online logistic regression on the same feature set.
The algorithm is as follows:

$$ \theta^{(t+1)} = \theta^{(t)} - \eta \nabla \ell(\sigma(X_t^\top \theta^{(t)}), Y_t) - \lambda \nabla \|\theta^{(t)}\|_p,$$

where $$\eta > 0$$ is the learning rate, and $$\nabla \|\cdot\|_p$$ is any valid subgradient of the $$\ell_p$$ norm.
The benefit, and drawback, of the online score is that it never converges.
When the distribution of the samples is changing, the online score will adapt to the new distribution, while the batch score will not.
However, the online score will not converge to the true $$\theta^*$$, while the batch score will, when such a $$\theta^*$$ exists.

## Uses of these Extensions

These extensions have been used in a handful of recent projects, including the [RedTeam Arena](http://blog.lmarena.ai/blog/2024/redteam-arena/) project, where we use the online variant to jointly rank models, target phrases, and players; and the [Agent Arena](http://blog.lmarena.ai/blog/2024/agent-arena/) project, where we use the batch version to jointly rank models, tools, frameworks, and agents.

## Citation

```
@misc{angelopoulos2024statistical,
    title={Statistical Extensions of the Bradley-Terry and Elo Models},
    author={Anastasios Nikolas Angelopoulos and Wei-Lin Chiang and Shishir Patil},
    year={2024},
    url={https://blog.lmarena.ai/blog/extended-elo/}
}
```

---
