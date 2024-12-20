---
layout: distill
title: Predicting Ties in Chatbot Arena
description: the Rao-Kupper Model
giscus_comments: true
date: 2024-12-10
featured: false
thumbnail: assets/img/blog/rao_kupper/pfp.png

authors:
  - name: Tianle Li
    url: "https://codingwithtim.github.io/"
    affiliations:
      name: UC Berkeley
  - name: Anastasios Angelopoulos
    url: "http://angelopoulos.ai"
  - name: Wei-Lin Chiang
    url: "https://infwinston.github.io/"
---

## Introduction

I am sure many of us often find ourselves uncertain whether model A or model B is better. In those cases, we are saved by the "Tie" or "Tie (BothBad)" buttons on Chatbot Arena. In fact, more than ~35% of Chatbot Arena votes are ties. Currently, Chatbot Arena handles ties by treating them as half a win and half a loss when minimizing the Binary Cross Entropy Loss (which is equivalent to maximizing the log likelihood of the Bradley-Terry coefficients). However, the resulting Bradley-Terry (BT) model is not able to produce a probability of ties, which makes it harder for us to validate the leaderboard. However, there is a lesser known extension to the Bradley-Terry model called the Rao-Kupper model which directly and explicitly models the probability of ties. In this blog, we implement this model and study its effect on Chatbot Arena.

## Background on Statistical Modeling of Ties

