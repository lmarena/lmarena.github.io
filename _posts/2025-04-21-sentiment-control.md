---
layout: distill
title: "Does Sentiment Matter Too?"
description: "Introducing Sentiment Control: Disentagling Sentiment and Substance"
giscus_comments: true
date: 2025-04-21
featured: true
authors:
  - name: Connor Chen*
    url: "https://www.linkedin.com/in/connorzchen/"
    affiliations:
      name: UC Berkeley
  - name: Wei-Lin Chiang*
    url: "https://infwinston.github.io/"
  - name: Tianle Li*
    url: "https://codingwithtim.github.io/"
  - name: Anastasios Angelopoulos*
    url: "http://angelopoulos.ai"
---

<h2> Introduction </h2>

You may have noticed that recent models on Chatbot Arena appear more emotionally expressive than their predecessors. But does this added sentiment actually improve their rankings on the leaderboard? Our [previous exploration](https://blog.lmarena.ai/blog/2024/style-control/) revealed that style — including formatting and length — plays a significant role in perceived model quality. Yet, we hypothesized that **style may go beyond layout**—perhaps sentiment and emojis are just as influential.

Enter **Sentiment Control**: a refined version of our original Style Control methodology that expands the feature set to include:

1. Emoji Count
2. Sentiment (Very Negative, Negative, Neutral, Positive, Very Positive, Positive)

Let’s see how this expanded definition of style affects model rankings and whether it boosts specific performance.

<h2> Methodology</h2>

Building upon our previous style control approach, we've now included additional style variables:

1. **Emoji Count**: Total number of emojis used in responses.

2. **Sentiment Scores**: Categorized into Very Negative, Negative, Neutral, Positive, Very Positive, Positive sentiments with Gemini-2.0-flash-001 using the following system prompt:

```
  You are a specialized tone classifier analyzing chatbot responses. You will be given a full chat log containing both user prompts and chatbot responses.  
  Your sole task is to classify the tone of the chatbot's responses, completely ignoring the user's messages and the inherent positivity or negativity of the conversation content itself. Instead, focus exclusively on the chatbot's style, language choice, and emotional expression.
  
  Output your classification of tone strictly in the following JSON format:
  
  {
    "tone": "very positive" | "positive" | "neutral" | "negative" | "very negative"
  }
  
  Tone Categories:
  - "very positive": Extremely enthusiastic, excited, highly encouraging, very cheerful.
  - "positive": Friendly, supportive, pleasant, slightly cheerful.
  - "neutral": Calm, factual, straightforward, objective, minimal emotion.
  - "negative": Slightly dismissive, mildly critical, frustrated, mildly negative.
  - "very negative": Strongly dismissive, clearly critical, angry, sarcastic, significantly negative.
  
  Important Guidelines:
  - Classify only the chatbot's responses.
  - Select exactly one tone category per conversation.
  - Ensure your output adheres precisely to the JSON schema provided.
  - Output the tone category in english
  
  Example output:
  {
    "tone": "very positive"
  }

```

We fit a logistic regression model using these new features to isolate each model’s intrinsic quality from stylistic embellishments.

<h2> Results </h2>

Controlling for sentiment and emoji usage yields notable shifts in rankings:

1. Models expressing more positive sentiment consistently receive higher user preference scores.  

2. Models known for strong stylistic appeal—like Grok-3 and Llama-4-Maverick—drop in rank, while those with more neutral or subdued styles—like Claude-3.7—rise noticeably.

<img src="/assets/img/blog/sentiment-control/overall_style-sentiment.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>

<p style="color:gray; text-align: center;">Figure 1. Overall Chatbot Arena ranking vs Style and Sentiment Control ranking</p>

<img src="/assets/img/blog/sentiment-control/style_style-sentiment.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>

<p style="color:gray; text-align: center;">Figure 2. Style Control ranking vs Style and Sentiment Control ranking
</p>

To illustrate the individual impact of each feature, we include the regression coefficients below:

| Feature         |  Coefficient  |
| -------------   | :-----------: |
| Answer Length   | 0.2381 |
| Markdown Header |   0.0290|
| Markdown List   |   0.0201    |
| Markdown Bold   |   0.0135    |
| Emoji Count     |   -0.0039    |
| Very Negative   |   -0.0034   |
| Negative        |   -0.0428    |
| Neutral         |   -0.0258    |
| Positive        |   0.0146    |
| Very Positive   |   0.0285    |

<h2> Ablation Tests </h2>

To disentangle sentiment effects from other style cues, we ran an ablation study removing formatting features and retaining only emoji count and sentiment.


| Feature         |  Coefficient  |
| -------------   | :-----------: |
| Emoji Count     |   -0.0048    |
| Very Negative   |  0.0008   |
| Negative        |  -0.0516    |
| Neutral         |  -0.0463    |
| Positive        |  0.0262    |
| Very Positive   |   0.0419    |

Key observations:

- **Positive sentiment maintains a strong positive effect**, even without formatting.  
- **Neutral and Negative tones are penalized**, highlighting a general preference for emotional expressiveness.


<img src="/assets/img/blog/sentiment-control/overall_sentiment.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>

<p style="color:gray; text-align: center;">Figure 2. Overall ranking vs Sentiment Control ranking, where we only control for emoji count and sentiment
</p>

<h2> Further Analysis </h2>

To better understand how sentiment impacts head-to-head outcomes, we computed win rates conditioned on sentiment labels. Each entry below represents the probability that a model with a given tone (row) beats a model with another tone (column):

|                  | Very Negative |  Negative  |  Neutral   |  Positive  | Very Positive |
|:----------------:|:-------------:|:----------:|:----------:|:----------:|:-------------:|
| **Very Negative**|    —-------   |  0.647845  |  0.539964  |  0.402597  |   0.430464    |
| **Negative**    |   0.352155    |  —-------  |  0.360911  |  0.293156  |   0.217092    |
| **Neutral**    |   0.460036    |  0.639089  |  —-------  |  0.414407  |   0.362715    |
| **Positive**  |   0.597403    |  0.706844  |  0.585593  |  —-------  |   0.449768    |
| **Very Positive**|   0.569536    |  0.782908  |  0.637285  |  0.550232  |   —-------    |

Several insights emerge:

- Very Negative beats Negative (65%) and Neutral (54%), which might seem surprising at first. This likely reflects scenarios where users prompt the chatbot to behave maliciously or humorously at their own expense (e.g., “Roast me” or “Make fun of me”). In such cases, chatbots that lean into the negativity—rather than deflect—are actually rewarded by users.

- Neutral tone underperforms across the board, losing to every other tone except Negative. This supports the idea that emotional expression, whether positive or negative, tends to be preferred over dry or purely factual responses. Neutral responses may be perceived as disengaged or unhelpful, especially in creative or open-ended tasks.

- As expected, Positive and Very Positive dominate, with Very Positive winning 78% of the time against Negative and 64% against Neutral.

This suggests that sentiment affects not only absolute rankings but also pairwise preferences in nuanced and sometimes counterintuitive ways.

<h2> Limitations and Future Directions </h2>

While Sentiment Control is an important advancement, our analysis remains observational. Unobserved confounders may still exist, such as intrinsic correlations between sentiment positivity and answer quality. Future work includes exploring other emotional and psychological dimensions of style.

We're eager for community contributions and further collaboration! 

Please see the link to the colab notebook below. We will be adding sentiment control soon to all categories of the leaderboard. We look forward to seeing how the community leverages these new insights. Stay tuned for more updates!

- [Colab Link](https://colab.research.google.com/drive/17Pf9xW2agVJbm_KGOLEet5OxB98CcjTP?usp=sharing)

## Reference

[1] Li et al. “Does Style Matter? Disentangling style and substance in Chatbot Arena”

## Citation

```bibtex
@misc{sentimentarena2025,
    title = {Introducing Sentiment Control: Disentagling Sentiment and Substance},
    url = {https://blog.lmarena.ai/blog/2025/sentiment-control/},
    author = {Connor Chen*, Wei-Lin Chiang*, Tianle Li*, Anastasios N. Angelopoulos*},
    month = {April},
    year = {2025}
}

@inproceedings{chiang2024chatbot,
  title={Chatbot arena: An open platform for evaluating llms by human preference},
  author={Chiang, Wei-Lin and Zheng, Lianmin and Sheng, Ying and Angelopoulos, Anastasios Nikolas and Li, Tianle and Li, Dacheng and Zhu, Banghua and Zhang, Hao and Jordan, Michael and Gonzalez, Joseph E and others},
  booktitle={Forty-first International Conference on Machine Learning},
  year={2024}
}
```