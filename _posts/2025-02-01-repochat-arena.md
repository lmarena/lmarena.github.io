---
layout: distill
title: RepoChat Arena
description: A Live Benchmark for AI Software Engineers
giscus_comments: true
date: 2025-02-12
featured: true
thumbnail: assets/img/blog/repochat_arena/purple_octopus.png
authors:
  - name: Yifan Song*
    url: "https://www.linkedin.com/in/yf-song/"
    affiliations:
      name: UC Berkeley, CMU
  - name: Naman Jain*
    url: "https://naman-ntc.github.io/"
  - name: Manish Shetty*
    url: "https://manishs.org"
  - name: Wei-Lin Chiang*
    url: "https://infwinston.github.io/"
  - name: Valerie Chen
    url: "https://valeriechen.github.io/"
  - name: Wayne Chi
    url: "https://waynchi.github.io"
  - name: Anastasios N. Angelopoulos
    url: "http://angelopoulos.ai"
  - name: Ion Stoica
    url: "https://people.eecs.berkeley.edu/~istoica/"
---

## Introduction

An integral part of using LLMs as part of a user's coding workflow is navigating and understanding complex code bases. We launched **RepoChat** – a new arena that answers code-related queries using a user-provided github repository link.

RepoChat lets models automatically retrieve relevant files from the given GitHub repository. It can resolve issues, review PRs, implement code, as well as answer higher level questions about the repositories-all without requiring users to provide extensive context.

<div class="video-container">
    <video id="videoPlayer" autoplay loop muted playsinline>
        <source src="/assets/img/blog/repochat_arena/repochat_demo_video.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
</div>

<p style="color:gray; text-align: center;">Video 1. A demo of RepoChat.</p>

<style>
.video-container {
    position: relative;
    width: 90%;
    max-width: 1200px;
    margin: auto;
}
video {
    width: 100%;
    border-radius: 10px;
}
</style>

So far, RepoChat has collected around **20k battles** and over **4k votes**. All statistics calculated in this blog use conversations and votes collected between **November 30, 2024** to **Feburary 11, 2025** inclusive.

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">Metric</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Value</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;font-weight:500"># of conversations</td>
      <td style="padding: 8px; border: 1px solid lightgray; text-align: right;font-weight: 500">12,732</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;font-weight: 500"># of votes</td>
      <td style="padding: 8px; border: 1px solid lightgray; text-align: right;font-weight: 500">4,857</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray;font-weight: 500"># of unique GitHub links (in convos)</td>
      <td style="padding: 8px; border: 1px solid lightgray; text-align: right;font-weight: 500">5,037</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray;font-weight: 500"># of unique GitHub links (in votes)</td>
      <td style="padding: 8px; border: 1px solid lightgray; text-align: right;font-weight: 500">2,465</td>
    </tr>
  </tbody>
</table>
</div>
<p style="color:gray; text-align: center;">Table 1.  Number of conversations, votes, and unique GitHub links logged from 11/30/2024 - 02/11/2025.</p>

In this blog we will cover:

