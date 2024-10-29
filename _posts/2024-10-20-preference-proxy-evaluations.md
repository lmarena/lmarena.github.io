---
layout: distill
title: Preference Proxy Evaluations
description: A New Benchmark for Evaluating Reward Models and LLM Judges

giscus_comments: true
date: 2024-10-20
featured: false
thumbnail: assets/img/blog/preference_proxy_evaluations/pfp.png
authors:
  - name: Evan Frick
    affiliations:
      name: UC Berkeley
  - name: Tianle Li
  - name: Connor Chen
  - name: Wei-Lin Chiang
  - name: Anastasios N. Angelopoulos
  - name: Jiantao Jiao
  - name: Banghua Zhu
  - name: Joseph Gonzalez
  - name: Ion Stoica
---

# Introduction

Most LLMs are optimized using an LLM judge or reward model to approximate human preference. These training processes can cost hundreds of thousands or millions of dollars. How can we know whether to trust an LLM judge or reward model, given its critical role in guiding LLM training?

We introduce a benchmark to solve this problem: PPE, a collection of 16,038 labeled human preference pairs from Chatbot Arena containing responses from 20 different top LLMs and over 121 languages as well as a dataset of 2,555 prompts, each with 32 different sampled response options, totaling 81,760 responses across 4 different models, all grounded with verifiable correctness labels. PPE evaluates reward models on 12 different metrics and 12 different domains, such as their accuracy in selecting human-preferred or verifiably correct responses.

To summarize:

1. We curate high quality ground truth preference pairs from Chatbot Arena battles as well as existing verifiable correctness benchmarks.
2. We experimentally correlate metrics on each benchmark to downstream RLHF-ed LLMs.
3. We fully open-source PPE, the resulting comprehensive benchmark for reward models with metrics directly linked to downstream RLHF outcomes.

&nbsp;

<embed src="/assets/img/blog/preference_proxy_evaluations/ppe_image.svg" type="image/svg+xml" style="width:100%; height:auto;" />
<p style="color:gray; text-align: center;"><sub>Figure 1: Human preference scores on two different metrics use by PPE: Accuracy and Spearman correlation.  We notice that the two metrics appear to measure different aspects of the preference proxy. Accuracy may be better for tasks that rank individual responses (like training). Spearman correlation may be better for tasks that rank models (like evaluation). See the later section <i>Studying the Correlation of PPE with Downstream Performance</i> for details on how various metrics correlate to RLHF outcomes. Note: LLM judges in the figure use the Arena-Hard judge prompt.</sub></p>

&nbsp;

