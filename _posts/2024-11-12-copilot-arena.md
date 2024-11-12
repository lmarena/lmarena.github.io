---
layout: distill
title: Copilot Arena
description: Copilot Arena's Initial Leaderboard, Insights, and a New Prompting Method for Code Completions
giscus_comments: true
date: 2024-11-12
featured: true
thumbnail: assets/img/blog/copilot_arena/leaderboard_pfp.png
authors:
  - name: Wayne Chi
    url: "https://waynchi.github.io"
    affiliations:
      name: CMU, UC Berkeley
  - name: Valerie Chen
    url: "https://valeriechen.github.io/"
  - name: Anastasios N. Angelopoulos
    url: "http://angelopoulos.ai"
  - name: Wei-Lin Chiang
    url: "https://infwinston.github.io/"
  - name: Naman Jain
    url: "https://naman-ntc.github.io/"
  - name: Tianjun Zhang
    url: "https://tianjunz.github.io/"
  - name: Ion Stoica
    url: "https://people.eecs.berkeley.edu/~istoica/"
  - name: Chris Donahue
    url: "https://chrisdonahue.com/"
  - name: Ameet Talwalkar
    url: "https://www.cs.cmu.edu/~atalwalk/"
---

## Introduction

As LLMs are embedded more and more within production workflows, it's time to rethink how we measure LLM capabilities to better reflect real-world usage. A few weeks ago, we launched [Copilot Arena](https://marketplace.visualstudio.com/items?itemName=copilot-arena.copilot-arena&ssr=false#overview), a **free** AI coding assistant that provides paired responses from different state-of-the-art LLMs. We first introduced paired code completions and more recently rolled out inline editing-a feature where users can highlight code segments, write a prompt, and receive two diff-based suggestions for modifying that code.

Thus far, Copilot Arena has been downloaded 2.5K times on the VSCode Marketplace, served over 100K completions, and accumulated over 10K code completion battles. In this blog post, we'll cover:

