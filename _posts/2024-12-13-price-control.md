---
layout: distill
title: Does Price Matter?
description: Investigating the impact of price in Chatbot Arena
giscus_comments: true
date: 2024-12-13
featured: false
thumbnail: assets/img/blog/style_control/logo.png

authors:
  - name: Sophie Xie*
    url: "https://www.linkedin.com/in/sxie2/"
    affiliations:
      name: UC Berkeley
  - name: Anastasios Angelopoulos*
    url: "http://angelopoulos.ai"
  - name: Wei-Lin Chiang*
    url: "https://infwinston.github.io/"
  - name: Jackie Lian*
---

When deciding what model to use, a huge factor that people consider is _price_. What model gives me the best bang for my buck? What model is the most cost-effective?

Introducing price analysis to Chatbot Arena, to reveal the most cost-effective models!

The strongest models in Chatbot Arena are also the most expensive–for example, smaller models are cheaper to run, and thus can be offered at a lower price. In other words, the models are not playing on a level field. To understand which models are the best, we have to adjust for this fact.

One way to make this comparison is to plot the Pareto frontier between cost and performance. We have included this plot below, and it provides an information-rich signal about which models are best. **Check it out!**

<img src="/assets/img/blog/price_control/cost_performance_scatterplot.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%"/>

<p style="color:gray; text-align: center;">Figure 1. Pareto frontier plot between cost and performance. For an interactive version of the plot, check out Chatbot Arena's Arena Explorer tab </p>

Although the cost-performance Pareto frontier gives us a full description of the interactions between cost and performance, we might also want to perform an _explicit_ adjustment for price. In other words, can we check which models exhibit surprisingly strong performance, controlling for the effect of price? For this, we introduce a _price-controlled_ leaderboard. **See it below!**

### Overall Ranking + Price Control
<img src="/assets/img/blog/price_control/comparison_overall.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>

<p style="color:gray; text-align: center;">Figure 1. Overall Chatbot Arena ranking vs. Overall Chatbot Arena ranking where price is “controlled”.</p>

The changes in the leaderboard are relatively drastic, as the price of the model is a good predictor of model strength. Thus, the effect of a model’s identity, adjusted for its price, is generally smaller (hence the Arena Scores all go down) and the more expensive models drop more drastically than the cheaper ones. Models like Claude 3.5 Sonnet dropped in rankings, while models like Gemini-1.5-Flash-Exp-0827 increased in rankings. In the hard prompt subset, models like gpt-turbo-2024-04-09 decreased in rankings, while smaller, open-source models like athene-70b-0725 rose in rankings.

### Hard Prompt Ranking + Style Control
<img src="/assets/img/blog/price_control/comparison_hard.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 80%"/>
<p style="color:gray; text-align: center;">Figure 2. Hard Prompt category ranking vs Hard Prompt category ranking where price is "controlled". </p>

