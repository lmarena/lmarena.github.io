---
layout: distill
title: "Arena Explorer"
description: A topic modeling pipeline for LLM evals & analytics
giscus_comments: true
date: 2025-02-10
featured: true
thumbnail: assets/img/blog/explorer/explorer.png
authors:
  - name: Kelly Tang
    url: "https://www.linkedin.com/in/kelly-yuguo-tang/"
    affiliations:
      name: UC Berkeley
  - name: Anastasios N. Angelopoulos
    url: "http://angelopoulos.ai"
  - name: Wei-Lin Chiang
    url: "https://infwinston.github.io/"
---

## Introduction

Chatbot Arena receives vast amounts of LLM conversations daily. However, understanding what people ask, how they structure prompts, and how models perform isn’t straightforward. Raw text data is messy and complex. Analyzing small samples is feasible, but identifying trends in large datasets is challenging. This isn’t just our problem. Anyone dealing with unstructured data, e.g. long texts and images, faces the same question: how do you organize it to extract meaningful insights?

To address this, we developed a topic modeling pipeline and the **Arena Explorer**. This pipeline organizes user prompts into distinct topics, structuring the text data hierarchically to enable intuitive analysis. We believe this tool for hierarchical topic modeling can be valuable to anyone analyzing complex text data.

<div class="l-page" style="display: flex; justify-content: center; align-items: center;">
  <div style="position: relative; width: 100%; max-width: 1200px; height: 0; padding-bottom: 70%; margin-bottom: 20px">
    <iframe 
      src="https://storage.googleapis.com/public-arena-no-cors/trial/index.html" 
      frameborder="0" 
      scrolling="yes" 
      style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: white;"
      allowfullscreen>
    </iframe>
  </div>
</div>

In this blog post, we will cover:

- Analysis of LLM performance insights received from Arena Explorer.
- Details of how we created the Explorer, transforming a large dataset of user conversations into an exploratory tool.
- Ways to fine-tune and improve topic models.

