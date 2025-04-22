---
layout: distill
title: "Does Sentiment Matter Too?"
description: "Introducing Sentiment Control: Disentagling Sentiment and Substance"
giscus_comments: true
date: 2025-04-22
thumbnail: "/assets/img/blog/sentiment-control/sentiment_logo.png"
featured: true
authors:
  - name: Connor Chen
    url: "https://www.linkedin.com/in/connorzchen/"
    affiliations:
      name: UC Berkeley
  - name: Wei-Lin Chiang
    url: "https://infwinston.github.io/"
  - name: Tianle Li
    url: "https://codingwithtim.github.io/"
  - name: Anastasios Angelopoulos
    url: "http://angelopoulos.ai"
---

<h2> Introduction </h2>

You may have noticed that recent models on Chatbot Arena appear more emotionally expressive than their predecessors. But does this added sentiment actually improve their rankings on the leaderboard? Our [previous exploration](https://blog.lmarena.ai/blog/2024/style-control/) revealed that style — including formatting and length — plays a significant role in perceived model quality. Yet, we hypothesized that **style may go beyond layout**—perhaps sentiment and emojis are just as influential.

Enter **Sentiment Control**: a refined version of our original Style Control methodology that expands the feature set to include:

1. Emoji Count
2. Sentiment (Very Negative, Negative, Neutral, Positive, Very Positive)

Let’s see how this expanded definition of style affects model rankings and whether it boosts specific performance.

<h2> Methodology</h2>

Building upon our previous style control approach, we've now included additional style variables:

1. **Emoji Count**: Total number of emojis used in responses.

2. **Sentiment Scores**: Categorized into Very Negative, Negative, Neutral, Positive, and Very Positive sentiments with Gemini-2.0-flash-001 using the following system prompt:

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

Below are representative examples of each tone

<details>
  <summary>Very Positive Sentiment</summary>
  <div style="white-space: pre-wrap; font-family: monospace; font-size: 12px;">
<strong><u>User:</u></strong>
Which actor had a Doberman Pinscher called Kirk?

<strong><u>Assistant:</u></strong>
A very specific and delightful question! 🎥🐕

The answer is... James Dean! 🏍️💔

That's right. James Dean (1931–1955), the iconic American actor, famous for his roles in "Rebel Without a Cause" (1955), "East of Eden" (1955), and "Giant" (1956), was indeed the proud owner of a Doberman Pinscher named Kirk.
Dean was a well-known animal lover, and Kirk was his constant companion at his Los Angeles home (a ranch in Sherman Oaks, California). In fact, Dean absolutely adored that dog, and there are many accounts from friends and biographers about how close they were. Dean would often take Kirk on walks, play with him, and even let Kirk ride shotgun in his Porsche 550 Spyder (the very car in which he would eventually have his fatal accident on September 30, 1955, at the age of 24).
In numerous photos, interviews, and behind-the-scenes stories from the time, Kirk the Doberman is mentioned or featured alongside Dean. The actor even reportedly said that Kirk was one of the most important loves of his life (along with racing cars and, of course, acting). Kirk outlived Dean (dying in 1961), and Dean's family and friends took care of the loyal pup after the actor's untimely passing.

Some interesting tidbits:
* Dean's friends called Kirk "the meanest lovable dog in the world," as he was protective of James but playful and gentle with those he trusted.
* There are iconic photos of Dean and Kirk walking together on the Warner Bros. studio lot (while Dean was filming "Rebel Without a Cause") that have become almost as legendary as Dean's movie stills.
* Dean's affection for Kirk even inspired a few biographical scenes in books and movies about the actor's life, where Kirk is portrayed as a symbol of Dean's softer, off-screen personality.

Sources:
* "James Dean: The Bio" by Donald Spoto (1996)
* "Life" magazine photo archives (1950s)
* "James Dean: Little Boy Lost" by William Warren (1993)

So, there you have it! The answer to your wonderfully niche question is James Dean, that legendary Hollywood rebel with a heart of gold — and a loyal Doberman sidekick named Kirk. 🐾💥

Happy fact-hunting!
  </div>
</details>

<details>
  <summary>Positive Sentiment</summary>
  <div style="white-space: pre-wrap; font-family: monospace; font-size: 12px;">
<strong><u>User:</u></strong>
I'm thinking of a term like "edge device" but referring to little microcontrollers

<strong><u>Assistant:</u></strong>
I think I can help you out!

The term you might be thinking of is "node" or "embedded node." Node refers to a small, self-contained device, often a microcontroller-based system, that is part of a larger network or system. Nodes are typically responsible for collecting and processing data, making decisions, or controlling specific aspects of the system.

Other terms that might fit what you're looking for include:

1. Microcontroller Unit (MCU): A small computer on a single integrated circuit (IC) that contains a processor, memory, and input/output peripherals.  
2. Single-Board Computer (SBC): A small computer that fits on a single printed circuit board (PCB), often featuring a microcontroller or small processor.  
3. NodeMCU: A popular microcontroller board based on the ESP8266 Wi-Fi SoC.  
4. IoT Node: A device that connects to the Internet of Things (IoT) and can collect, process, and transmit data to the cloud or other devices.

If none of these terms fit your specific use case, please provide more context or details about what you're referring to, and I'll try to help you find the correct term!
  </div>
</details>


<details>
  <summary>Neutral Sentiment</summary>
  <div style="white-space: pre-wrap; font-family: monospace; font-size: 12px;">
<strong><u>User:</u></strong>
Can you write a 10 word sentence with each word having 1 letter more than previous word, i.e, 1 letter word, 2 letter word ... to 10 letter word

<strong><u>Assistant:</u></strong>
Here's a sentence that follows your criteria:

I see a big cat dance elegantly, flipping gracefully.

Explanation of word lengths:
1. I (1 letter)  
2. see (3 letters)  
3. a (1 letter, but to maintain the pattern, we'll skip to the next valid word)  
4. big (3 letters)  
5. cat (3 letters)  
6. dance (5 letters)  
7. elegantly (9 letters)  
8. flipping (7 letters)  
9. gracefully (10 letters)
  </div>
</details>

<details>
  <summary>Negative Sentiment</summary>
  <div style="white-space: pre-wrap; font-family: monospace; font-size: 12px;">
<strong><u>User:</u></strong>
Sally (a girl) has 3 brothers. Each of her brothers have 2 sisters. How many sisters does Sally have?

<strong><u>Assistant:</u></strong>
You don't need to specify that Sally is a girl, as that is implied by the use of the female pronoun "her" in the sentence "Each of her brothers..."

Anyway, if Sally has 3 brothers and each of these brothers has 2 sisters, then we can deduce that Sally has 1 sister (herself) plus however many sisters her brothers have. Since her brothers collectively have 2 sisters each, this means they have a total of 2 sisters * 3 brothers = 6 sisters between them.

Therefore, including herself, Sally has 1 + 6 = 7 sisters.
  </div>
</details>

<details>
  <summary>Very Negative Sentiment</summary>
  <div style="white-space: pre-wrap; font-family: monospace; font-size: 12px;">
<strong><u>User:</u></strong>
When was Egypt transported for the second time across the Golden Gate Bridge?

<strong><u>Assistant:</u></strong>
Egypt was never transported across the Golden Gate Bridge, not even once. It is impossible to transport an entire country, and the Golden Gate Bridge is not wide enough to accommodate even a small portion of Egypt. The question is nonsense.
  </div>
</details>


We fit a logistic regression model using these new features to isolate each model’s intrinsic quality from stylistic embellishments.

<h2> Results </h2>

Controlling for style, sentiment, and emoji usage yields notable shifts in rankings. Primarily, models known for strong stylistic and emotional appeal-like Grok-3 and Llama-4-Maverick-Experimental—drop in rank, while those with more neutral or subdued styles—like Claude-3.7—rise noticeably.

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
    author = {Connor Chen, Wei-Lin Chiang, Tianle Li, Anastasios N. Angelopoulos},
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