Our code can be found on [Github](https://github.com/lmarena/PPE).

Our paper is available on [Arxiv](https://arxiv.org/abs/2410.14872).

&nbsp;

# Methodology

Sourcing high quality, unbiased ground truth preference labels is challenging. One common technique is to use LLM judge preference labels followed by human verification; however, this introduces bias. Another technique involves creating synthetic data by generating perturbations of a gold-standard output, which again introduces bias. These preference pairs are not representative of the distribution of responses seen by reward models when providing learning signals for RLHF.

Our methodology directly grounds preference labels in real user feedback. We propose two methodologies: (1) Utilize crowdsourced diverse prompts and responses with human preference labels from Chatbot Arena. (2) Utilize existing benchmarks with verifiable correctness checks on LLM-generated responses.

The first methodology provides an unbiased estimate of real-world human preference by aggregating many diverse human preferences. We use a large crowdsourced preference set of 16,038 preference labels to mitigate individual label noise and avoid over-fitting to any single individual's preference.

The second methodology curates an objective correctness signal. We use the second approach to label the correctness of many sampled responses from an LLM, mimicking rollouts or best-of-k exploration strategies seen in RLHF training processes. As a result, we draw preference pairs from more naturally occurring distributions (e.g. real LLM responses and errors), that better align with the expected environment reward models operate in.

&nbsp;

# Human Preference

To measure whether alignment with human preference directly, we utilize a dataset collected from Chatbot Arena. The human preference dataset contains human-labeled preferences for 16,038 pairwise comparisons between 20 selected top models.

Since the human preference set is crowdsourced from Chatbot Arena, we can repeat the collection process at any time to obtain an updated set that better reflects the current array of available models and any changes in human preference.

The human preference dataset, at a glance, includes:

1.  4,583 instruction-following prompts, 5,195 hard prompts, 2,564 math prompts. Prompts may exist in multiple categories.

2.  User queries from over 121 languages. Top languages include English (8,842), Chinese (1,823), Russian (1,779), German (568), Korean (338), Japanese (321), etc.

3.  A diverse array of prompt categories: Hard, Easy, Math, Instruction following, and more.

4.  Preferences crowdsourced from 6,120 individuals.

See Appendix [Human Preference Metrics](#human-preference-metrics) for model scores.

&nbsp;

# Correctness Preference

We measure a preference model's ability to distinguish between similar responses and resistance to reward-hacking by using correctness metrics based on benchmarks with verifiable ground truths. We selected five reliable benchmarks: MMLU Pro, MATH, GPQA, MBPP Plus, and IFEval, ensuring that each provides a clear, verifiable correctness signal. This approach is flexible, allowing any benchmark with a verifiable ground truth to be added.

In total, the correctness preference set contains:

1.  2,555 prompts and 32 sampled responses per prompt, totaling 81,760 total responses.

2.  A binary correctness label for each response.

3.  Responses from Llama-3-8B-Instruct, Gemma-2-9b-it, Claude-3-Haiku, and GPT-4o-mini.

See Appendix [Correctness Preference Metrics](#correctness-preference-metrics) for model scores.

&nbsp;

# Validating post-RLHF LLM outcomes

We aim to see how well PPE predict the performance of reward models in training LLMs. To do this, we RLHF-tune a base LLM using several reward models and evaluate the resulting LLMs by measuring real-world human preference (Arena Scores). The experiment uses Llama-3.1-8B-Instruct, with RLHF via Direct Preference Optimization (DPO). Results are collected from 12,190 human votes in Chatbot Arena, and final Arena Scores depend solely on the reward model used.

We selected nine reward models based on popularity and performance. We built a dataset of 8,000 prompts and 128,000 model responses collected from the base model from which each reward model picked a preferred response per prompt, creating a training set of "chosen" and "rejected" responses. Using DPO, we trained Llama-3.1-8B-Instruct for each reward model to assess downstream real-world human preference.

We deployed our trained DPO models to Chatbot Arena for real-world human evaluation. These models were paired against each other for blind comparison. A total of 12,190 votes were collected, averaging 2,032 battles per model and 190 battles per unique model pair. The resulting Arena Scores, calculated using the Bradley-Terry model, are detailed in Appendix [Post-RLHF Arena Scores](#post-rlhf-arena-scores), highlighting the downstream RLHF performance of each reward model based on human preferences.

# Studying the Correlation of PPE with Downstream Performance

<a id="figure2"></a>
<img src="/assets/img/blog/preference_proxy_evaluations/MainHeatmaps.png" style="width:100%; height:auto; text-align: center;"/>

<p style="color:gray; text-align: center;"><sub>Figure 2: Pearson correlations of different metrics toward downstream human preference. Left: Pearson correlation between the ranking of models on 5 specific benchmarks and 5 different metrics and their respective post-DPO Arena Score rankings on real human preference. Right: Pearson correlation between the ranking of models on 7 categories and 7 metrics on the Human Preference Dataset.</sub></p>

<a id="figure3"></a>
<img src="/assets/img/blog/preference_proxy_evaluations/RewardBenchHeatmap.png" 
     style="display: block; margin: 0 auto; width: 50%; height: auto;" />

<p style="color:gray; text-align: center;"><sub>Figure 3: Pearson correlation between the ranking of models in RewardBench and their respective post-DPO Arena Score rankings on real human preference.</sub></p>

On correctness metrics (left plot in [Figure 2](#figure2)) we make several observations: (1) Mean across all domains is well correlated across all metrics, but exhibits higher correlation with AUC and Accuracy scores. (2) Math is the best individual benchmark domain in terms of predictive power. (3) ROC AUC score draws higher correlation across all benchmarks, even on benchmarks that are otherwise uncorrelated.

Turning to the right-hand side of [Figure 2](#figure2), the accuracy of the reward model is the best predictor of the fine-tuned LLM's preference score. Row-wise Pearson Correlation, Confidence Agreement, and Separability show some correlative power to downstream scores but do not exceed accuracy. Meanwhile, metrics like the Spearman correlation and Kendall correlation have nearly zero correlation with the final Arena Scores achieved by the post-DPO models. One possible reason for this trend is that accuracy measures expected preference correctness per preference pair--- a much more granular scale. Other metrics involve aggregating reward model signals over higher-order preferences, such as preference for each model, as measured by correlation metrics. We consider these metrics as low granularity. Medium granularity metrics, such as Row-wise Pearson Correlation aggregate reward model signal, but do so over smaller subsets of preferences.

Overall, accuracy on the human preference dataset is more correlated than the correctness metrics. This is because correctness and human preference do not necessarily align. Moreover, the information contained in Loss, Max score, and End score may not prove relevant in DPO, which is off-policy. Those employing RLHF algorithms that have a higher risk of over-optimization may find these alternative measures helpful. However, when calculating correlation against style controlled Arena Scores<sup>\*</sup> we notice a slight decrease in correlations on the human preference dataset. Notably, the correctness preference measurements show no change, suggesting correctness preference may be more robust towards reward model preference quality, response style aside. Style-controlled correlation heatmaps are shown in Appendix [Style Control](#style-control).

<sup>\*</sup> Style controlled Arena Scores are calculated as detailed in our previous blog, [_Does Style Matter?_](/blog/2024/style-control/)

&nbsp;
<a id="figure4"></a>
<img src="/assets/img/blog/preference_proxy_evaluations/AggregationPlots.png" style="width:100%; height:auto" />

<p style="color:gray; text-align: center;"><sub>Figure 4:  Spearman Correlation, Confidence Agreement, and Accuracy metrics: For each metric, we take the quantiles of category scores (Hard, Easy, Instruction Following, Coding, Math, and Similar). The Pearson Correlation is calculated relative to Post-RLHF Human Preference Arena Score ratings for each quantile. Notably, accuracy peaks at 0.80 correlation at low quantile aggregation.</sub></p>

&nbsp;

Additionally, we observe that measuring the lower bound score may correlate more to downstream RLHF performance than the average score or upper bound score. In [Figure 4](#figure4), we first re-scale each category's scores to be mean 0 and SD 1, then we vary the quantile of the aggregation strategy across human preference dataset categories (Hard Prompts, Easy Prompts, etc). In this case, the 0 quantile is the minimum, and the 1 quantile is the maximum. We find that in nearly every metric, decreasing the quantile increases correlation with downstream Arena Scores. We posit this represents the requirement that reward models be robust under all input distributions to mitigate reward-hacking. Any domain weakness in a reward model can be exploited by the LLM during training.

&nbsp;

# Conclusion

PPE is another step towards rigorous evaluations of reward models and LLM-Judges before deployment to expensive model training and evaluation pipelines. For reward models specifically, we take extra care to ensure that PPE correlates to downstream RLHF-ed LLM performance. Moreover, PPE is a natural framework in which to evaluate LLM judges. We reasoned that a well-aligned LLM judge should be able to reconstruct the preferences we have sourced with high fidelity. For example, LLM judges used for automatic evaluation should be able to rank models in the human preference set with high confidence and correlation. LLM judges used to replicate individual human preferences should do so at high accuracy, just like reward models. Moving forward, we seek to keep creating, updating, and finding new ways in which to ensure that our preference proxy signals are in alignment with our desired outcomes.

&nbsp;

# Citation

```
@misc{frick2024evaluaterewardmodelsrlhf,
      title={How to Evaluate Reward Models for RLHF},
      author={Evan Frick and Tianle Li and Connor Chen and Wei-Lin Chiang and Anastasios N. Angelopoulos and Jiantao Jiao and Banghua Zhu and Joseph E. Gonzalez and Ion Stoica},
      year={2024},
      eprint={2410.14872},
      archivePrefix={arXiv},
      primaryClass={cs.LG},
      url={https://arxiv.org/abs/2410.14872},
}
```

&nbsp;

&nbsp;

&nbsp;

# Appendix

### Human Preference Metrics

| Reward Model                             | Accuracy | R.W. Pearson | Separability | Conf. Agree. | Kendalltau | Spearmanr | Brier Score |
| ---------------------------------------- | -------- | ------------ | ------------ | ------------ | ---------- | --------- | ----------- |
| Ensemble-Judges (ArenaHard)†             | 68.59    | 82.49        | 84.21        | 96.21        | 87.37      | 96.54     | 0.05        |
| Ensemble-Judges (AlpacaEval)†            | 68.52    | 81.25        | 79.47        | 93.94        | 85.26      | 95.04     | 0.07        |
| GPT-4o-2024-08-06 (ArenaHard)†           | 67.71    | 81.07        | 80.53        | 94.70        | 86.32      | 96.24     | 0.06        |
| Claude-3-5-Sonnet-20240620 (ArenaHard)†  | 67.33    | 80.65        | 79.47        | 94.70        | 88.42      | 96.69     | 0.06        |
| GPT-4o-2024-08-06 (AlpacaEval)†          | 67.13    | 77.92        | 76.32        | 90.91        | 84.21      | 93.23     | 0.07        |
| Athene-RM-70B                            | 66.56    | 80.69        | 84.74        | 93.94        | 82.11      | 93.23     | 0.07        |
| GPT-4o-Mini-2024-07-18 (ArenaHard)†      | 66.46    | 78.42        | 75.26        | 92.42        | 83.16      | 93.08     | 0.07        |
| Gemini-1.5-Pro-002 (AlpacaEval)†         | 66.09    | 82.63        | 83.16        | 96.21        | 86.32      | 95.19     | 0.05        |
| Gemini-1.5-Pro-002 (ArenaHard)†          | 65.71    | 82.23        | 83.16        | 94.70        | 90.53      | 96.99     | 0.04        |
| Claude-3-5-Sonnet-20240620 (AlpacaEval)† | 65.34    | 73.91        | 74.21        | 85.61        | 71.58      | 85.26     | 0.11        |
| Llama-3.1-70B-Instruct (AlpacaEval)†     | 65.27    | 74.81        | 79.47        | 87.88        | 72.63      | 85.56     | 0.12        |
| Gemini-1.5-Flash-002 (AlpacaEval)†       | 65.04    | 74.29        | 78.95        | 88.64        | 74.74      | 88.72     | 0.11        |
| Athene-RM-8B                             | 64.59    | 76.85        | 83.68        | 91.67        | 77.89      | 90.53     | 0.10        |
| Llama-3.1-70B-Instruct (ArenaHard)†      | 64.29    | 74.77        | 75.79        | 85.61        | 70.53      | 87.07     | 0.12        |
| Gemini-1.5-Flash-002 (ArenaHard)†        | 63.01    | 76.12        | 76.32        | 90.91        | 76.84      | 90.23     | 0.10        |
| Starling-RM-34B                          | 62.92    | 70.47        | 77.37        | 78.79        | 67.37      | 81.20     | 0.15        |
| GPT-4o-Mini-2024-07-18 (AlpacaEval)†     | 62.75    | 68.86        | 70.53        | 84.09        | 75.79      | 88.12     | 0.10        |
| Gemini-1.5-Pro-001 (ArenaHard)†          | 62.57    | 75.92        | 81.05        | 93.18        | 85.26      | 94.44     | 0.07        |
| Skywork-Reward-Llama-3.1-8B              | 62.37    | 75.51        | 78.95        | 87.88        | 71.58      | 88.12     | 0.11        |
| InternLM2-7B-Reward                      | 62.05    | 68.03        | 78.42        | 69.70        | 56.84      | 76.09     | 0.20        |
| Eurus-RM-7B                              | 62.02    | 60.37        | 75.26        | 64.39        | 51.58      | 65.26     | 0.22        |
| InternLM2-20B-Reward                     | 61.00    | 66.66        | 74.74        | 70.45        | 55.79      | 76.39     | 0.20        |
| ArmoRM-Llama3-8B-v0.1                    | 60.57    | 71.85        | 76.84        | 84.85        | 76.84      | 89.17     | 0.10        |
| NaiveVerbosityModel                      | 59.81    | 32.03        | 76.32        | 35.61        | 29.47      | 33.53     | 0.33        |
| Nemotron-4-340B-Reward                   | 59.28    | 66.96        | 78.95        | 78.79        | 68.42      | 86.02     | 0.14        |
| Llama-3-OffsetBias-RM-8B                 | 59.12    | 58.86        | 65.79        | 61.36        | 51.58      | 69.02     | 0.20        |
| Starling-RM-7B-Alpha                     | 58.93    | 58.42        | 70.00        | 67.42        | 50.53      | 64.66     | 0.22        |
| InternLM2-1.8B-Reward                    | 57.22    | 47.11        | 69.47        | 41.67        | 36.84      | 54.14     | 0.28        |
| Skywork-Reward-Gemma-2-27B               | 56.62    | 69.99        | 69.47        | 87.88        | 84.21      | 95.49     | 0.07        |

Reward model and LLM judge performance on Hard prompt subset of the human preference dataset. LLM-as-a-judge are labeled with system prompt source, and marked with †.

### Correctness Preference Metrics

| Reward Model                | MMLU-Pro | MATH     | GPQA     | MBPP-Plus | IFEval   | Mean     |
| --------------------------- | -------- | -------- | -------- | --------- | -------- | -------- |
| Athene-RM-70B               | 0.77     | 0.79     | 0.59     | 0.68      | 0.62     | **0.69** |
| Claude 3.5 (ArenaHard)†     | **0.81** | **0.86** | **0.63** | 0.54      | 0.58     | 0.68     |
| Llama-3-OffsetBias-RM-8B    | 0.62     | 0.68     | 0.55     | **0.74**  | 0.62     | 0.64     |
| GPT-4o-mini (ArenaHard)†    | 0.71     | 0.81     | 0.57     | 0.54      | 0.56     | 0.63     |
| Llama-3.1-70B (ArenaHard)†  | 0.73     | 0.73     | 0.56     | 0.58      | 0.56     | 0.63     |
| internLM2-20B-Reward        | 0.68     | 0.70     | 0.57     | 0.58      | 0.62     | 0.63     |
| Athene-RM-8B                | 0.68     | 0.71     | 0.55     | 0.62      | 0.57     | 0.62     |
| ArmoRM-Llama3-8B-v0.1       | 0.66     | 0.71     | 0.57     | 0.54      | 0.58     | 0.61     |
| Skywork-Reward-Llama-3.1-8B | 0.64     | 0.70     | 0.57     | 0.52      | 0.61     | 0.61     |
| Nemotron-4-340B-Reward      | 0.70     | 0.65     | 0.57     | 0.49      | 0.63     | 0.61     |
| internLM2-7B-Reward         | 0.67     | 0.73     | 0.55     | 0.44      | **0.64** | 0.60     |
| Llama-3.1-70B (Alpaca)†     | 0.66     | 0.66     | 0.56     | 0.52      | 0.56     | 0.59     |
| Claude 3.5 (Alpaca)†        | 0.66     | 0.63     | 0.56     | 0.52      | 0.57     | 0.59     |
| Skywork-Reward-Gemma-2-27B  | 0.54     | 0.63     | 0.53     | 0.59      | 0.54     | 0.56     |
| GPT-4o-mini (Alpaca)†       | 0.57     | 0.64     | 0.53     | 0.52      | 0.56     | 0.56     |
| NaiveVerbosityModel         | 0.48     | 0.50     | 0.48     | 0.31      | 0.52     | 0.46     |

Reward model and LLM-as-a-judge scores on the correctness accuracy metric. LLM-as-a-judge is marked with †.

| Reward Model                | MMLU Pro | Math  | GPQA  | MBPP Plus | IF Eval | Mean  |
| --------------------------- | -------- | ----- | ----- | --------- | ------- | ----- |
| Athene-RM-70B               | 0.761    | 0.607 | 0.499 | 0.748     | 0.633   | 0.650 |
| InternLM2-20B-Reward        | 0.673    | 0.538 | 0.471 | 0.654     | 0.652   | 0.598 |
| Llama-3-Offsetbias-RM-8B    | 0.590    | 0.481 | 0.450 | 0.819     | 0.646   | 0.597 |
| Athene-RM-8B                | 0.656    | 0.517 | 0.459 | 0.675     | 0.586   | 0.579 |
| Nemotron-4-340B-Reward      | 0.697    | 0.499 | 0.484 | 0.567     | 0.623   | 0.574 |
| InternLm2-7B-Reward         | 0.638    | 0.552 | 0.457 | 0.562     | 0.658   | 0.573 |
| ArmoRM-Llama3-8B-v0.1       | 0.654    | 0.508 | 0.470 | 0.602     | 0.601   | 0.567 |
| Skywork-Reward-Llama-3.1-8B | 0.641    | 0.500 | 0.468 | 0.581     | 0.639   | 0.566 |
| Starling-RM-34B             | 0.651    | 0.476 | 0.453 | 0.634     | 0.569   | 0.557 |
| Eurus-RM-7B                 | 0.607    | 0.516 | 0.438 | 0.590     | 0.594   | 0.549 |
| Skywork-Reward-Gemma-2-27B  | 0.550    | 0.462 | 0.447 | 0.691     | 0.583   | 0.547 |
| InternLM2-1-8B-Reward       | 0.538    | 0.411 | 0.451 | 0.572     | 0.581   | 0.510 |
| Starling-RM-7B-Alpha        | 0.562    | 0.409 | 0.433 | 0.559     | 0.564   | 0.505 |
| NaiveVerbosityModel         | 0.487    | 0.349 | 0.420 | 0.568     | 0.539   | 0.473 |

Reward Model Best of K Performance Across Benchmarks

| Reward Model                | MMLU Pro | Math  | GPQA  | MBPP Plus | IF Eval | Mean  |
| --------------------------- | -------- | ----- | ----- | --------- | ------- | ----- |
| Athene-RM-70B               | 0.792    | 0.760 | 0.603 | 0.661     | 0.594   | 0.682 |
| Internlm2-20B-reward        | 0.677    | 0.691 | 0.562 | 0.574     | 0.595   | 0.620 |
| Llama-3-offsetbias-RM-8B    | 0.631    | 0.617 | 0.541 | 0.710     | 0.594   | 0.619 |
| Athene-RM-8B                | 0.683    | 0.673 | 0.560 | 0.602     | 0.556   | 0.615 |
| Nemotron-4-340B-Reward      | 0.704    | 0.660 | 0.570 | 0.506     | 0.587   | 0.605 |
| Skywork-Reward-Llama-3.1-8B | 0.663    | 0.678 | 0.560 | 0.523     | 0.586   | 0.602 |
| Internlm2-7B-Reward         | 0.665    | 0.718 | 0.558 | 0.464     | 0.605   | 0.602 |
| ArmoRM-Llama3-8B-v0.1       | 0.678    | 0.659 | 0.549 | 0.538     | 0.573   | 0.599 |
| Starling-RM-34B             | 0.683    | 0.621 | 0.547 | 0.534     | 0.536   | 0.584 |
| Eurus-RM-7B                 | 0.627    | 0.665 | 0.521 | 0.537     | 0.554   | 0.581 |
| Skywork-Reward-Gemma-2-27B  | 0.542    | 0.582 | 0.506 | 0.572     | 0.536   | 0.547 |
| Internlm2-1-8B-Reward       | 0.561    | 0.587 | 0.538 | 0.462     | 0.538   | 0.537 |
| Starling-RM-7B-Alpha        | 0.547    | 0.527 | 0.506 | 0.400     | 0.519   | 0.500 |
| NaiveVerbosityModel         | 0.495    | 0.528 | 0.506 | 0.330     | 0.511   | 0.474 |

Area Under ROC Curve for Reward Models across Benchmarks

### Post-RLHF Arena Scores

<table>
  <thead>
    <tr>
      <th>Model</th>
      <th>Arena Score</th>
      <th>95% CI Lower</th>
      <th>95% CI Upper</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Meta-Llama-3.1-70B-Instruct*</td>
      <td>1228</td>
      <td>1218</td>
      <td>1238</td>
    </tr>
    <tr>
      <td>Athene-RM-70B</td>
      <td><strong>1216</strong></td>
      <td>1206</td>
      <td>1226</td>
    </tr>
    <tr>
      <td>Athene-RM-8B</td>
      <td>1209</td>
      <td>1199</td>
      <td>1219</td>
    </tr>
    <tr>
      <td>InternLM2-7B-Reward</td>
      <td>1204</td>
      <td>1194</td>
      <td>1212</td>
    </tr>
    <tr>
      <td>Llama-3-OffsetBias-RM-8B</td>
      <td>1200</td>
      <td>1191</td>
      <td>1209</td>
    </tr>
    <tr>
      <td>ArmoRM-Llama3-8B-v0.1</td>
      <td>1189</td>
      <td>1181</td>
      <td>1198</td>
    </tr>
    <tr>
      <td>Meta-Llama-3.1-8B-Instruct*</td>
      <td>1178</td>
      <td>1168</td>
      <td>1187</td>
    </tr>
    <tr>
      <td>Skywork-Reward-Llama-3.1-8B</td>
      <td>1176</td>
      <td>1166</td>
      <td>1185</td>
    </tr>
    <tr>
      <td>Skywork-Reward-Gemma-2-27B</td>
      <td>1173</td>
      <td>1163</td>
      <td>1182</td>
    </tr>
    <tr>
      <td>InternLM2-20B-Reward</td>
      <td>1173</td>
      <td>1163</td>
      <td>1182</td>
    </tr>
    <tr>
      <td>Nemotron-4-340B-Reward</td>
      <td>1172</td>
      <td>1163</td>
      <td>1180</td>
    </tr>
    <tr>
      <td>Meta-Llama-3-8B-Instruct*</td>
      <td>1152</td>
      <td>1143</td>
      <td>1162</td>
    </tr>
  </tbody>
</table>
Post DPO performance on Chatbot Arena Overall Category. "Model" is the reward model used to train the base model. Models marked with "*" are baseline unaltered models. The best non-base model Arena Score is bolded.

### Style Control

<a id="figure5"></a>
<img src="/assets/img/blog/preference_proxy_evaluations/SCMainHeatmaps.png" style="width:100%; height:auto; text-align: center;"/>

<p style="color:gray; text-align: center;"><sub>Figure 5: Pearson correlations between various metrics and styled-controlled human preference Arena Scores. Left: Correlations between metrics on the Correctness Dataset and Post-RLHF human preference Arena Scores. Right: Correlations between metrics on the Human Preference Dataset and Post-RLHF human preference Arena Scores.</sub></p>

<a id="figure6"></a>
<img src="/assets/img/blog/preference_proxy_evaluations/RewardBenchHeatmap.png" 
     style="display: block; margin: 0 auto; width: 50%; height: auto;" />

<p style="color:gray; text-align: center;"><sub>Figure 6: Pearson correlation between the ranking of models in RewardBench and their respective style-controlled Post-DPO Arena Score rankings on real human preference.</sub></p>