Check out the pipeline in this [colab notebook](https://colab.research.google.com/drive/1chzqjePYnpq08fA3KzyKvSkuzCjojyiE?usp=sharing), and try it out yourself.

We also published the [dataset](https://huggingface.co/datasets/lmarena-ai/arena-explorer-preference-100k) we used. This dataset contains 100k leaderboard conversation data, the largest prompt dataset with human preferences we have every released!

## Insights

**Model Performance Comparison**

In our previous [blog post](https://blog.lmarena.ai/blog/2024/arena-category/), we conducted an in-depth categorical analysis and discussed key insights. That analysis was based on manually defined categories in Chatbot Arena. The results showed that language models perform differently across categories. With our topic modeling pipeline, we can now analyze model performance across categories more efficiently and dive deeper into specific topics.

Compared to _Tech Programming_, model rankings for the other two largest broad categories, _Creative Writing_ and _Puzzles & Math_, shifted significantly.

<div>
  <iframe src="{{ '/assets/img/blog/explorer/rank_broad_cat.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 1. Tech Programming vs. Creative Writing vs. Puzzles Chatbot Arena ranking of the top 10 ranked models in Tech Programming.</p>

Claude performed better than Gemini in _Tech Programming_, while Gemini outperformed Claude in _Creative Writing_. Deepseek-coder-v2 dropped in ranking for _Creative Writing_ compared to its position in _Tech Programming_.

<div>
  <iframe src="{{ '/assets/img/blog/explorer/rank_tech_vs_writing.html' }}" frameborder='0' scrolling='no' height="800px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 2. Tech Programming vs. Creative Writing Chatbot Arena Score computed using the Bradley-Terry model.</p>

**Diving into Narrow Categories**

Model performance analysis can be broken down into more specific categories based on win rates. We calculated the win rates of Gemini 1.5, GPT-4o, and Claude 3.5 across the narrow categories, treating ties as 0.5 wins. Gemini 1.5 performed best in _Entrepreneurship and Business Strategy_ but had a noticeably lower win rate in _Songwriting and Playlist Creation_. In contrast, GPT-4o maintained a relatively consistent win rate across most categories, except for a dip in _Entrepreneurship and Business Strategy_. Claude 3.5 excelled in _Web Development_ and _Linux & Shell Scripting_ but had lower win rates in other, less technical categories.

<div>
  <iframe src="{{ '/assets/img/blog/explorer/winrate_narrow.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 3. Model win rates in the eight largest narrow categories.</p>

Even within the same broad category, model performance varies slightly. For example, within _Tech Programming_, GPT-4o showed a lower win rate in _GPU and CPU Performance and Comparison_ compared to other categories. Within _Creative Writing_, Gemini had a significantly higher win rate in _Genshin Impact Parody Adventures_.

<div>
  <iframe src="{{ '/assets/img/blog/explorer/winrate_tech.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 4. Model win rates in the eight largest narrow categories within Tech Programming.</p>

<div>
  <iframe src="{{ '/assets/img/blog/explorer/winrate_writing.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 5. Model win rates in the eight largest narrow categories within Creative Writing.</p>

Note: Since models compete against different sets of opponents, win rates are only meaningful when compared within the same model. Therefore, we do not directly compare win rates across different models.

## Topic Modeling Pipeline

We used the leaderboard conversation data between June 2024 and August 2024. To facilitate clustering in later steps, we selected prompts tagged in English and removed duplicate prompts. The final dataset contains around 52k prompts.

To group the prompts into narrow categories, we used a topic modeling pipeline with [BERTopic](https://maartengr.github.io/BERTopic/index.html), similar to the one presented in our paper [(Chiang, 2024)](https://arxiv.org/abs/2403.04132). We performed the following steps.

1. We create embeddings for user prompts with SentenceTransformers’ model (all-mpnet-base-v2), transforming prompts into representation vectors.
2. To reduce the dimensionality of embeddings, we use UMAP (Uniform Manifold Approximation and Projection)
3. We use the density distribution-based clustering algorithm HDBSCAN to identify topic clusters with a minimum clustering size of 20.
4. We select 20 example prompts per cluster. They were chosen from the ones with high HDBSCAN probability scores (top 20% within their respective clusters). For clarity, we choose those with fewer than 100 words.
5. To come up with cluster names, we feed the example prompts into ChatGPT-4o to give the category a name and description.
6. We reduced all outliers using probabilities obtained from HDBSCAN and then embeddings of each outlier prompt.
   This pipeline groups the prompts into narrow categories, each with 20 example prompts.

<div>
  <iframe src="{{ '/assets/img/blog/explorer/intertopic_distance.html' }}" frameborder='0' scrolling='no' height="700px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 6. The intertropical distance map shows the narrow clusters identified by BERTopic. The size of the circles is proportional to the amount of prompts in the cluster.</p>

We consolidate the initial narrow categories into broad categories for more efficient and intuitive exploration. We perform a second round of this topic clustering pipeline on the summarized category names and descriptions generated earlier. The steps are almost identical to before. Except for steps 4 and 5, we use all category names in a cluster for summarization instead of selecting examples.

### Tuning Topic Clusters

Topic clusters are not always accurate. Some prompts may not be placed in the most suitable cluster, and the same applies to specific categories. Many factors influence the final clustering:

1. Embedding models used to generate vector representations for prompts
2. Sampled example prompts used to assign cluster names
3. BERTopic model parameters that affect the number of clusters, such as n_neighbors in UMAP and min_cluster_size in HDBSCAN
4. Outlier reduction methods

**How do we improve and fine-tune the clusters?**
Embedding models play a major role in clustering accuracy since they are used to train the clustering model. We compared two models on a 10k sample dataset: Sentence Transformer’s all-mpnet-base-v2 and OpenAI’s text-embedding-3-large, a more recent model. According to the [MTEB Leaderboard](https://huggingface.co/spaces/mteb/leaderboard), text-embedding-3-large performs better on average (57.77). The clustering results are noticeably different.

With text-embedding-3-large, the broad category distribution is more balanced. In contrast, all-mpnet-base-v2 produced a large _Tech Programming_ category. Zooming in on this category, we found that AI-related clusters were merged into _Tech Programming_ when using all-mpnet-base-v2, whereas text-embedding-3-large formed a separate AI-related category. Choosing which result to use depends on human preference.

<div class="l-page" style="display: flex; justify-content: center; align-items: center;">
  <iframe src="{{ '/assets/img/blog/explorer/embedding_mpnet_broad.html' }}" frameborder='0' scrolling='no' height="700px" width="100%"></iframe>
  <iframe src="{{ '/assets/img/blog/explorer/embedding_mpnet_tech.html' }}" frameborder='0' scrolling='no' height="700px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 7 & 8. Broad categories and specific categories in “Tech Programming” summarized using all-mpnet-base-v2.</p>

<div class="l-page" style="display: flex; justify-content: center; align-items: center;">
  <iframe src="{{ '/assets/img/blog/explorer/embedding_openai_broad.html' }}" frameborder='0' scrolling='no' height="700px" width="100%"></iframe>
  <iframe src="{{ '/assets/img/blog/explorer/embedding_openai_tech.html' }}" frameborder='0' scrolling='no' height="700px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 9 & 10. Broad categories and specific categories in “Tech Programming” summarized using  text-embedding-3-large.</p>

Beyond embedding models, adjusting parameters and outlier reduction methods helps refine the clusters. For example, we increased the min_cluster_size parameter to adjust the broad clusters. Before, several broad categories had similar meanings. By increasing this parameter, we reduced the number of clusters, resulting in more distinctive categories.

## What's next?

We will add more features to our explorer that provide insights into the connection between model performance and prompt category, such as model performance per category.

We would love to hear your feedback and how you are using the pipeline to derive insights!

## Citation

```bibtex
@misc{tang2025explorer,
    title={Arena Explorer: A Topic Modeling Pipeline for LLM Evals & Analytics},
    author={Kelly Tang and Wei-Lin Chiang and Anastasios N. Angelopoulos}
    year={2025},
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
