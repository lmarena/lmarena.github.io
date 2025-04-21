---
layout: distill
title: "Does Sentiment Matter Too?"
description: "Introducing Sentiment Control: Disentagling Sentiment and Substance"
giscus_comments: true
date: 2025-04-14
featured: true
thumbnail: assets/img/blog/search_arena/04142025/logo.png
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

## Introduction

You may have noticed that many of the recent models seem to employ stronger emotion compared to older models. To what extent does this increase the model rankings on the Chatbot Arena leaderboard? Our previous exploration disentangled style and substance, revealing that style significantly impacts model performance. However, we suspected that style might encompass more than markdown formatting and response length—emojis and sentiment could also play a pivotal role.
Today, we're excited to introduce **Sentiment Control**, an extended version of our style-controlled ranking [1] that includes:

1. Emoji Count
2. Sentiment (Very Negative, Negative, Neutral, Positive, Very Positive, Positive)

Let’s see how this expanded definition of style affects model rankings and whether it boosts specific performance.

<h3> Methodology: Emojis and Sentiment as Style Features </h3>

Building upon our previous style control approach [1], we've now included additional style variables:

1. **Emoji Count**: Total number of emojis used in responses.

2. **Sentiment Scores**: Categorized into Very Positive, Positive, Neutral sentiments with Gemini-2.0-flash-001 using the following system prompt:

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

We performed logistic regression, incorporating these additional features to isolate each model’s substantive performance from stylistic preferences.

<h3> Results </h3>

When controlling for emojis and sentiment, we observed significant changes in the leaderboard, particularly:

1. Sentiment Analysis indicated that models consistently employing a more positive sentiment gained higher user preference scores.

2. Models renowned for its style and positivity, such as Grok-3 and Llama-4-Maverick-03-26-Experimental dropped significantly in ranking, while models tat seemingly use less style and sentiment, such as Claude-3.7, significantly increased in ranking. 

<img src="/assets/img/blog/sentiment_control/overall_sentiment_and_style.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>

<p style="color:gray; text-align: center;">Figure 1. Overall Chatbot Arena ranking vs Overall Chatbot Arena ranking where our style features are being controlled.</p>

<img src="/assets/img/blog/sentiment_control/style_style_and_sentiment.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>

<p style="color:gray; text-align: center;">Figure 2. Style Control ranking vs Style and Sentiment Control ranking, where we now control for emoji count and sentiment
</p>

We provide the coefficients for each newly added feature to demonstrate their impact clearly:

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

<h3> Ablation Tests </h3>

We apply sentiment control without style control. The corresponding coefficients are:

| Feature         |  Coefficient  |
| -------------   | :-----------: |
| Emoji Count     |   -0.0048    |
| Very Negative   |  0.0008   |
| Negative        |  -0.0516    |
| Neutral         |  -0.0463    |
| Positive        |  0.0262    |
| Very Positive   |   0.0419    |

<h3> Further Analysis </h3>

Conditioned on the sentiment tones, the win rates are as follows

|                  | Very Negative |  Negative  |  Neutral   |  Positive  | Very Positive |
|:----------------:|:-------------:|:----------:|:----------:|:----------:|:-------------:|
| **Very Negative**|    —-------   |  0.647845  |  0.539964  |  0.402597  |   0.430464    |
| **Negative**    |   0.352155    |  —-------  |  0.360911  |  0.293156  |   0.217092    |
| **Neutral**    |   0.460036    |  0.639089  |  —-------  |  0.414407  |   0.362715    |
| **Positive**  |   0.597403    |  0.706844  |  0.585593  |  —-------  |   0.449768    |
| **Very Positive**|   0.569536    |  0.782908  |  0.637285  |  0.550232  |   —-------    |


<h3> Limitations and Future Directions </h3>

While Sentiment Control is an important advancement, our analysis remains observational. Unobserved confounders may still exist, such as intrinsic correlations between sentiment positivity and answer quality. Future work includes exploring other emotional and psychological dimensions of style.

We're eager for community contributions and further collaboration! 

## Reference

[1] Li et al. “Does Style Matter? Disentangling style and substance in Chatbot Arena”

We look forward to seeing how the community leverages these new insights. Stay tuned for more updates!

## Citation

```bibtex
@misc{searcharena2025,
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