Before launching into the methodology, it is worth saying that as in our last post on [style control](https://blog.lmarena.ai/blog/2024/style-control/), this analysis does not give us a causal analysis without strong parametric assumptions. It’s more of showing an adjustment in rankings when controlled for price.

### Full Leaderboard with Price Control

The leaderboard is still in progress.

Please find the below links to leaderboard and colab notebook.

- Leaderboard [link](https://lmarena.ai/?leaderboard)
- Colab [link](https://colab.research.google.com/drive/15M9Kng_eeS0VglpGJHu_VyaDgKyU6XrO?usp=sharing)

## Methodology
To control for price, we gathered pricing data for each model. For publicly listed models, we used the available prices directly. For models without public pricing (typically smaller, open-source models), we estimated costs based on model size and a third-party pricing framework (i.e. together.ai). Battles involving models without public size or pricing data (e.g., Grok) were excluded from the dataset.

Our current pricing information is available here. We encourage and appreciate contributions of updated pricing data to keep our information accurate and current.

Similarly, to how [style](https://blog.lmarena.ai/blog/2024/style-control/) was controlled for when determining style’s effect on Arena score, we explicitly modeled price as an independent variable in our Chatbot Arena’s Bradley-Terry regression. We define our price feature as the difference between model A and model B’s total response price. More formally, our price feature would be expressed as: 

\begin{equation}
\text{normalize }\left(\frac{\text{total_response_price}\_A - \text{total_response_price}\_B}{\text{total_response_price}\_A + \text{total_response_price}\_B}\right)
\end{equation}

Where total_response_price is calculated by the number of tokens used in the model’s response multiplied by the model’s price per token.

We tested several different price features: 
1. Raw output token price
2. Total response price
3. Log of total response price
4. Indicators (1 if output_token_priceA > output_token_priceB else 0)

Below is a table of the coefficients for each price attribute across different methods of controlling price. We determined that the difference in total response price was the most effective gage in price.

<table style="border-collapse: collapse; width: 100%;">
  <tr>
    <th style="text-align: center; padding: 8px;"></th>
    <th style="text-align: center; padding: 8px;">Price</th>
    <th style="text-align: center; padding: 8px;">Total Response Price</th>
    <th style="text-align: center; padding: 8px;">Log Price</th>
    <th style="text-align: center; padding: 8px;">Indicator</th>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">Control All</td>
    <td style="text-align: center; padding: 8px;">0.022</td>
    <td style="text-align: center; padding: 8px;">0.117</td>
    <td style="text-align: center; padding: 8px;">-0.0</td>
    <td style="text-align: center; padding: 8px;">-0.0</td>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">Control Raw Price Only</td>
    <td style="text-align: center; padding: 8px;">0.01</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">Control Total Response Price Only</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">0.117</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">Control Log Price Only</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">0.0</td>
    <td style="text-align: center; padding: 8px;">-</td>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">Indicator Only</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">0.005</td>
  </tr>
</table>

## Ablation

We also controlled for style and price. Below is a table of the coefficients for each relevant price attribute and style attribute across different methods of controlling price and style. We can see that when controlling for both price and style attributes, length is still the dominant feature (which makes sense as length is a factor in total response price), and price and markdown features are second order. 

<table style="border-collapse: collapse; width: 100%;">
  <tr>
    <th style="text-align: center; padding: 8px;"></th>
    <th style="text-align: center; padding: 8px;">Total Response Price</th>
    <th style="text-align: center; padding: 8px;">Length</th>
    <th style="text-align: center; padding: 8px;">Markdown List</th>
    <th style="text-align: center; padding: 8px;">Markdown Header</th>
    <th style="text-align: center; padding: 8px;">Markdown Bold</th>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">Control All</td>
    <td style="text-align: center; padding: 8px;">0.055</td>
    <td style="text-align: center; padding: 8px;">0.243</td>
    <td style="text-align: center; padding: 8px;">0.034</td>
    <td style="text-align: center; padding: 8px;">0.019</td>
    <td style="text-align: center; padding: 8px;">0.024</td>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">Control Price Only</td>
    <td style="text-align: center; padding: 8px;">0.117</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">Control Length Only</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">0.270</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">Control Markdown Only</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">-</td>
    <td style="text-align: center; padding: 8px;">0.115</td>
    <td style="text-align: center; padding: 8px;">0.042</td>
    <td style="text-align: center; padding: 8px;">0.055</td>
  </tr>
</table>

Below we compare the rank changes between controlling for just price and just price and style. We can observe that some model rankings go up when controlled for price and style but go down when controlled only for price and vice versa. This aligns with the coefficients above, where style seems to have a more dominant effect on rankings than price.

**Table in progress**
<table style="border-collapse: collapse; width: 100%;">
  <tr>
    <th style="text-align: left; padding: 8px; width: 30%;">Model</th>
    <th style="text-align: center; padding: 8px; width: 25%;">Rank Diff (Length Only)</th>
    <th style="text-align: center; padding: 8px; width: 25%;">Rank Diff (Markdown Only)</th>
    <th style="text-align: center; padding: 8px; width: 20%;">Rank Diff (Both)</th>
  </tr>
<tr>
    <td style="text-align: left; padding: 8px;">chatgpt-4o-latest</td>
    <td style="text-align: center; padding: 8px;">1->1</td>
    <td style="text-align: center; padding: 8px;">1->1</td>
    <td style="text-align: center; padding: 8px;">1->1</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gemini-1.5-pro-exp-0827</td>
    <td style="text-align: center; padding: 8px;">2->2</td>
    <td style="text-align: center; padding: 8px;">2->2</td>
    <td style="text-align: center; padding: 8px;">2->2</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gemini-1.5-pro-exp-0801</td>
    <td style="text-align: center; padding: 8px;">2->2</td>
    <td style="text-align: center; padding: 8px;">2->2</td>
    <td style="text-align: center; padding: 8px;">2->2</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gpt-4o-2024-05-13</td>
    <td style="text-align: center; padding: 8px; color: green;">5->3</td>
    <td style="text-align: center; padding: 8px; color: green;">5->3</td>
    <td style="text-align: center; padding: 8px; color: green;">5->2</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">claude-3-5-sonnet-20240620</td>
    <td style="text-align: center; padding: 8px; color: green;">6->5</td>
    <td style="text-align: center; padding: 8px; color: green;">6->4</td>
    <td style="text-align: center; padding: 8px; color: green;">6->4</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gemini-advanced-0514</td>
    <td style="text-align: center; padding: 8px; color: green;">7->5</td>
    <td style="text-align: center; padding: 8px; color: red;">7->8</td>
    <td style="text-align: center; padding: 8px; color: green;">7->6</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">grok-2-2024-08-13</td>
    <td style="text-align: center; padding: 8px; color: red;">2->4</td>
    <td style="text-align: center; padding: 8px; color: red;">2->4</td>
    <td style="text-align: center; padding: 8px; color: red;">2->5</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">llama-3.1-405b-instruct</td>
    <td style="text-align: center; padding: 8px;">6->6</td>
    <td style="text-align: center; padding: 8px; color: green;">6->4</td>
    <td style="text-align: center; padding: 8px;">6->6</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gpt-4o-2024-08-06</td>
    <td style="text-align: center; padding: 8px; color: green;">7->6</td>
    <td style="text-align: center; padding: 8px; color: red;">7->8</td>
    <td style="text-align: center; padding: 8px; color: green;">7->6</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gpt-4-turbo-2024-04-09</td>
    <td style="text-align: center; padding: 8px; color: green;">11->8</td>
    <td style="text-align: center; padding: 8px; color: green;">11->8</td>
    <td style="text-align: center; padding: 8px; color: green;">11->9</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">claude-3-opus-20240229</td>
    <td style="text-align: center; padding: 8px; color: green;">16->14</td>
    <td style="text-align: center; padding: 8px; color: green;">16->8</td>
    <td style="text-align: center; padding: 8px; color: green;">16->10</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gemini-1.5-pro-api-0514</td>
    <td style="text-align: center; padding: 8px; color: green;">10->8</td>
    <td style="text-align: center; padding: 8px; color: red;">10->13</td>
    <td style="text-align: center; padding: 8px;">10->10</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gemini-1.5-flash-exp-0827</td>
    <td style="text-align: center; padding: 8px; color: red;">6->8</td>
    <td style="text-align: center; padding: 8px; color: red;">6->9</td>
    <td style="text-align: center; padding: 8px; color: red;">6->9</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gpt-4-1106-preview</td>
    <td style="text-align: center; padding: 8px; color: green;">16->14</td>
    <td style="text-align: center; padding: 8px; color: green;">16->8</td>
    <td style="text-align: center; padding: 8px; color: green;">16->11</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;"><strong>gpt-4o-mini-2024-07-18</strong></td>
    <td style="text-align: center; padding: 8px; color: red;">6->8</td>
    <td style="text-align: center; padding: 8px; color: red;">6->11</td>
    <td style="text-align: center; padding: 8px; color: red;">6->11</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gpt-4-0125-preview</td>
    <td style="text-align: center; padding: 8px; color: green;">17->14</td>
    <td style="text-align: center; padding: 8px; color: green;">17->12</td>
    <td style="text-align: center; padding: 8px; color: green;">17->13</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">mistral-large-2407</td>
    <td style="text-align: center; padding: 8px; color: green;">16->14</td>
    <td style="text-align: center; padding: 8px; color: green;">16->13</td>
    <td style="text-align: center; padding: 8px; color: green;">16->13</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">athene-70b-0725</td>
    <td style="text-align: center; padding: 8px;">16->16</td>
    <td style="text-align: center; padding: 8px; color: red;">16->17</td>
    <td style="text-align: center; padding: 8px; color: red;">16->17</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;"><strong>grok-2-mini-2024-08-13</strong></td>
    <td style="text-align: center; padding: 8px; color: red;">6->15</td>
    <td style="text-align: center; padding: 8px; color: red;">6->15</td>
    <td style="text-align: center; padding: 8px; color: red;">6->18</td>
  </tr>
  <tr>
    <td style="text-align: left; padding: 8px;">gemini-1.5-pro-api-0409-preview</td>
    <td style="text-align: center; padding: 8px; color: red;">11->16</td>
    <td style="text-align: center; padding: 8px; color: red;">11->21</td>
    <td style="text-align: center; padding: 8px; color: red;">11->18</td>
  </tr>
</table>

## Citation

```
@misc{stylearena2024,
    title = {Does Style Matter? Disentangling style and substance in Chatbot Arena},
    url = {https://blog.lmarena.ai/blog/2024/style-control/},
    author = {Tianle Li*, Anastasios Angelopoulos*, Wei-Lin Chiang*},
    month = {August},
    year = {2024}
}
```

---