- [**Initial Results**](#initial-leaderboards): our preliminary results for the RepoChat leaderboards
- [**How do people use RepoChat**](#how-do-people-use-repochat): an analysis of the distribution of github links and user queries' category, length, language, etc.
- [**How does it work**](#how-does-it-work): a more technical and detailed explanation of the RepoChat pipeline and implementation
- [**Further Analysis and Results**](#further-analysis-and-results): retriever and style controlled leaderboards, and other analysis of model rankings.

## Initial Leaderboards

Since there are two separate components (retriever and answer), we produce two separate leaderboards. Jump to [this section](#leaderboard-calculation) for details about how the leaderboards are calculated, and to [further analysis](#further-analysis-and-results) for more leaderboards such as [style-control](#style-control). All leaderboards can be reproduced using our [google colab notebook](https://colab.research.google.com/drive/1sdSE07D7IqKAdb8LwMlOGCIfmWih3Df3?usp=sharing).

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">Rank</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Arena Score</th>
      <th style="padding: 8px; border: 1px solid lightgray;">95% CI</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Votes</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Org.</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">1</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">GPT 4o (20241120)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1088</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+12 | -10</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1647</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">OpenAI</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">2</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">DeepSeek V3</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1032</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+24 | -21</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">362</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">DeepSeek</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">3</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Claude 3.5 Sonnet (20241022)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1015</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+16 | -10</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1737</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Anthropic</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">4</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Gemini 2.0 Flash Exp</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1005</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+15 | -13</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1066</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Google</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">5</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Gemini 1.5 Pro</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">974</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+19 | -16</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">789</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Google</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">6</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">GPT 4o mini (20240718)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">970</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+24 | -17</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">521</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">OpenAI</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">7</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">LLaMA 3.1 405B Instruct FP8</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">914</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+13 | -22</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">750</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Meta</td>
    </tr>
  </tbody>
</table>
</div>

<p style="color:gray; text-align: center;">Table 2. Arena ratings of seven popular models based on over 4K votes collected between November 30, 2024 to Feburary 11, 2025. This ranks the models for generating model response</p>

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">Rank</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Arena Score</th>
      <th style="padding: 8px; border: 1px solid lightgray;">95% CI</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Org.</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">1</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Gemini 1.5 Flash 002</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1013</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+14 | -21</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Google</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">2</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">GPT 4o mini (20240718)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">987</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+21 | -14</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">OpenAI</td>
    </tr>
  </tbody>
</table>
</div>

<p style="color:gray; text-align: center;">Table 3. Arena ratings of the two retrievers based on 4K votes collected between November 30, 2024 to Feburary 11, 2025. This ranks the models for retrieving relevant files.</p>

## How do people use RepoChat?

**What types of Github links do users input?** RepoChat features a wide range of GitHub links, including repositories, issues, pull requests, and others. We find that the vast majority (almost 80%) of user input links are repository links, followed by issues and branches.

<img src="/assets/img/blog/repochat_arena/PIC_pie_chart.png" alt="GitHub Link Categories" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 70%">
<p style="color:gray; text-align: center;">Figure 1. Breakdown of the GitHub link categories in RepoChat by percentage.</p>

**What programming languages do people ask about?** The following statistic is calculated based on the file extensions of the relevant files. This serves as an indicator of the programming languages users are most frequently inquiring about/coding in. The abundance of markdown files is primarily due to README files, which are often extracted due to containing critical descriptions and instructions for the repository.

<img src="/assets/img/blog/repochat_arena/PIC_file_type.png" alt="Programming Language Breakdown" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 2. Breakdown of retrieved file types by percentage.</p>

**What natural languages do the user queries contain?** Most of our votes contain user queries in English, followed by Russian and Chinese.

<img src="/assets/img/blog/repochat_arena/PIC_natural_language.png" alt="Natural Language Breakdown" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 3. Breakdown of user query’s language by count.</p>

**How long are the user queries?** The user query length varies significantly, ranging from a minimum of 1 token to a maximum of 1,406,325 tokens, with a median of 22 tokens. Short-length queries mostly consist of prose requesting implementations or instructions, whereas longer queries often include extensive code blocks.

<img src="/assets/img/blog/repochat_arena/PIC_query_len.png" alt="Query Length Distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 4. Distribution of user query length.</p>

**How long are the retrieved file contexts?** The distribution of retrieved file content is more stable, with a median of 8,870, an average of 12,508, and a maximum of 126,329 tokens, with the occasional empty retrieval.

<img src="/assets/img/blog/repochat_arena/PIC_context_len.png" alt="Retrieved Context Length Distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 5. Distribution of retrieved file context length.</p>

**What are the most common user query types?**

For more examples, please refer to the [appendix](#appendix). We have also released a dataset of around 4k battles [here](https://huggingface.co/datasets/lmarena-ai/repochat-arena-battles-4k) on Hugging Face.

- **High level questions about a repository:**

  - [https://github.com/Mrjoulin/ITMOLabs](https://github.com/Mrjoulin/ITMOLabs)<br>"What is this repository about? How I can use it? What main languages and frameworks are used here?"

- **Specific how-to questions:**

  - [https://github.com/notfiz/de3u](https://github.com/notfiz/de3u)<br>"How do I install this on Linux (Mint 22)? Be thorough."

- **Implementation requests:**

  - [https://github.com/dipu-bd/lightnovel-crawler](https://github.com/dipu-bd/lightnovel-crawler)<br>"Write a Python script that fetches the top 10 highest-rated light novels from Anilist and then downloads all of their volumes in .epub format using this."

- **Specific explanation requests:**

  - [https://github.com/hhy-huang/GraphJudger](https://github.com/hhy-huang/GraphJudger)<br>"How is the graph knowledge graph in this repository generated?"

- **Requests for solving an issue:**

  - [https://github.com/rust-lang/rfcs/issues/1856](https://github.com/rust-lang/rfcs/issues/1856)<br>"In 100 words or less, what is the easiest approach to resolving this issue (without giving up)?"

- **Requests for reviewing a PR:**

  - [https://github.com/pandas-dev/pandas/pull/56061](https://github.com/pandas-dev/pandas/pull/56061)<br>"Explain the optimization."

- **Queries with code snippets, requests for modifying existing code, and debugging:** (click the arrow to expand the full query)

  - [https://github.com/sktime/sktime](https://github.com/sktime/sktime)<br>
    <details>
      <summary>"debug the code as a professional would do. The code is for running in jupyter.</summary> 
      <pre style="background-color: #f9f9f9; padding: 8px; border: 1px solid lightgray; font-family: monospace;">
      import pandas as pd
      import numpy as np
      from sktime.forecasting.model_selection import (
          ForecastingOptunaSearchCV,
          ExpandingWindowSplitter,
          temporal_train_test_split
      )
      from sktime.forecasting.base import ForecastingHorizon
      from sktime.performance_metrics.forecasting import MeanAbsolutePercentageError
      from sktime.forecasting.compose import TransformedTargetForecaster
      from sktime.forecasting.statsforecast import (
          StatsForecastMSTL,
          StatsForecastAutoETS,
          StatsForecastAutoARIMA,
          StatsForecastAutoTheta
      )
      from sktime.transformations.series.detrend import Detrender
      from sktime.transformations.series.deseasonalize import Deseasonalizer
      import optuna
      import warnings

    warnings.filterwarnings('ignore')

    # Load your time series data

    # Ensure 'pivot_table' is defined and contains the 'PAN4_PIBPMG4' series

    y = pivot_table['PAN4_PIBPMG4']

    # Split the data into train and test sets

    y_train, y_test = temporal_train_test_split(y, test_size=8)

    # Define the forecasting horizon

    fh = ForecastingHorizon(np.arange(1, 9), is_relative=True)

    # Set up cross-validation with an expanding window splitter

    cv = ExpandingWindowSplitter(fh=fh, initial_window=len(y_train) - 8)

    # Define the parameter space for tuning

    param_distributions = {
    'forecaster**season_length': optuna.distributions.CategoricalDistribution([(4,), (8,)]),
    'forecaster**trend_forecaster': optuna.distributions.CategoricalDistribution([
    StatsForecastAutoETS(model="ZZZ"),
    StatsForecastAutoARIMA(seasonal=True),
    StatsForecastAutoTheta()
    ]),
    'forecaster\_\_stl_kwargs': {
    'robust': optuna.distributions.CategoricalDistribution([True, False]),
    'period': optuna.distributions.IntUniformDistribution(4, 8)
    }
    }

    # Initialize the MSTL forecaster

    mstl_forecaster = StatsForecastMSTL()

    # Create a pipeline with optional transformations

    forecaster = TransformedTargetForecaster(steps=[
    ("detrender", Detrender()),
    ("deseasonalizer", Deseasonalizer()),
    ("mstl_forecaster", mstl_forecaster)
    ])

    # Set up the OptunaSearchCV

    optuna_search = ForecastingOptunaSearchCV(
    forecaster=forecaster,
    cv=cv,
    param_distributions=param_distributions,
    scoring=MeanAbsolutePercentageError(symmetric=True),
    n_trials=100,
    random_state=42
    )

    # Fit the model

    optuna_search.fit(y_train)

    # Predict

    y_pred = optuna_search.predict(fh)

    # Evaluate

    mape = MeanAbsolutePercentageError(symmetric=True)
    final_mape = mape(y_test, y_pred)
    print(f"Final sMAPE: {final_mape:.2f}")

    # Plot results

    import matplotlib.pyplot as plt

    plt.figure(figsize=(15, 7))
    plt.plot(y_train.index, y_train.values, label='Training Data', color='blue')
    plt.plot(y_test.index, y_test.values, label='Test Data', color='green')
    plt.plot(y_pred.index, y_pred.values, label='Predictions', color='red', linestyle='--')
    plt.title('MSTL Forecast Results with Optuna Optimization')
    plt.legend()
    plt.grid(True)
    plt.show()

    # Save the best model

    from joblib import dump
    dump(optuna*search.best_forecaster*, 'best_mstl_model_optuna.joblib')
    print("\nBest model saved as 'best_mstl_model_optuna.joblib'")

    # Print additional optimization results

    print("\nOptimization Results:")
    print("="\*50)
    print(f"Number of completed trials: {len(optuna*search.cv_results*)}")
    print(f"Best trial number: {optuna*search.best_index*}")
    print(f"Best sMAPE achieved during optimization: {optuna*search.best_score*:.2f}")

    # Print best parameters

    print("\nBest Parameters Found:")
    print("="\*50)
    for param, value in optuna*search.best_params*.items():
    print(f"{param}: {value}")
      </pre>"
    </details>

## How Does It Work?

Each generated answer is the collaborative effort between two separate LLM models. The **retriever model** extracts the relevant files from the github repository according to the given user input. The extracted file contents are then concatenated together with the user query and used as a prompt for the **answer model**, which then generates the response.
<img src="/assets/img/blog/repochat_arena/PIC_complete_pipeline.png" alt="RepoChat full pipeline" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 60%">

<p style="color:gray; text-align: center;">Figure 6. A graphical representation of the full RepoChat retriever->answer pipeline.</p>

### File Retrieval

We select two models as retrievers: `gemini-1.5-flash-002` and `gpt-4o-mini`.

When a valid GitHub link is provided, the repository is cloned, and its file structure is extracted and formatted in an indented layout. The retriever model is then prompted to strategically identify files from the file structure that are potentially useful for answering the query. It then outputs these files in decreasing order of relevance and a specified markdown format.

<details>
<summary>Click to view retriever prompt</summary> 
The following files are found in the repository:<br>
{file structure}<br>
Please provide a list of files that you would like to search for answering the user query. <br>
Enclose the file paths in a list in a markdown code block as shown below:<br>
```<br>
1. [[ filepath_1 ]]\n<br>
2. [[ filepath_2 ]]\n<br>
3. [[ filepath_3 ]]\n<br>
...<br>
```<br>
Think step-by-step and strategically reason about the files you choose to maximize the chances of finding the answer to the query. Only pick the files that are most likely to contain the information you are looking for in decreasing order of relevance. Once you have selected the files, please submit your response in the appropriate format mentioned above (markdown numbered list in a markdown code block). The filepath within [[ and ]] should contain the complete path of the file in the repository.<br>
{query}
</details>

### Model Response Generation

The contents of relevant files are extracted, concatenated with the user query, and provided to the responding LLM as a prompt in a specified format. If the provided link is not a direct repository link but instead links to issues or pull requests, a query context section containing the content of the issue or PR thread is also included.

<details>
<summary>Click to view answer model prompt format</summary> 
Here is a list of files in the repository that may help you answer the query:<br>
{pairs of (file_name, file_content)}<br>
___<br><br>
[INSTRUCTION]<br><br>
You are an expert software engineer. Answer the following user query using provided context retrieved from the {repository_name} repository.<br><br>
[QUERT CONTEXT]<br><br>
{issue/PR content}<br><br>
[USER QUERY]<br><br>
{user query}<br><br>
</details>

## Further Analysis and Results

### Style Control

Style (length and Markdown formatting) significantly impacts model ranking. A better formatted or visually appealing answer, though not necessarily better, is more likely to win. The style-controlled leaderboard isolates writing style from content quality. For details on our methodology, refer to [this blog post](https://blog.lmarena.ai/blog/2024/style-control/).

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">Rank</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Arena Score</th>
      <th style="padding: 8px; border: 1px solid lightgray;">95% CI</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Org.</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">1</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Claude 3.5 Sonnet (20241022)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1031</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+28 | -17</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Anthropic</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">2</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">GPT 4o (20241120)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1028</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+23 | -24</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">OpenAI</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">3</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">DeepSeek V3</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1016</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+27 | -25</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">DeepSeek</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">4</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Gemini 1.5 Pro</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1007</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+21 | -25</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Google</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">5</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Gemini 2.0 Flash Exp</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">997</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+20 | -23</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Google</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">6</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">GPT 4o mini (20240718)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">963</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+26 | -24</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">OpenAI</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">7</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">LLaMA 3.1 405B Instruct FP8</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">956</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+23 | -23</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Meta</td>
    </tr>
  </tbody>
</table>
</div>

<p style="color:gray; text-align: center;">Table 4.  Style-controlled arena ratings of the answer models. </p>

Claude 3.5 Sonnet’s score and ranking has improved significantly with style control, claiming the top spot. GPT-4o's score has decreased, greatly narrowing its lead over other models. Gemini 1.5 Pro has also seen a notable boost in score, climbing one rank higher.

<img src="/assets/img/blog/repochat_arena/PIC_ldb_vs_sc.png" alt="Original vs. Style-Controlled Leaderboard" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 60%">
<p style="color:gray; text-align: center;">Figure 7. A comparison of the original and the style-controlled leaderboards of the answer models.</p>

**Why does style control affect models like Claude and GPT 4o so much?**

This is likely because a significant portion of user queries are not focused on strictly code-writing tasks. Instead, many focus on code understanding—such as how to use the repository, its purpose, or other high-level questions—rather than specific code implementations. These types of queries shift the focus away from pure coding abilities, and instead place greater emphasis on organization and presentation, and overall style.

Below is an example battle between Claude 3.5 Sonnet (20241022) and GPT 4o (20241120) with identical retrievals.

The GitHub link is **https://github.com/xtekky/gpt4free**, and the user query is **"Explain why in the new 0.4.0.0 version Blackbox provider is several times slower than in version 0.3.9.7"**

<details>
<summary> Click to expand the example battle of Claude 3.5 Sonnet (20241022) vs. GPT 4o (20241120)</summary>
<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; table-layout: fixed; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray; width: 50%;">Claude 3.5 Sonnet (20241022) Response</th>
      <th style="padding: 8px; border: 1px solid lightgray; width: 50%;">GPT 4o (20241120) Response</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">
        <p>Let me analyze the code from the provided context to explain the potential reasons for Blackbox provider's slower performance in version 0.4.0.0.</p>
        <p>Looking at the <code>Blackbox.py</code> implementation, there are several key changes that could contribute to slower performance:</p>
        <ol>
          <li>
            <strong>Validation Process:</strong> The provider now implements a more complex validation process that requires fetching and parsing JavaScript files to obtain a validation token:
            <pre style="background-color: #f9f9f9; padding: 8px; border: 1px solid lightgray; font-family: monospace;">
            @classmethod
            async def fetch_validated(cls):
                cached_value = cls._load_cached_value()

                async with aiohttp.ClientSession() as session:
                    # Tries multiple URLs
                    urls_to_try = [
                        "https://www.blackbox.ai",
                        "https://api.blackbox.ai"
                    ]

                    for base_url in urls_to_try:
                        try:
                            async with session.get(base_url) as response:
                                if response.status != 200:
                                    continue
                                page_content = await response.text()
                                js_files = re.findall(r'static/chunks/\d{4}-[a-fA-F0-9]+\.js', page_content)
                                # Additional JS file parsing...
              </pre>
          </li>
          <li>
            <strong>Multiple URL Attempts:</strong> The code now tries multiple URLs and has to process multiple JavaScript files, which adds overhead:
            <ul>
              <li>It first tries <code>blackbox.ai</code>.</li>
              <li>Then falls back to <code>api.blackbox.ai</code>.</li>
              <li>For each URL, it has to download and parse multiple JS files.</li>
            </ul>
          </li>
          <li>
            <strong>Caching Implementation:</strong> While there is a caching mechanism implemented:
            <pre style="background-color: #f9f9f9; padding: 8px; border: 1px solid lightgray; font-family: monospace;">
            @classmethod
            def _load_cached_value(cls) -> str | None:
                cache_file = cls._get_cache_file()
                if cache_file.exists():
                    try:
                        with open(cache_file, 'r') as f:
                            data = json.load(f)
                            return data.get('validated_value')
            </pre>
            <p>The cache might not be as effective as in previous versions, requiring more frequent validation token refreshes.</p>
          </li>
          <li>
            <strong>Additional Model Support:</strong> The provider now supports many more models and features:
            <pre style="background-color: #f9f9f9; padding: 8px; border: 1px solid lightgray; font-family: monospace;">
            vision_models = [default_vision_model, 'gpt-4o', 'gemini-pro', 'gemini-1.5-flash', 'llama-3.1-8b', 'llama-3.1-70b', 'llama-3.1-405b']
            web_search_models = ['blackboxai', 'meta-llama/Llama-3.3-70B-Instruct-Turbo', 'meta-llama/Meta-Llama-3.1-405B-Instruct-Lite-Pro']
            </pre>
            <p>This expanded model support likely requires additional validation and processing logic.</p>
          </li>
        </ol>
        <p>To improve performance, you could:</p>
        <ul>
          <li>Optimize the validation process to reduce unnecessary requests.</li>
          <li>Implement more aggressive caching of the validation token.</li>
          <li>Only load model information for the specific model being used.</li>
          <li>Consider using connection pooling to reduce connection overhead.</li>
        </ul>
        <p>The tradeoff seems to be between security/functionality and speed - the new version implements more robust validation and supports more features, but at the cost of performance.</p>
        <p>Would you like me to elaborate on any of these points or provide specific suggestions for optimizing the provider's performance?</p>
      </td>


      <td style="padding: 8px; border: 1px solid lightgray; vertical-align: top;">
        <p>In version <strong>0.4.0.0</strong> of the <code>gpt4free</code> repository, the <strong>Blackbox provider</strong> is slower compared to version <strong>0.3.9.7</strong> likely due to several changes introduced in the newer implementation. Here's an analysis based on the provided context:</p>
        <hr>
        <h3>1. Enhanced <code>fetch_validated</code> Method in <code>Blackbox</code></h3>
        <p>In <strong>version 0.4.0.0</strong>, the <code>Blackbox</code> provider introduces a more complex and robust mechanism for fetching and validating the <code>validated_value</code>. This involves:</p>
        <ul>
          <li><strong>Fetching multiple JavaScript files</strong> from the <code>https://www.blackbox.ai</code> or <code>https://api.blackbox.ai</code> endpoints.</li>
          <li><strong>Regex-based parsing of UUIDs</strong> in JavaScript files to extract the <code>validated_value</code>.</li>
          <li><strong>Checking the context around the UUID</strong> to ensure it is valid.</li>
          <li><strong>Retries and handling multiple URLs</strong>, which adds overhead.</li>
        </ul>
        <p>This validation mechanism includes additional asynchronous calls and error handling. While it improves reliability, it significantly increases the response time.</p>
        <p><strong>Comparison to version 0.3.9.7:</strong> The earlier version likely used a simpler or cached approach for this process, avoiding the need to repeatedly process JavaScript files and perform context validation.</p>
        <hr>
        <h3>2. Increased Error Handling and Retrying</h3>
        <p>The new implementation introduces more robust error-handling mechanisms, including:</p>
        <ul>
          <li><strong>Retry loops</strong> for fetching JavaScript files and API calls.</li>
          <li><strong>Exponential backoff with random delays</strong> when processing requests.</li>
          <li><strong>Fallbacks for cached values</strong> if validation fails.</li>
        </ul>
        <p>While this improves reliability and stability, each retry and delay adds to the total processing time.</p>
        <hr>
        <h3>3. Web Search Integration</h3>
        <p>The <code>create_async_generator</code> function now has an optional <strong>web search</strong> feature:</p>
        <ul>
          <li>If <code>web_search</code> is enabled, the provider calls an external search engine (via <code>get_search_message</code>) to refine the user's query.</li>
          <li>Although <code>web_search</code> is optional, if enabled, it introduces significant latency due to network calls and extra processing.</li>
        </ul>
        <hr>
        <h3>4. Increased Complexity in Request Data Preparation</h3>
        <p>The new implementation constructs a more detailed payload for the API request:</p>
        <ul>
          <li><strong>Agent modes</strong> (e.g., <code>agentMode</code>, <code>trendingAgentMode</code>) are retrieved and included in the payload.</li>
          <li><strong>Model-specific settings</strong>, including image generation and other configurations, are passed in the data.</li>
          <li><strong>Image processing</strong> (if images are included) involves converting to data URIs.</li>
        </ul>
        <p>This additional processing step before sending the request increases the latency.</p>
        <hr>
        <h3>5. More Advanced Delay and Retry Mechanisms</h3>
        <p>When an API request fails, the system uses:</p>
        <ul>
          <li><strong>Exponential backoff delays:</strong> <code>delay * (2 ** attempt) + random.uniform(0, 1)</code></li>
          <li><strong>Retries (default <code>max_retries=3</code>):</strong> Every failed request results in subsequent retries.</li>
        </ul>
        <p>These features, while improving resilience, can slow down the overall response time if the API is unreliable or under heavy load.</p>
        <hr>
        <h3>6. Additional Debugging and Logging</h3>
        <p>The new version includes enhanced debugging and logging mechanisms (<code>debug.log</code>):</p>
        <ul>
          <li>Each step, including validation, retries, and errors, is logged.</li>
          <li>While useful for debugging, this can also slightly slow down execution, especially in development or verbose logging environments.</li>
        </ul>
        <hr>
        <h3>7. Potential API Changes on Blackbox's Side</h3>
        <p>If the Blackbox API itself has undergone changes between the two versions, such as stricter validation or slower endpoints, this could also contribute to the slowdown. The need to fetch and validate <code>validated_value</code> repeatedly suggests that the newer version is designed to handle a more restrictive or rate-limited API.</p>
        <hr>
        <h3>8. Cache Mechanism vs. Real-Time Validation</h3>
        <p>In version <strong>0.3.9.7</strong>, the <code>validated_value</code> may have been cached and reused across requests, reducing overhead. In version <strong>0.4.0.0</strong>, the <code>_load_cached_value</code> and <code>_save_cached_value</code> methods are still present, but more emphasis is placed on real-time validation through <code>fetch_validated</code>, which is inherently slower.</p>
        <hr>
        <h3>Summary of Reasons for Slowdown</h3>
        <ol>
          <li><strong>More Robust <code>fetch_validated</code> Method:</strong> Repeatedly fetching and parsing JavaScript files for UUID validation adds significant overhead.</li>
          <li><strong>Increased Error Handling and Retries:</strong> New retry mechanisms and delays increase resilience but add latency.</li>
          <li><strong>Optional Web Search:</strong> If enabled, it introduces additional network calls and processing time.</li>
          <li><strong>Enhanced Payload Preparation:</strong> More detailed request data adds preprocessing time.</li>
          <li><strong>Reliance on Real-Time Validation:</strong> Real-time validation of the <code>validated_value</code> is slower than relying on cached values.</li>
          <li><strong>API Changes on Blackbox's Side:</strong> Stricter validation or rate-limiting by the Blackbox API could also be contributing.</li>
        </ol>
        <hr>
        <h3>Recommendations to Improve Speed</h3>
        <ol>
          <li><strong>Cache the <code>validated_value</code>:</strong> Implement more aggressive caching and reduce reliance on real-time validation.</li>
          <li><strong>Optimize the <code>fetch_validated</code> process:</strong> Limit retries or check for updated values less frequently.</li>
          <li><strong>Disable features like <code>web_search</code>:</strong> Only enable it if explicitly needed.</li>
          <li><strong>Reduce retry attempts and exponential backoff delays:</strong> Optimize for faster error recovery in non-critical use cases.</li>
        </ol>
      </td>

    </tr>

  </tbody>
</table>
</div>
</details>

### Retriever Control

Just like style, the retrievers too have an effect on model answer. A model with with a more complete or relevant retrieval will likely produce a better answer.
Similar to style-control, the retriever-controlled leaderboard separates the effect of the retrievers from the answer model ranking.

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">Rank</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Arena Score</th>
      <th style="padding: 8px; border: 1px solid lightgray;">95% CI</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Org.</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">1</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">GPT 4o (20241120)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1088</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+12 | -10</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">OpenAI</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">2</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">DeepSeek V3</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1032</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+24 | -21</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">DeepSeek</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">3</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Claude 3.5 Sonnet (20241022)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1015</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+16 | -10</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Anthropic</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">4</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Gemini 2.0 Flash Exp</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1005</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+15 | -13</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Google</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">5</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Gemini 1.5 Pro</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">973</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+20 | -16</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Google</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">6</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">GPT 4o mini (20240718)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">971</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+23 | -17</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">OpenAI</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">7</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">LLaMA 3.1 405B Instruct FP8</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">914</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+14 | -22</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Meta</td>
    </tr>
  </tbody>
</table>
</div>

<p style="color:gray; text-align: center;">Table 5. Retriever-controlled arena ratings of the answer models. </p>
The retriever-controlled leaderboard shows only slight differences from the original, as the two chosen retrievers perform similarly and have little influence on the rankings

### Style + Retriever Control

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
<table style="width:100%; border-collapse: collapse; border: 1px solid lightgray; background-color: white;">
  <thead style="background-color: #cbe8f1; font-weight: bold; border-bottom: 1px solid lightgray;">
    <tr>
      <th style="padding: 8px; border: 1px solid lightgray;">Rank</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Model</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Arena Score</th>
      <th style="padding: 8px; border: 1px solid lightgray;">95% CI</th>
      <th style="padding: 8px; border: 1px solid lightgray;">Org.</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">1</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Claude 3.5 Sonnet (20241022)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1031</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+28 | -17</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Anthropic</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">2</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">GPT 4o (20241120)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1028</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+23 | -24</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">OpenAI</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">3</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">DeepSeek V3</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1016</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+27 | -25</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">DeepSeek</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">4</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Gemini 1.5 Pro</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">1007</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+21 | -25</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Google</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">5</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Gemini 2.0 Flash Exp</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">997</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+20 | -23</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Google</td>
    </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">6</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">GPT 4o mini (20240718)</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">963</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+26 | -24</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">OpenAI</td>
    </tr>
    <tr style="background-color: white;">
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">7</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">LLaMA 3.1 405B Instruct FP8</td>
      <td style="padding: 8px; text-align: left; border: 1px solid lightgray; font-weight: 500;">956</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">+23 | -23</td>
      <td style="padding: 8px; border: 1px solid lightgray; font-weight: 500;">Meta</td>
    </tr>
  </tbody>
</table>
</div>

<p style="color:gray; text-align: center;">Table 6. Style-and-retriever-controlled arena ratings of the answer models. </p>

### Leaderboard Calculation

How do we get separate leaderboards for the retrievers and the answer models from one set of battles? Extra features!

Chabot Arena leverages the [**Bradley-Terry**](https://en.wikipedia.org/wiki/Bradley%E2%80%93Terry_model) model for scoring model strength using pairwise battles. We adopt its [**statistical extension**](https://blog.lmarena.ai/blog/2024/extended-arena/) to evaluate the additional subparts–the retrievers–by integrating them as extra features just like the answer models. Each retriever feature takes values from {-1, 0, 1}, indicating whether it was active in the file retrieval for model_a, neither/both, or model_b, respectively. By performing Logistic Regression on these additional retriever features along with the original model features, we obtain coefficients that are later scaled to become the leaderboard scores.
<img src="/assets/img/blog/repochat_arena/PIC_winrates.png" alt="Model Pairwise Winrates" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">

<p style="color:gray; text-align: center;">Figure 88. Fraction of model A wins for all non-tied battles.</p>

## What's Next?

We are actively collecting more votes and integrating new models, with plans for more comprehensive analysis down the line. Additionally, we are exploring ways to enhance RepoChat by incorporating features such as support for private repositories, GitLab integration, and improvements to our retrieval process. Community contributions are welcome—feel free to ping us if you'd like to get involved!

## Appendix

- **High level questions about a repository:**
  - [https://github.com/lllyasviel/ControlNet](https://github.com/lllyasviel/ControlNet)<br>"Explain"
  - [https://github.com/remix-run/react-router](https://github.com/remix-run/react-router)<br>"How to use this repo?"
- **Specific how-to questions:**

  - [https://github.com/leecig/OpenDevin/tree/main](https://github.com/leecig/OpenDevin/tree/main)<br>"How do I use a local LLM being ran by LMStudio?"
  - [https://github.com/ohmyzsh/ohmyzsh/](https://github.com/ohmyzsh/ohmyzsh/)<br>"Tell me, what it means and how to use the `kubectx_mapping` in the plugins/kubectx?"

- **Implementation requests:**

  - [https://github.com/varungodbole/prompt-tuning-playbook](https://github.com/varungodbole/prompt-tuning-playbook)<br>"Help me design a system prompt to extract metrics from financial reports."
  - [https://github.com/ocaml/ocaml](https://github.com/ocaml/ocaml)<br>"If I wanted to implement partial escape analysis, which of the OCaml Intermediate Representations would be best suited and where should I make the change?"

- **Specific explanation requests:**

  - [https://github.com/ant-design/ant-design](https://github.com/ant-design/ant-design)<br>"Why does Ant Design 5 decide to use CSS-in-JS?"
  - [https://github.com/celzero/rethink-app](https://github.com/celzero/rethink-app)<br>"How are connection/network changes handled?"

- **Requests for solving an issue:**

  - [https://github.com/HALF111/calibration_CDS](https://github.com/HALF111/calibration_CDS)<br>"Solve this issue."
  - [https://github.com/pyca/cryptography/issues/7189](https://github.com/pyca/cryptography/issues/7189)<br>"Using asyncssh can fix the immediate loading error for the PEM file, but when accessing `cert.extensions` it still errors out with the same ordering issue."

- **Requests for reviewing a PR:** - [https://github.com/fairy-stockfish/Fairy-Stockfish/pull/758](https://github.com/fairy-stockfish/Fairy-Stockfish/pull/758)<br>"Review this PR." - [https://github.com/ggerganov/llama.cpp/pull/10455](https://github.com/ggerganov/llama.cpp/pull/10455)<br>"What type of speculative decoding is supported with this pull request?
  "

- **Queries with code snippets, requests for modifying existing code, and debugging:** (click the arrow to expand the full query)

  - [https://github.com/julien-blanchon/arxflix/tree/feat/groq_whisper](https://github.com/julien-blanchon/arxflix/tree/feat/groq_whisper)<br>
    <details>
      <summary>"when using the gradio interface, the stage of generating video get me this error :</summary> 
      <pre style="background-color: #f9f9f9; padding: 8px; border: 1px solid lightgray; font-family: monospace;">
      INFO:__main__:Generated assets successfully.
      INFO:backend.main:Generating video to output.mp4 from tmpmpc_r1vm
      Free port: 55427
      Exposed directory /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm
      Starting up http-server, serving /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm

    http-server version: 14.1.1

    http-server settings:
    CORS: true
    Cache: 3600 seconds
    Connection Timeout: 120 seconds
    Directory Listings: visible
    AutoIndex: visible
    Serve GZIP Files: false
    Serve Brotli Files: false
    Default File Extension: none

    Available on:
    http://localhost:55427
    Hit CTRL-C to stop the server

    INFO:backend.utils.generate_video:Exposed directory /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm
    INFO:backend.utils.generate_video:Generating video to /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm/output.mp4
    (node:93666) ExperimentalWarning: CommonJS module /opt/homebrew/lib/node_modules/npm/node_modules/debug/src/node.js is loading ES Module /opt/homebrew/lib/node_modules/npm/node_modules/supports-color/index.js using require().
    Support for loading ES Module in require() is an experimental feature and might change at any time
    (Use `node --trace-warnings ...` to show where the warning was created)
    Bundled code ━━━━━━━━━━━━━━━━━━ 550ms
    [Fri Dec 06 2024 00:02:39 GMT+0100 (Central European Standard Time)] "GET /audio.wav" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/131.0.6778.87 Safari/537.36"
    (node:93654) [DEP0066] DeprecationWarning: OutgoingMessage.prototype.\_headers is deprecated
    (Use `node --trace-deprecation ...` to show where the warning was created)
    Composition Arxflix
    Codec h264
    Output /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm/output.mp4
    Concurrency 1x
    Rendering frames ━━━━━━━━━━━━━━━━━━ 0/2353
    Encoding video ━━━━━━━━━━━━━━━━━━ 0/2353[Fri Dec 06 2024 00:02:39 GMT+0100 (Central European Standard Time)] "GET /subtitles.srt" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/131.0.6778.87 Safari/537.36"
    [Fri Dec 06 2024 00:02:39 GMT+0100 (Central European Standard Time)] "GET /rich.json" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/131.0.6778.87 Safari/537.36"
    node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:187 Error: No "src" prop was passed to <Img>.
    at ImgRefForwarding (http://localhost:3000/bundle.js:26884:15)
    at Nh (http://localhost:3000/bundle.js:25838:137)
    at Yi (http://localhost:3000/bundle.js:25870:57)
    at Vk (http://localhost:3000/bundle.js:25971:275)
    at Uk (http://localhost:3000/bundle.js:25957:389)
    at Tk (http://localhost:3000/bundle.js:25957:320)
    at Ik (http://localhost:3000/bundle.js:25957:180)
    at Nk (http://localhost:3000/bundle.js:25948:88)
    at Gk (http://localhost:3000/bundle.js:25945:429)
    at J (http://localhost:3000/bundle.js:34117:203)

    An error occurred while rendering frame 0:
    Error No "src" prop was passed to <Img>.

    at node_modules/.pnpm/remotion@4.0.171_react-dom@18.3.1_react@18.3.1__react@18.3.1/node_modules/remotion/dist/cjs/Img.js:19
    17 │ const { delayPlayback } = (0, use_buffer_state_js_1.useBufferState)();
    18 │ const sequenceContext = (0, react_1.useContext)(SequenceContext_js_1.SequenceContext);
    19 │ if (!src) {
    20 │ throw new Error('No "src" prop was passed to <Img>.');
    21 │ }
    22 │ (0, react_1.useImperativeHandle)(ref, () => {

    at Nh (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:159)
    at Yi (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:191)
    at Vk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:292)
    at Uk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:278)
    at Tk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:278)
    at Ik (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:278)
    at Nk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:269)
    at Gk (node_modules/.pnpm/react-dom@18.3.1_react@18.3.1/node_modules/react-dom/cjs/react-dom.production.min.js:266)
    at J (node_modules/.pnpm/scheduler@0.23.2/node_modules/scheduler/cjs/scheduler.production.min.js:12)
    at R (node_modules/.pnpm/scheduler@0.23.2/node_modules/scheduler/cjs/scheduler.production.min.js:13)
    INFO:backend.utils.generate_video:Generated video to /var/folders/3j/jv5_hbgn59g9yxccxtfcvz4r0000gp/T/tmpmpc_r1vm/output.mp4
    http-server stopped.
    INFO:**main**:Generated video successfully.
    ^CKeyboard interruption in main thread... closing server.
      </pre>"
      
    </details>

  - [https://github.com/feathers-studio/telegraf-docs](https://github.com/feathers-studio/telegraf-docs)<br>
    <details>
      <summary>"bot.js:</summary>

      <pre style="background-color: #f9f9f9; padding: 8px; border: 1px solid lightgray; font-family: monospace;">
      require("dotenv").config();
    
      const { Telegraf, session } = require("telegraf");
      const { registerCommands } = require("./commands");
      const { registerHears } = require("./hears");
      const { registerScenes } = require("./scenes");
      const sequelize = require("./database");
      const User = require("./models/user");
      const { t, i18next } = require("./i18n");
      const Plans = require("./models/plans");
    
      // sync database
      (async () => {
      try {
          await sequelize.sync({ force: true });
          console.log("database synchronized successfully.");
    
          const bot = new Telegraf(process.env.BOT_TOKEN);
    
          const defaultPlan = await Plans.findOne({ where: { isDefault: true } });
          if (!defaultPlan) {
          await Plans.create({
              name: "atom",
              isDefault: true,
              price: 0,
          });
          console.log("default plan created.");
          }
    
          // telegraf.js sessions
          bot.use(
          session({
              defaultSession: () => ({ counter: 0, userName: "" }), // Initialize session variables
          })
          );
          // user check/creation middleware
          bot.use(async (ctx, next) => {
          const telegramId = ctx.from.id;
          try {
              let user = await User.findOne({ where: { telegramId } });
              if (!user) {
              user = await User.create({
                  name: ctx.from.first_name || "unknown",
                  telegramId: telegramId,
              });
              console.log(
                  `new user created: ${user.name} (id: ${user.telegramId})`
              );
              }
    
              ctx.session.isAuthorized = true;
              ctx.session.user = user;
              ctx.session.language = user.language || "ru";
    
              i18next.changeLanguage(ctx.session.language);
              return next();
          } catch (error) {
              console.error("error during user check/creation:", error);
              return ctx.reply(t("error_user_creation"));
          }
          });
    
          // register commands, hears, and scenes
          registerCommands(bot);
          registerHears(bot);
          registerScenes(bot);
    
          // start the bot
          bot.launch();
          console.log("bot is running.");
    
          // enable graceful stop
          process.once("SIGINT", () => bot.stop("SIGINT"));
          process.once("SIGTERM", () => bot.stop("SIGTERM"));
      } catch (error) {
          console.error("error initializing bot:", error);
      }
      })();
      </pre>

    don't do check in database at every message, but have a kind of cache in telegraf.js session"

    </details>
