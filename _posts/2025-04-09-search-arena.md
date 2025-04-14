---
layout: distill
title: "Introducing the Search Arena: Evaluating Search-Enabled AI"
description: 
giscus_comments: true
date: 2025-04-13
featured: true
thumbnail: assets/img/blog/search_arena/04092025/logo.png
authors:
  - name: Mihran Miroyan*
    url: "https://mmiroyan.github.io"
    affiliations:
      name: UC Berkeley
  - name: Tsung-Han Wu*
    url: "https://tsunghan-wu.github.io"
  - name: Logan King
    url: "https://www.linkedin.com/in/logan-king-8a4267281"
  - name: Tianle Li
    url: "https://codingwithtim.github.io"
  - name: Anastasios N. Angelopoulos†
    url: "http://angelopoulos.ai"
  - name: Wei-Lin Chiang†
    url: "https://infwinston.github.io"
  - name: Joseph E. Gonzalez†
    url: "https://people.eecs.berkeley.edu/~jegonzal"
---

## TL;DR

1. We introduce **Search Arena**, a crowdsourced in-the-wild evaluation platform for search-augmented LLM systems based on human preference. Unlike LM-Arena or SimpleQA, our data focuses on current events and diverse real-world use cases (see [Sec. 1](#why-search-arena)).
2. Based on 7k human votes (03/18–04/13), **Gemini-2.5-Pro-Grounding** and **Perplexity-Sonar-Reasoning-Pro** are at the top, followed by the rest of Perplexity's Sonar models, Gemini-2.0-Flash-Grounding, and OpenAI's web search API models. Standardizing citation styles had minimal effect on rankings (see [Sec. 2](#leaderboard)).
3. Three features show strong positive correlation with human preference: response length, citation count, and citing specific web sources like YouTube and online forum/blogs (see [Sec. 3](#analyses)).
4. We open-sourced our dataset ([🤗 search-arena-7k](https://huggingface.co/datasets/lmarena-ai/search-arena-v1-7k)) and code ([⚙️ Colab notebook](https://colab.research.google.com/drive/1Vb92s3O9RZ0aOs5c953SzaB2HniVcX4_)) for leaderboard analysis. Try [🌐 Search Arena](https://lmarena.ai/?search) and see [Sec. 4](#futurework) for what's next.

<div id="fig1">
  <iframe src="{{ '/assets/img/blog/search_arena/04092025/main_bootstrap_elo_rating.html' }}" frameborder='0' scrolling='no' height="400px" width="100%"></iframe>
</div>

<p style="color:gray; text-align: center;">Figure 1. Search Arena leaderboard.</p>

<h2 id="why-search-arena">1. Why Search Arena?</h2>

Web search is undergoing a major transformation. Search-augmented LLM systems integrate dynamic real-time web data with the reasoning, problem-solving, and question-answering capabilities of LLMs. These systems go beyond traditional retrieval, enabling richer human–web interaction. The rise of models like Perplexity’s Sonar series, OpenAI's GPT-Search, and Google's Gemini-Grounding highlights the growing impact of search-augmented LLM systems.

But how should these systems be evaluated? Static benchmarks like SimpleQA focus on factual accuracy on challenging questions, but that’s only one piece. These systems are used for diverse tasks—coding, research, recommendations—so evaluations must also consider how they retrieve, process, and present information from the web. Understanding this requires studying how humans use and evaluate these systems in the wild.

To this end, we developed search arena, aiming to (1) enable crowd-sourced evaluation of search-augmented LLMs and (2) release a diverse, in-the-wild dataset of user–system interactions.

Since our [initial launch](https://x.com/lmarena_ai/status/1902036561119899983) on March 18th, we've collected over 11k votes across 10+ models. We then filtered this data to construct 7k battles with user votes ([🤗 search-arena-7k](https://huggingface.co/datasets/lmarena-ai/search-arena-v1-7k)) and calculated the leaderboard with this [⚙️ Colab notebook](https://colab.research.google.com/drive/1Vb92s3O9RZ0aOs5c953SzaB2HniVcX4_). Below, we provide details on the collected data and the supported models.

<h3>A. Data</h3>

<b>Data Filtering and Citation Style Control.</b> Each model provider uses a unique inline citation style, which can potentially compromise model anonymity. However, citation formatting impacts how information is presented to and processed by the user, impacting their final votes. To balance these considerations, we introduced <em>"style randomization"</em>: responses are displayed either in a standardized format or in the original format (i.e., the citation style agreed upon with each model provider).
<details>
  <summary>Click to view standardized and original citation styles for each provider.</summary>
  <div style="margin-top: 1rem;">
    <img 
      src="/assets/img/blog/search_arena/04092025/gemini_formatting_example.png" 
      alt="Google's Gemini citation formatting comparison"
      style="width: 100%; max-width: 1000px; border: 1px solid #ccc; border-radius: 8px;"
    />
  </div>
  <p>(1) Google's Gemini Formatting: standardized (left), original (right)</p>
  <div style="margin-top: 1rem;">
    <img 
      src="/assets/img/blog/search_arena/04092025/ppl_formatting_example.png" 
      alt="Perplexity's Sonar citation formatting comparison"
      style="width: 100%; max-width: 1000px; border: 1px solid #ccc; border-radius: 8px;"
    />
  </div>
  <p>(2) Perplexity’s Formatting: standardized (left), original (right)</p>
  <div style="margin-top: 1rem;">
    <img 
      src="/assets/img/blog/search_arena/04092025/gpt_formatting_example.png" 
      alt="OpenAI's GPT citation formatting comparison"
      style="width: 100%; max-width: 1000px; border: 1px solid #ccc; border-radius: 8px;"
    />
  </div>
  <p>(3) OpenAI's Formatting: standardized (left), original (right)</p>
</details>

This approach mitigates de-anonymization while allowing us to analyze how citation style impacts user votes (see the citation analyses subsection [here](#citation_analyses)). After updating and standardizing citation styles in collaboration with providers, we filtered the dataset to include only battles with the updated styles, resulting in ~7,000 clean samples for leaderboard calculation and further analysis.

<b>Comparison to Existing Benchmarks.</b> To highlight what makes Search Arena unique, we compare our collected data to [LM-Arena](https://arxiv.org/abs/2403.04132) and [SimpleQA](https://arxiv.org/abs/2411.04368). As shown in [Fig. 2](#fig2), Search Arena prompts focus more on current events, while LM-Arena emphasizes coding/writing, and SimpleQA targets narrow factual questions (e.g., dates, names, specific domains). [Tab. 1](#tab1) shows that Search Arena features longer prompts, longer responses, more turns, and more languages compared to SimpleQA—closer to natural user interactions seen in LM-Arena.

<div id="fig2">
  <iframe src="{{ '/assets/img/blog/search_arena/04092025/topical_distribution_plot.html' }}" frameborder='0' scrolling='no' height="450px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 2. Top-5 topic distributions across Search Arena, LM Arena, and SimpleQA. We use 
  <a href="https://blog.lmarena.ai/blog/2025/arena-explorer/">Arena Explorer (Tang et al., 2025)</a> to extract topic clusters from the three datasets.</p>


<table id="tab1" style="margin: 0 auto; border-collapse: collapse; text-align: center;">
  <thead>
    <tr>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;"></th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Search Arena</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">LM Arena</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">SimpleQA</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 8px;">Languages</td>
      <td style="padding: 8px;">10+ (EN, RU, CN, …)</td>
      <td style="padding: 8px;">10+ (EN, RU, CN, …)</td>
      <td style="padding: 8px;">English Only</td>
    </tr>
    <tr>
      <td style="padding: 8px;">Avg. Prompt Length (#words)</td>
      <td style="padding: 8px;">88.08</td>
      <td style="padding: 8px;">102.12</td>
      <td style="padding: 8px;">16.32</td>
    </tr>
    <tr>
      <td style="padding: 8px;">Avg. Response Length (#words)</td>
      <td style="padding: 8px;">344.10</td>
      <td style="padding: 8px;">290.87</td>
      <td style="padding: 8px;">2.24</td>
    </tr>
    <tr>
      <td style="padding: 8px;">Avg. #Conversation Turns</td>
      <td style="padding: 8px;">1.46</td>
      <td style="padding: 8px;">1.37</td>
      <td style="padding: 8px;">N/A</td>
    </tr>
  </tbody>
</table>

<p style="color:gray; text-align: center;">
Table 1. Prompt language distribution, average prompt length, average response length, and average number of turns in Search Arena, LM Arena, and SimpleQA datasets.</p>

<h3>B. Models</h3>

Search Arena currently supports 11 models from three providers: Perplexity, Gemini, and OpenAI. Unless specified otherwise, we treat the same model with different citation styles (original vs. standardized) as a single model. [Fig. 3](#fig3) shows the number of battles collected per model used in this iteration of the leaderboard.

By default, we use each provider’s standard API settings. For Perplexity and OpenAI, this includes setting the `search_context_size` parameter to `medium`, which controls how much web content is retrieved and passed to the model. We also explore specific features by changing the default settings: (1) For OpenAI, we test their geolocation feature in one model variant by passing a country code extracted from the user’s IP address. (2) For Perplexity and OpenAI, we include variants with `search_context_size` set to `high`. Below is the list of models currently supported in Search Arena:

<table style="width:100%; border-collapse: collapse; text-align: left;">
  <thead>
    <tr>
      <th style="border-bottom: 1px solid #ccc; padding: 8px;">Provider</th>
      <th style="border-bottom: 1px solid #ccc; padding: 8px;">Model</th>
      <th style="border-bottom: 1px solid #ccc; padding: 8px;">Base model</th>
      <th style="border-bottom: 1px solid #ccc; padding: 8px;">Details</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="5" style="padding: 8px;">Perplexity</td>
      <td style="padding: 8px;"><code>ppl-sonar</code></td>
      <td style="padding: 8px;"><a href="https://docs.perplexity.ai/guides/models/sonar" target="_blank">sonar</a></td>
      <td style="padding: 8px;">Default config</td>
    </tr>
    <tr>
      <td style="padding: 8px;"><code>ppl-sonar-pro</code></td>
      <td style="padding: 8px;"><a href="https://docs.perplexity.ai/guides/models/sonar-pro" target="_blank">sonar-pro</a></td>
      <td style="padding: 8px;">Default config</td>
    </tr>
    <tr>
      <td style="padding: 8px;"><code>ppl-sonar-pro-high</code></td>
      <td style="padding: 8px;"><a href="https://docs.perplexity.ai/guides/models/sonar-pro" target="_blank">sonar-pro</a></td>
      <td style="padding: 8px;"><code>search_context_size</code> set to <code>high</code></td>
    </tr>
    <tr>
      <td style="padding: 8px;"><code>ppl-sonar-reasoning</code></td>
      <td style="padding: 8px;"><a href="https://docs.perplexity.ai/guides/models/sonar-reasoning" target="_blank">sonar-reasoning</a></td>
      <td style="padding: 8px;">Default config</td>
    </tr>
    <tr>
      <td style="padding: 8px;"><code>ppl-sonar-reasoning-pro-high</code></td>
      <td style="padding: 8px;"><a href="https://docs.perplexity.ai/guides/models/sonar-reasoning-pro" target="_blank">sonar-reasoning-pro</a></td>
      <td style="padding: 8px;"><code>search_context_size</code> set to <code>high</code></td>
    </tr>
    <tr>
      <td rowspan="2" style="padding: 8px;">Gemini</td>
      <td style="padding: 8px;"><code>gemini-2.0-flash-grounding</code></td>
      <td style="padding: 8px;"><a href="https://ai.google.dev/gemini-api/docs/models#gemini-2.0-flash" target="_blank">gemini-2.0-flash</a></td>
      <td style="padding: 8px;">With <code>Google Search</code> tool enabled</td>
    </tr>
    <tr>
      <td style="padding: 8px;"><code>gemini-2.5-pro-grounding</code></td>
      <td style="padding: 8px;"><a href="https://ai.google.dev/gemini-api/docs/models#gemini-2.5-pro-preview-03-25" target="_blank">gemini-2.5-pro-exp-03-25</a></td>
      <td style="padding: 8px;">With <code>Google Search</code> tool enabled</td>
    </tr>
    <tr>
      <td rowspan="4" style="padding: 8px;">OpenAI<sup>†</sup></td>
      <td style="padding: 8px;"><code>api-gpt-4o-mini-search-preview</code></td>
      <td style="padding: 8px;"><a href="https://platform.openai.com/docs/models/gpt-4o-mini-search-preview" target="_blank">gpt-4o-mini-search-preview</a></td>
      <td style="padding: 8px;">Default config</td>
    </tr>
    <tr>
      <td style="padding: 8px;"><code>api-gpt-4o-search-preview</code></td>
      <td style="padding: 8px;"><a href="https://platform.openai.com/docs/models/gpt-4o-search-preview" target="_blank">gpt-4o-search-preview</a></td>
      <td style="padding: 8px;">Default config</td>
    </tr>
    <tr>
      <td style="padding: 8px;"><code>api-gpt-4o-search-preview-high</code></td>
      <td style="padding: 8px;"><a href="https://platform.openai.com/docs/models/gpt-4o-search-preview" target="_blank">gpt-4o-search-preview</a></td>
      <td style="padding: 8px;"><code>search_context_size</code> set to <code>high</code></td>
    </tr>
    <tr>
      <td style="padding: 8px;"><code>api-gpt-4o-search-preview-high-loc</code></td>
      <td style="padding: 8px;"><a href="https://platform.openai.com/docs/models/gpt-4o-search-preview" target="_blank">gpt-4o-search-preview</a></td>
      <td style="padding: 8px;"><code>user_location</code> feature enabled</td>
    </tr>
  </tbody>
</table>

<p style="color:gray; font-size: 14px; text-align: center; margin-top: 8px;">
  Table 2. Models currently supported in Search Arena.
</p>

<p style="color:gray; font-size: 13px; max-width: 700px; margin: 0 auto;">
  <sup>†</sup>We evaluate OpenAI’s <a href="https://platform.openai.com/docs/guides/tools-web-search?api-mode=chat" target="_blank">web search API</a>, which is different from the search feature in the ChatGPT product.
</p>

<div id="fig3">
  <iframe src="{{ '/assets/img/blog/search_arena/04092025/main_battle_count.html' }}" frameborder='0' scrolling='no' height="400px" width="100%"></iframe>
</div>

<p style="color:gray; text-align: center;">Figure 3. Battle counts across 11 models. The distribution is not even as we (1) added models after the first release and (2) filtered votes (described above).</p>

<h2 id="leaderboard">2. Leaderboard</h2>

We begin by analyzing pairwise win rates—i.e., the proportion of wins of model A over model B in head-to-head battles. This provides a direct view of model performance differences without aggregating scores. The results are shown in [Fig. 4](#fig4), along with the following observations:

- `gemini-2.5-pro-grounding` and `ppl-sonar-reasoning-pro-high` outperform all other models by a large margin. In direct head-to-head battles `ppl-sonar-reasoning-pro-high` has a slight advantage (53% win rate).
- <code>ppl-sonar-reasoning</code> outperforms the rest of Perplexity's models. There's no clear difference between <code>ppl-sonar-pro</code> and <code>ppl-sonar-pro-high</code> (52%/48% win rate), and even <code>ppl-sonar</code> beats <code>ppl-sonar-pro-high</code> (60% win rate). This suggests that increasing search context does not necessarily improve performance and may even degrade it.
- Within OpenAI’s models, larger search context does not significantly improve performance (`api-gpt-4o-search` vs `api-gpt-4o-search-high`). While adding user location improves performance in head-to-head battles (58% win rate of `api-gpt-4o-search-high-loc` over `api-gpt-4o-search-high`), location-enabled version ranks lower in the leaderboard.


<div id="fig4">
  <iframe src="{{ '/assets/img/blog/search_arena/04092025/main_pairwise_average_win_rate.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>

<p style="color:gray; text-align: center;">Figure 4. Pairwise win rates (Model A wins Model B), excluding <code>tie</code> and <code>tie (bothbad)</code> votes.</p>

Now we build the leaderboard! Consistent with [LM Arena](https://lmarena.ai/), we apply the Bradley-Terry (BT) model to compute model scores. The resulting BT coefficients are then translated to Elo scale, with the final model scores and rankings displayed in [Fig. 1](#fig1) and [Tab. 3](#tab3). The confidence intervals are still wide, which means the leaderboard hasn’t fully settled and there’s still some uncertainty. But clear performance trends are already starting to emerge. Consistent with the pairwise win rate analysis in the previous section, `gemini-2.5-pro-grounding` and `ppl-sonar-reasoning-pro-high` top the leaderboard by a substantial margin. They are followed by models from the `ppl-sonar` family, with `ppl-sonar-reasoning` leading the group. Then comes `gemini-2.0-flash-grounding`, and finally OpenAI models with `api-gpt-4o-search` based models outperforming `api-gpt-4o-mini-search`. Generally, users prefer responses from reasoning models (top 3 on the leaderboard).

<table id="tab2" style="width: 100%; border-collapse: collapse; text-align: center;">
  <thead>
    <tr>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Rank</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Model</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Arena Score</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">95% CI</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Votes</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>1</td><td><code>gemini-2.5-pro-grounding</code></td><td>1142</td><td>+14/-17</td><td>1,215</td><td>Google</td></tr>
    <tr><td>1</td><td><code>ppl-sonar-reasoning-pro-high</code></td><td>1136</td><td>+21/-19</td><td>861</td><td>Perplexity</td></tr>
    <tr><td>3</td><td><code>ppl-sonar-reasoning</code></td><td>1097</td><td>+11/-17</td><td>1,644</td><td>Perplexity</td></tr>
    <tr><td>3</td><td><code>ppl-sonar</code></td><td>1072</td><td>+15/-17</td><td>1,208</td><td>Perplexity</td></tr>
    <tr><td>3</td><td><code>ppl-sonar-pro-high</code></td><td>1071</td><td>+15/-10</td><td>1,364</td><td>Perplexity</td></tr>
    <tr><td>4</td><td><code>ppl-sonar-pro</code></td><td>1066</td><td>+12/-13</td><td>1,214</td><td>Perplexity</td></tr>
    <tr><td>7</td><td><code>gemini-2.0-flash-grounding</code></td><td>1028</td><td>+16/-16</td><td>1,193</td><td>Google</td></tr>
    <tr><td>7</td><td><code>api-gpt-4o-search</code></td><td>1000</td><td>+13/-19</td><td>1,196</td><td>OpenAI</td></tr>
    <tr><td>7</td><td><code>api-gpt-4o-search-high</code></td><td>999</td><td>+13/-14</td><td>1,707</td><td>OpenAI</td></tr>
    <tr><td>8</td><td><code>api-gpt-4o-search-high-loc</code></td><td>994</td><td>+14/-14</td><td>1,226</td><td>OpenAI</td></tr>
    <tr><td>11</td><td><code>api-gpt-4o-mini-search</code></td><td>961</td><td>+16/-15</td><td>1,172</td><td>OpenAI</td></tr>
  </tbody>
</table>

<p style="color:gray; text-align: center;">
  Table 3. Search Arena leaderboard.
</p>


<h3 id="citation_analyses">Citation Style Analysis</h3>

Having calculated the main leaderboard, we can now analyze the effect of citation style on user votes and model rankings. For each battle, we record model A’s and B’s citation style — original (agreed upon with the providers) vs standardized.

First, following the method in [(Li et al., 2024)](https://blog.lmarena.ai/blog/2024/style-control/), we apply style control and use the citation style indicator variable (1 if standardized, 0 otherwise) as an additional feature in the BT model. The resulting model scores and rankings do not change significantly from [the main leaderboard](#fig1). Although the leaderboard does not change, the corresponding coefficient is positive (0.044) and statistically significant (p<0.05), implying that standardization of citation style has a positive impact on model score.

We further investigate the effect of citation style on model performance, by treating each combination of model and citation style as a distinct model (e.g., `api-gpt-4o-search` with original style will be different from `api-gpt-4o-search` with standardized citation style). [Fig. 5](#fig5) shows the change in the arena score between the two styles of each model. Overall, we observe increase or no change in score with standardized citations across all models except `gemini-2.0-flash`. However, the differences remain within the confidence intervals (CI), and we will continue collecting data to assess whether the trend converges toward statistical significance.

<div id="fig5">
  <iframe src="{{ '/assets/img/blog/search_arena/04092025/og_vs_st.html' }}" frameborder='0' scrolling='no' height="400px" width="100%"></iframe>
</div>

<p style="color:gray; text-align: center;">Figure 5. Change in arena score for original vs standardized citation style for each model.</p>

<h2 id="analyses">3. Three Secrets Behind a WIN</h2>

After reviewing the leaderboard—and showing that the citation style doesn’t impact results all that much—you might be wondering: *What features contribute to the model’s win rate?*

To answer this, we used the framework in [(Zhong et al., 2022)](https://arxiv.org/abs/2201.12323), a method that automatically proposes and tests hypotheses to identify key differences between two groups of natural language texts—in this case, human-preferred and rejected model outputs. In our implementation, we asked the model to generate 25 hypotheses and evaluate them, leading to the discovery of *three distinguishing factors* with statistically significant p-values, shown in [Tab. 4](#tab4).


<table id="tab4" style="width: 100%; border-collapse: collapse; text-align: left;">
  <thead>
    <tr>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Feature</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">p-value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 8px;">References to specific known entities or platforms</td>
      <td style="padding: 8px;">0.0000114</td>
    </tr>
    <tr>
      <td style="padding: 8px;">Frequent use of external citations and hyperlinks</td>
      <td style="padding: 8px;">0.01036</td>
    </tr>
    <tr>
      <td style="padding: 8px;">Longer, more in-depth answers</td>
      <td style="padding: 8px;">0.04761</td>
    </tr>
  </tbody>
</table>

<p style="color:gray; text-align: center;">
  Table 4. Candidate key factors between the winning and losing model outputs.
</p>


### Model Characteristics

Guided by the above findings, we analyze how these features vary across models and model families. 

[Fig. 6 (left)](#fig6) shows the distribution of average response length across models. Gemini models are generally the most verbose—<code>gemini-2.5-pro-grounding</code>, in particular, produces responses nearly twice as long as most Perplexity or OpenAI models. Within the Perplexity and OpenAI families, response length is relatively consistent, with the exception of `ppl-sonar-reasoning-pro-high`. [Fig. 6 (right)](#fig6) shows the average number of citations per response. Sonar models cite the most, with <code>ppl-sonar-pro-high</code> citing 2-3x more than Gemini models. OpenAI models cite the fewest sources (2-2.5) with little variation within the group.

<div id="fig6">
  <iframe src="{{ '/assets/img/blog/search_arena/04092025/lenght_cit_features.html' }}" frameborder='0' scrolling='no' height="400px" width="100%"></iframe>
</div>

<p style="color:gray; text-align: center;">Figure 6. Average response length (left) and number of citations (right) per model.</p>

In addition to number of citations and response length, we also study the common <em>source domains</em> cited by each model. We categorize retrieved URLs into ten types: YouTube, News (U.S. and foreign), Community & Blogs (e.g., Reddit, Medium), Wikipedia, Tech & Coding (e.g., Stack Overflow, GitHub), Government & Education, Social Media, Maps, and Academic Journals. [Fig. 7](#fig7) shows the domain distribution across providers in two settings: (1) all conversations, and (2) a filtered subset focused on Trump-related prompts. The case study helps examine how models behave when responding to queries on current events. Here are three interesting findings:
1. All models favor authoritative sources (e.g., Wikipedia, <code>.edu</code>, <code>.gov</code> domains).
2. OpenAI models heavily cite news sources—51.3% overall and 87.3% for Trump-related prompts.
3. Gemini prefers community/blog content, whereas Perplexity frequently cites YouTube. Perplexity also strongly favors U.S. news sources over foreign ones (3x more often).

<div id="fig7">
  <iframe src="{{ '/assets/img/blog/search_arena/04092025/domain_citations.html' }}" frameborder='0' scrolling='no' height="400px" width="100%"></iframe>
</div>

<p style="color:gray; text-align: center;">Figure 7. Distribution of cited domain categories across models. Use the dropdown to switch between all prompts and a filtered Trump-related subset.</p> 

### Control Experiments

After analyzing model characteristics such as response length, citation count, and citation sources, we revisited the Bradley-Terry model with these features as additional control variables [(Li et al., 2024)](https://blog.lmarena.ai/blog/2024/style-control/). Below are some findings when controlling for different subsets of control features:

- **Response length**: Controlling for response length yields a positive and statistically significant coefficient (0.255, *p* < 0.05), indicating that users prefer more verbose responses.
- **Number of citations**: Controlling for citation count also results in a positive and significant coefficient (0.234, *p* < 0.05), suggesting a preference for responses with more cited sources.
- **Citation source categories**: As shown in [Fig. 8](#fig8), citations from **community platforms** (e.g., Reddit, Quora) and **YouTube** have statistically significant positive effects on user votes. The remaining categories have insignificant coefficients.
- **Joint controls**: When controlling for all features, only **response length** and **citation count** remain statistically significant.

<div id="fig8" style="display: flex; justify-content: center;">
  <iframe src="{{ '/assets/img/blog/search_arena/04092025/domain_citations_style_control_bootstrap_style_coefs.html' }}" frameborder='0' scrolling='no' height="400px" width="100%"></iframe>
</div>

<p style="color:gray; text-align: center;">Figure 8. Estimates (with 95% CIs) of style coefficients.</p>

Finally, we used all previously described features to construct a controlled leaderboard. [Fig. 9](#fig9) compares the original and adjusted arena scores after controlling for response length, citation count, and cited sources. Interestingly, when using all these features as control variables, the top six models all show a reduction in score, while the remaining models are largely unaffected. This narrows the gap between <code>gemini-2.0-flash-grounding</code> and non-reasoning Perplexity models. [Tab. 5](#tab5) shows model rankings when controlling for different subsets of these features:

- Controlling for response length, `ppl-sonar-reasoning` shares the first rank with `gemini-2.5-pro-grounding` and `ppl-sonar-reasoning-pro-high`. The difference between (1) `sonar-pro` and other non-reasoning sonar models as well (2) `api-gpt-4o-search-high` and `api-gpt-4o-search-high-loc`, disappear.
- When controlling for the number of citations, model rankings converge (i.e., multiple models share the same rank), suggesting that the number of citations is a significant factor impacting differences across models and the resulting rankings.
- Controlling for cited domains has minimal effect on model rankings.

<div id="fig9">
  <iframe src="{{ '/assets/img/blog/search_arena/04092025/style_control.html' }}" frameborder='0' scrolling='no' height="400px" width="100%"></iframe>
</div>

<p style="color:gray; text-align: center;">Figure 9. Arena scores before and after a controlled setting.</p>

<table id="tab5" style="width: 100%; border-collapse: collapse; text-align: center;">
  <thead>
    <tr>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Model</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Rank Diff (Length)</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Rank Diff (# Citations)</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Rank Diff (Domain Sources)</th>
      <th style="padding: 8px; border-bottom: 1px solid #ccc;">Rank Diff (All)</th>
    </tr>
  </thead>
  <tbody>
    <tr><td><code>gemini-2.5-pro-grounding</code></td><td>1→1</td><td>1→1</td><td>1→1</td><td>1→1</td></tr>
    <tr><td><code>ppl-sonar-reasoning-pro-high</code></td><td>1→1</td><td>1→1</td><td>1→1</td><td>1→1</td></tr>
    <tr><td><code>ppl-sonar-reasoning</code></td><td>3→1</td><td>3→3</td><td>3→3</td><td>3→2</td></tr>
    <tr><td><code>ppl-sonar</code></td><td>3→3</td><td>3→3</td><td>3→3</td><td>3→3</td></tr>
    <tr><td><code>ppl-sonar-pro-high</code></td><td>3→3</td><td>3→4</td><td>3→4</td><td>3→3</td></tr>
    <tr><td><code>ppl-sonar-pro</code></td><td>4→3</td><td>4→4</td><td>4→4</td><td>4→3</td></tr>
    <tr><td><code>gemini-2.0-flash-grounding</code></td><td>7→7</td><td>7→4</td><td>7→5</td><td>7→4</td></tr>
    <tr><td><code>api-gpt-4o-search</code></td><td>7→7</td><td>7→4</td><td>7→7</td><td>7→6</td></tr>
    <tr><td><code>api-gpt-4o-search-high</code></td><td>7→8</td><td>7→4</td><td>7→7</td><td>7→7</td></tr>
    <tr><td><code>api-gpt-4o-search-high-loc</code></td><td>8→8</td><td>8→5</td><td>8→7</td><td>8→7</td></tr>
    <tr><td><code>api-gpt-4o-mini-search</code></td><td>11→11</td><td>11→11</td><td>11→11</td><td>11→11</td></tr>
  </tbody>
</table>

<p style="color:gray; text-align: center;">
  Table 5. Model rankings change when controlling for different subsets of features.
</p>

<h2 id="futurework">4. Conclusion & What’s Next</h2>

As search-augmented LLMs become increasingly popular, **Search Arena** provides a real-time, in-the-wild evaluation platform driven by crowdsourced human feedback. Unlike static QA benchmarks, our dataset emphasizes current events and diverse real-world queries, offering a more realistic view of how users interact with these systems.
Using 7k human votes, we found that **Gemini-2.5-Pro-Grounding** and **Perplexity-Sonar-Reasoning-Pro-High** share the first rank in the leaderboard. User preferences are positively correlated with **response length**, **number of citations**, and **citation sources**. Citation formatting, surprisingly, had minimal impact.


We have open-sourced our data ([🤗 search-arena-7k](https://huggingface.co/datasets/lmarena-ai/search-arena-v1-7k)) and analysis code ([⚙️ Colab notebook](https://colab.research.google.com/drive/1Vb92s3O9RZ0aOs5c953SzaB2HniVcX4_)). Try [🌐 Search Arena](https://lmarena.ai/?search) now and see what’s next: 

- **Open participation**: We are inviting model submissions from researchers and industry, and encouraging public voting.
- **Cross-task evaluation**: How well do search models handle general questions? Can LLMs manage search-intensive tasks?
- **Raise the bar for open models:** Can simple wrappers with search engine/scraping + tools like ReAct and function calling make open models competitive?

## Citation

```bibtex
@misc{searcharena2025,
    title = {Finally. Search Arena.},
    url = {https://blog.lmarena.ai/blog/2025/search-arena/},
    author = {Mihran Miroyan*, Tsung-Han Wu*, Logan Kenneth King, Tianle Li, Anastasios N. Angelopoulos†, Wei-Lin Chiang†, Joseph E. Gonzalez†},
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