- [Initial Leaderboard and Results](#initial-leaderboard-and-results). Our preliminary results for the code completions leaderboard and analysis of model tiers.
- [Copilot Arena Usage](#how-do-people-use-copilot-arena). Analysis on Copilot Arena usage, including the distribution of coding languages, context lengths, and an initial inspection into position bias.
- [Prompting](#how-do-we-prompt-chat-models-to-perform-code-completions). Details of how we use chat models like Claude Sonnet 3.5 and GPT-4o to perform code completions (spoiler alert, we generate code snippets and post-process\!).

## Initial Leaderboard and Results

As an initial set of models, we selected 9 of the best models across multiple model providers that include both open, code-specific, and commercial models. To ensure a fair comparison between models, we do the following…

- We randomize whether models appear at the top or bottom for each completion along with which models are paired for each battle.
- We show both completions at the same time. This means that a faster model completion needs to wait for the slower model.
- Many of the models with superior coding capabilities are chat models. As discussed later in the post, we optimize the prompts so they can perform code completions. We manually verified there were no significant formatting issues in the data collected.
- We set the same max number of output tokens, input tokens, top-p, and temperature (unless specified by the model provider).

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
  <table class="tg">
    <thead>
      <tr>
        <th>Model</th>
        <th style="text-align: center;">Arena Score</th>
        <th style="text-align: center;">Confidence Intervals</th>
        <th style="text-align: center;">Median Latency (s)</th>
      </tr>
    </thead>
    <tbody>
      <tr style="background-color: #EFBF04; color: black">
        <td>Deepseek V2.5</td>
        <td style="text-align: center;">1074</td>
        <td style="text-align: center;">+16/-11</td>
        <td style="text-align: center;">2.13</td>
      </tr>
      <tr style="background-color: #EFBF04; color: black">
        <td>Claude Sonnet 3.5 (06/20)</td>
        <td style="text-align: center;">1053</td>
        <td style="text-align: center;">+18/-17</td>
        <td style="text-align: center;">2.29</td>
      </tr>
      <tr style="background-color: #C0C0C0; color: black">
        <td>Codestral (05/24)</td>
        <td style="text-align: center;">1046</td>
        <td style="text-align: center;">+12/-10</td>
        <td style="text-align: center;">1.01</td>
      </tr>
      <tr style="background-color: #C0C0C0; color: black">
        <td>Meta-Llama-3.1-405B-Instruct</td>
        <td style="text-align: center;">1024</td>
        <td style="text-align: center;">+17/-15</td>
        <td style="text-align: center;">1.12</td>
      </tr>
      <tr style="background-color: #CD7F32; color: black">
        <td>GPT-4o (08/06)</td>
        <td style="text-align: center;">1016</td>
        <td style="text-align: center;">+17/-20</td>
        <td style="text-align: center;">0.75</td>
      </tr>
      <tr style="background-color: #CD7F32; color: black">
        <td>Gemini-1.5-Pro-002</td>
        <td style="text-align: center;">1014</td>
        <td style="text-align: center;">+19/-18</td>
        <td style="text-align: center;">1.44</td>
      </tr>
      <tr style="background-color: #CD7F32; color: black">
        <td>Meta-Llama-3.1-70B-Instruct</td>
        <td style="text-align: center;">1013</td>
        <td style="text-align: center;">+14/-15</td>
        <td style="text-align: center;">0.88</td>
      </tr>
      <tr style="background-color: #CD7F32; color: black">
        <td>Gemini-1.5-Flash-002</td>
        <td style="text-align: center;">1005</td>
        <td style="text-align: center;">+16/-22</td>
        <td style="text-align: center;">0.55</td>
      </tr>
      <tr style="background-color: #E8E8E8; color: black">
        <td>GPT-4o-mini (07/18)</td>
        <td style="text-align: center;">962</td>
        <td style="text-align: center;">+17/-15</td>
        <td style="text-align: center;">0.74</td>
      </tr>
    </tbody>
  </table>
</div>
<p style="color:gray; text-align: center;">Table 1. Elo ratings and median latency of nine popular models based on over 10K votes collected between October 16-November 11, 2024. We color rows based on tiers determined by confidence intervals. Each model has at least 1K votes.</p>

Table 1 presents the current code completion leaderboard and stratifies them into tiers. Here are our main takeaways:

- With a minor prompt tweak, Claude is able to compete with code-specific models (e.g., Deepseek V2.5) on code completion tasks, including ones that require “fill-in-the-middle”. From the beginning, we observed that these Claude and DeepSeek models have emerged as top contenders and separated themselves from the rest of the pack.
- Within a tier, we still observe slight fluctuations as we obtain more votes. Check out Figure 2 for a breakdown of the win rate percentage for each pair of models.
- We find that GPT-4o-mini is much worse than all other models.

We follow the same leaderboard computation as the latest version of Chatbot Arena, which is based on learning Bradley-Terry coefficients that minimize loss when predicting whether one model will beat the other. Please check out [this blog post](https://blog.lmarena.ai/blog/2024/extended-arena/) for a more in-depth description.

<img src="/assets/img/blog/copilot_arena/winrate_matrix.png" alt="Model win rate matrix" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 2. Fraction of model A wins for all battles</p>

### The Effect of Latency

While the Arena scores (Table 1) do not explicitly factor in model latency since both completions are shown simultaneously, we explore whether Arena Scores correlate with latency. We include median latency as a separate column in the results. In general, we find that people don't necessarily prefer faster models. However, this may be partially because code completions are only generated in Copilot Arena after a user pauses.

## How do people use Copilot Arena?

**What kind of languages do people code in?**  
Most current Copilot Arena users code in Python, followed by javascript/typescript, html/markdown, and C++. This statistic is determined based on the file extension.

<img src="/assets/img/blog/copilot_arena/filetype_dist.png" alt="Copilot Arena filetype distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 3. Filetypes requested in Copilot Arena. Filetypes are determined based on file extension.</p>

**What kind of context lengths are we looking at?**  
The mean context length is 1002 tokens and the median is 560 tokens. This is much longer than tasks considered in existing static benchmarks. For example, human eval has a median length of ~100 tokens.

<img src="/assets/img/blog/copilot_arena/context_length_dist.png" alt="Copilot Arena context length distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 4. Context length of files requested in Copilot Arena.</p>

**Are people biased towards the top completion?** Yes. In fact, 82% of accepted completions were the top completion. We are still analyzing our data, but here are some of our insights.

- _Are people even reading the completions? Or are they just instinctively pressing Tab?_ Users take a median of 7 seconds to view the response and then select a response. As such, we believe that people are indeed reading the completions.

<img src="/assets/img/blog/copilot_arena/vote_times.png" alt="Copilot Arena Vote time distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 5. Distribution of user response times. Most users are taking a few seconds to read the responses.</p>

- _Does position bias affect models equally?_ Surprisingly, no\! For example, when shown as the bottom completion, Sonnet-3.5 is accepted 23.4% of the time compared to only 12.8% of the time for Gemini Flash. On the other hand, they are accepted at roughly the same rate when shown as the top completion (86.7% vs 85% respectively). We are still exploring the reasons behind this phenomenon and will continue our analysis in a future post.

**How many people are regular users?**
In total, we have had votes from 833 unique users and between 200-250 daily active users.

**How do you handle ties in Arena?**
We do not currently have an option for people to select that both responses are equally good (or bad).

**How do you handle models pre-trained on FiM?**
For Deepseek V2.5 and Codestral, we use their API which directly allows for FiM capabilities.

## How Do We Prompt Chat Models to Perform Code Completions?

<img src="/assets/img/blog/copilot_arena/instruct_error.png" alt="Copilot Arena filetype distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 6. (Top) Example of code completion that requires infilling capabilities. (Bottom) Example of formatting issue that chat models encounters when prompted to complete code given the prefix and suffix.</p>

During real development processes, developers frequently modify or expand on existing code, rather than only write code in a left-to-right manner. As such, [“fill in the middle”](https://arxiv.org/abs/2204.05999) (FiM) capabilities when generating code completions are critical for any models to be used in Copilot Arena. Many code-specific models, including DeepSeek and Codestral, are specifically trained to perform FiM. However, most models in Copilot Arena are not because they are chat models, and thus, they struggle to appropriately format a completion when provided with the prefix and suffix. We explore a simple prompting trick that allows chat models to perform code completions with high success.

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table class="tg">
  <thead>
    <tr>
      <th>Model</th>
      <th style="text-align: center;">PSM</th>
      <th style="text-align: center;">SPM</th>
      <th style="text-align: center;">Mask</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Claude-3.5-sonnet</td>
      <td style="text-align: center;">0.67 (+0.16)</td>
      <td style="text-align: center;">0.66 (+0.15)</td>
      <td style="text-align: center;">0.66 (+0.14)</td>
    </tr>
    <tr>
      <td>GPT-4o-2024-08-06</td>
      <td style="text-align: center;">0.71 (+0.02)</td>
      <td style="text-align: center;">0.55 (+0.19)</td>
      <td style="text-align: center;">0.62 (+0.12)</td>
    </tr>
    <tr>
      <td>GPT-4o-mini-2024-07-18</td>
      <td style="text-align: center;">0.18 (+0.39)</td>
      <td style="text-align: center;">0.12 (+0.54)</td>
      <td style="text-align: center;">0.15 (+0.36)</td>
    </tr>
    <tr>
      <td>Gemini-1.5-pro-001</td>
      <td style="text-align: center;">0.38 (+0.28)</td>
      <td style="text-align: center;">0.34 (+0.36)</td>
      <td style="text-align: center;">0.43 (-0.04)</td>
    </tr>
    <tr>
      <td>Gemini-1.5-flash-001</td>
      <td style="text-align: center;">0.34 (+0.24)</td>
      <td style="text-align: center;">0.27 (+0.37)</td>
      <td style="text-align: center;">0.36 (+0.19)</td>
    </tr>
    <tr>
      <td>Llama-3.1-70B-Instruct</td>
      <td style="text-align: center;">0.14 (+0.46)</td>
      <td style="text-align: center;">0.15 (+0.48)</td>
      <td style="text-align: center;">0.12 (+0.27)</td>
    </tr>
  </tbody>
</table>
</div>
<p style="color:gray; text-align: center;">Table 2: Percentage of well-formatted code completions with different prompt templates (PSM, SPM, Mask). We denote the gain by our prompting method in parentheses.</p>

**Evaluation Set-up.** To verify that chat models would indeed struggle to perform FiM, we use the [HumanEval-infilling](https://github.com/openai/human-eval-infilling) dataset as an imperfect proxy to benchmark chat models' FiM capabilities. We adopt three prompt templates considered in prior work (e.g., [Gong et al.](https://arxiv.org/abs/2403.04814)) like Prefix-suffix-middle (PSM), Suffix-prefix-middle (SPM), and Mask. Instead of measuring pass@1, we only consider whether the returned infilled code is formatted correctly.

**Chat models can’t naively FiM.** Table 2 shows that standard prompt templates are insufficient for chat models to complete FiM tasks. This is not necessarily an indication that models cannot code as clearly many SOTA chat models are proficient coders. Instead, the vast majority of the errors resulted from issues in formatting or duplicate code segments rather than logical errors, indicating that these models cannot generalize their code outputs to FiM tasks. While it is not feasible to retrain these models, we explore alternative approaches via prompting to enable models to complete FiM tasks.

**Our solution significantly reduces formatting errors.** Instead of forcing chat models to output code in a format unaligned with its training (e.g. FiM), we allow the model to generate code snippets, which is a more natural format, and then post-process them into a FiM completion. Our approach is as follows: in addition to the same prompt templates above, the models are provided with instructions to begin by re-outputting a portion of the prefix and similarly end with a portion of the suffix. We then match portions of the output code in the input and delete the repeated code. As you can see in Table 2, the models make much fewer formatting issues. These benefits hold regardless of the prompt template.

### What’s next?

- **More results and analyses:** We’re working on adding new metrics that will provide more insight into how useful models are (e.g., code persistence), and more fine-grain analyses to understand why some models are preferred by users over others. We will also release a leaderboard for inline editing once we have collected enough votes\!
- **Opportunities to contribute to Copilot Arena:** While our initial prompting efforts are proving to be usable in practice, we welcome suggestions for prompt improvements. In general, we are always looking to improve Copilot Arena. Ping us to get involved\!

## Citation

```bibtex
@misc{chi2024copilot,
    title={Copilot Arena},
    author={Wayne Chi and Valerie Chen and Wei-Lin Chiang and Anastasios N. Angelopoulos and Naman Jain and Tianjun Zhang and Ion Stoica and Chris Donahue and Ameet Talwalkar}
    year={2024},
}
```