In the large statistical literature on learning to rank from pairwise comparisons, there are several existing models for handling ties, including the [Rao-Kupper](https://www-jstor-org.libproxy.berkeley.edu/stable/2282923) model, the [Davidson](https://www.jstor.org/stable/2283595) model, and other generalizations of the Bradley-Terry model.
Here, we will explain and analyze the Rao-Kupper model, which assumes that there is a latent strength parameter for each model, and that the probability of a tie between two models is a function of the difference in their strengths.
The ideas, of course, extend to any of these generalizations.

### Rao-Kupper Model

Consider $$M$$ models, $$m_1, ..., m_M$$.
The Bradley-Terry model states that, for two models $$m_A$$ and $$m_B$$,

$$\mathbb{P}(m_A \text{ beats } m_B) = \frac{e^{\beta_{m_A}}}{e^{\beta_{m_A}} + e^{\beta_{m_B}}}$$

and

$$\mathbb{P}(m_B \text{ beats } m_A) = 1-\mathbb{P}(m_A \text{ beats } m_B),$$

for some vector of so-called Bradley-Terry coefficients, $$\beta \in \mathbb{R}^M$$.

As you can see, the BT model cannot give a probability that $$m_A \text{ ties with } m_B$$---it is simply not defined.
Having said that, we still use ties when we estimate the BT coefficients.
In particular, the Chatbot Arena Score treats a tie has half a win and half a loss when minimizing the binary cross-entropy loss.
The resulting Bradley-Terry model is still not able to produce a probability of ties, but the ties are accounted for in the estimation of the coefficients.

The Rao-Kupper model goes one step further by introducing an explicit probability that $$m_A$$ can tie with $$m_B$$.
In particular, the model introduces a threshold parameter, $$\eta \geq 0$$, that represents the minimum difference between two models that can be distinguished by a human rater. When the differences fall within this threshold, the Rao-Kupper model will predict it is a tie.
More formally, Rao-Kupper defines the probability of winning and tying as

$$\mathbb{P}(m_A \text{ beats } m_B) = \frac{e^{\beta_{m_A}}}{e^{\beta_{m_A}} + e^{\beta_{m_B} + \eta}},$$

and

$$\mathbb{P}(m_A \text{ ties with } m_B) = \frac{(e^{2\eta}-1)e^{\beta_{m_A}}e^{\beta_{m_B}}}{(e^{\beta_{m_A}} + e^{\beta_{m_B}})(e^{\beta_{m_A}} + e^{\beta_{m_B}} + e^{\eta})},$$

respectively.
It is easy to see that the Rao-Kupper becomes the Bradley-Terry model when $$\eta=0$$: the first equation becomes the same as the BT model from earlier, and the tie probability becomes 0.

To see the connection to the Bradley-Terry model, note that the win probability of $$m_A$$ over $$m_B$$ can be rearranged as
$$\mathbb{P}(m_A \text{ beats } m_B) = \sigma\left( \beta_{m_A} - \beta_{m_B} - \eta \right),$$
where $$\sigma$$ is the sigmoid function.
Of course, this also implies that

$$\mathbb{P}(m_A \text{ ties with } m_B) = 1 - \sigma\left( \beta_{m_A} - \beta_{m_B} - \eta \right) - \sigma\left( \beta_{m_B} - \beta_{m_A} - \eta \right),$$

which is how the previous expression for the tie rate arises.
This equation allows us to read off that the tie rate is monotone increasing in $$\eta$$, since the sigmoid function is monotone in its argument.
That is, as $$\eta$$ grows, the probability of tying grows exactly as the sum of the above sigmoids.

### Estimation

Having introduced the statistical model, how do we estimate the parameters?
The answer is maximum-likelihood estimation (MLE); see Page 197 of [the original Rao-Kupper](https://www-jstor-org.libproxy.berkeley.edu/stable/2282923) paper.
In short, the expression for the empirical MLE is

$$\hat\beta, \hat\eta = \arg \min_{\beta \in \mathbb{R}^M, \eta \in \mathbb{R}_{+}} -\frac{1}{n}\sum_{k \in N} \ln\left((e^{2\eta}-1)^{\mathbb{I}\{Y_i=\text{tie}\}}\sigma(\beta_i-\beta_j-\eta)^{\mathbf{I}\{Y_i\neq\text{tie}\}}\right),$$

where $$n$$ is the total number of battles and $$Y_i$$ is the arena vote on the $$i$$-th battle. See [Implementation](#implementation) for a torch implementation of the Rao-Kupper model.

## Results

We apply Rao-Kupper model to estimate the model performance on Chatbot Arena and present the bootstrapped Arena Scores for the top 25 models on 1.8 million votes below. Visually, there isn't a big difference between the two leaderboards.
This indicates that the initial BT modeling strategy was indeed robust to ties: that is, the explicit modeling of ties is not very consequential to the final ranking.

<img src="/assets/img/blog/rao_kupper/bootstraps/bt_elo_bootstrap.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>

<p style="color:gray; text-align: center;">Figure 1. Overall Chatbot Arena Bradley-Terry Bootstrapped Ranking.</p>

<img src="/assets/img/blog/rao_kupper/bootstraps/rk_elo_bootstrap.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>

<p style="color:gray; text-align: center;">Figure 2. Overall Chatbot Arena Rao-Kupper Bootstrapped Ranking.</p>

Let's dive deeper! The matrix shown below is the familiar win probability matrix for each model pair on battles excluding ties.
This is the chart displayed on the Chatbot Arena website.

<img src="/assets/img/blog/rao_kupper/maps/human_no_ties.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>

<p style="color:gray; text-align: center;">Figure 3. Chatbot Arena's win probability between model pairs on battles excluding ties.</p>

We show the Bradley-Terry and Rao-Kupper model below. We keep the color scale consistent, so you can directly compare the color between the matrices. Left matrix is the win probability predicted by Bradley-Terry model and the right matrix is the win probability conditioned on no tie produced by Rao-Kupper model.
Comparing both to the actual Chatbot Arena matrix, we can see Rao-Kupper is slightly more calibrated than Bradley-Terry on a cell-by-cell level.

<img src="/assets/img/blog/rao_kupper/maps/bradley_terry.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>
<p style="color:gray; text-align: center;">Figure 4. Predicted win probability of model pairs from Bradley-Terry model fitted on Chatbot Arena data.</p>
<img src="/assets/img/blog/rao_kupper/maps/rao_kupper_no_ties.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>
<p style="color:gray; text-align: center;">Figure 5. Predicted win probability conditioned on not being a tie of model pairs from Rao-Kupper model fitted on Chatbot Arena data.</p>

Numerically, we also observed Rao-Kupper to be more calibrated.
We compared the mean absolute difference between the actual win probability matrix against the matrix produced by each model:

```
Rao-Kupper's MAE: 0.0292
Bradley-Terry's MAE: 0.0417
```

So what happens if you don't exclude tie? What does the win probability matrix look like? We show the actual win probability below. The matrix is almost entirely red now since we are computing
$$\frac{\text{# of Win}}{\text{# of Win + Loss + Ties}}$$
, which mostly is less than $$0.5$$.

<img src="/assets/img/blog/rao_kupper/maps/human_overall.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>
<p style="color:gray; text-align: center;">Figure 6. Predicted win probability of model pairs from Bradley-Terry model on all data.</p>

Now, look at the win probability predicted by the Bradley-Terry model and the Rao-Kupper model.
The Rao-Kupper gets much closer to the actual win rate.
The reason for this is simple: the Bradley-Terry model is missing a factor in the denominator corresponding to the number of ties, so of course, the number is inflated.
In other words, the BT model is essentially modeling the win rate _conditionally on not tying_.
Meanwhile, because the RK model models ties, it aligns better with the _marginal_ win rate.

<img src="/assets/img/blog/rao_kupper/maps/bradley_terry.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>
<p style="color:gray; text-align: center;">Figure 7. Predicted win probability of model pairs from Bradley-Terry model fitted on Chatbot Arena data.</p>
<img src="/assets/img/blog/rao_kupper/maps/rao_kupper.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>
<p style="color:gray; text-align: center;">Figure 8. Predicted win probability of model pairs from Rao-Kupper model fitted on Chatbot Arena data.</p>

Finally, another benefit of the Rao-Kupper model is the ability to predict the tie probability directly.
The BT model does not have this ability.
Below, we compare the Rao-Kupper's tie probabilities and the actual tie probabilities.
Qualitatively, the matrices look approximately the same: the number of ties in every bin is approximately equal to $$0.4$$.
There are some variations in the human win-rate matrix that look like they are due to small-sample estimation noise.

<img src="/assets/img/blog/rao_kupper/maps/human_tie_prob.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>

<p style="color:gray; text-align: center;">Figure 9. The actual tie probabilities between model pairs.</p>

<img src="/assets/img/blog/rao_kupper/maps/rao_kupper_ties.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>

<p style="color:gray; text-align: center;">Figure 10. The predicted tie probabilities between model pairs from Rao-Kupper model fitted on Chatbot Arena data.</p>

### Implementation

Below is an example implementation of Rao-Kupper model that can be intergrated into FastChat's rating utility [file](https://github.com/lm-sys/FastChat/blob/main/fastchat/serve/monitor/rating_systems.py), which contains mathematical functions we used for computing elo and bradley-terry coefficients for Chatbot Arena leaderboard. The implementation below requires a few other functions and imports within the FastChat's rating uility [file](https://github.com/lm-sys/FastChat/blob/main/fastchat/serve/monitor/rating_systems.py).

```python
def RK_Loss(ratings, labels, weights=None, eps=1e-6):
    # labels size: (2M+, 3)

    coefs = ratings[:-1]
    eta = torch.exp(ratings[-1]) # eta > 0

    model_idx = labels[:, :2]
    tie_ind = labels[:, -1]

    paired_coefs = coefs[model_idx]
    paired_delta_logit = paired_coefs[:, 0] - paired_coefs[:, 1]

    # compute RK probabilities
    p_w = torch.sigmoid(paired_delta_logit - eta)
    p_l = torch.sigmoid(-1 * paired_delta_logit - eta)
    p_t = 1 - p_w - p_l

    # point-wise likelihood
    A = torch.stack((p_w, p_t)) # 2 x 2M+
    p = A.take_along_dim(dim=0, indices=tie_ind.unsqueeze(0))

    # mathematically p_t < 1 always but bfloat rounding...
    p = torch.clamp(p, min=1e-3)

    if weights:
        return -torch.log(p + eps).dot(weights)
    else:
        return -torch.log(p + eps).mean()


def fit_rk(labels, n_models, tol=1e-6):
    labels = torch.tensor(labels, dtype=torch.long)

    ratings = torch.ones(n_models + 1, dtype=torch.float64, requires_grad=True)
    optimizer = torch.optim.LBFGS([ratings], max_iter=100, tolerance_grad=tol)

    def closure():
        optimizer.zero_grad()
        nll = RK_Loss(ratings, labels)
        nll.backward()
        return nll

    optimizer.step(closure)

    return ratings.detach().numpy()


def compute_rk(df, base=10.0, scale=400.0, init_rating=1000, tol=1e-6):
    matchups, models = get_matchups_models(df)
    n_models = len(models)

    idx = data.winner.map(lambda x: x == "model_b").astype(int).to_numpy()

    ordered_matchups = np.take_along_axis(matchups, indices=np.stack([idx, (1 - idx)]).T, axis=-1)
    labels = np.column_stack([ordered_matchups,
                              data.winner.map(lambda x: "tie" in x).astype(int).to_numpy()])

    ratings = fit_rk(labels, n_models, tol)

    scaled_ratings = scale_and_offset(ratings, models, scale, init_rating=init_rating)
    return pd.Series(scaled_ratings, index=models).sort_values(ascending=False)
```

### Citation

```
@misc{li2024raokupperarena,
    title = {Predicting Ties in Chatbot Arena: the Rao-Kupper Model},
    url = {https://blog.lmarena.ai/blog/2024/rao-kupper/},
    author = {Tianle Li and Anastasios Angelopoulos and Wei-Lin Chiang},
    year = {2024}
}

@misc{chiang2024chatbot,
    title={Chatbot Arena: An Open Platform for Evaluating LLMs by Human Preference},
    author={Wei-Lin Chiang and Lianmin Zheng and Ying Sheng and Anastasios Nikolas Angelopoulos and Tianle Li and Dacheng Li and Hao Zhang and Banghua Zhu and Michael Jordan and Joseph E. Gonzalez and Ion Stoica},
    year={2024},
    eprint={2403.04132},
    archivePrefix={arXiv},
    primaryClass={cs.AI}
}
```
