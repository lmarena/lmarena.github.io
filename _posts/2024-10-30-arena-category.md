---
layout: distill
title: Chatbot Arena Categories
description: Definitions, Methods, and Insights

giscus_comments: true
date: 2024-10-29
featured: true
thumbnail: assets/img/blog/arena_category/pfp.png
authors:
  - name: Tianle Li
    url: "https://codingwithtim.github.io/"
    affiliations:
      name: UC Berkeley
  - name: Yifan Song
    url: "https://www.linkedin.com/in/yf-song/"
  - name: Evan Frick
    url: "https://efrick2002.github.io/"
  - name: Wei-Lin Chiang
    url: "https://infwinston.github.io/"
  - name: Anastasios N. Angelopoulos
    url: "http://angelopoulos.ai"
---

## Introduction

While the overall Chatbot Arena leaderboard provides a simple score for each model, people use LLMs for diverse purposes. This raises the question: which model is best for a specific use-case? To offer deeper insights into this question, we have been adding various categories to our leaderboard.
Over time, we've introduced a wide array of categories, including hard prompts, instruction-following, math prompts, coding prompts, refusal handling, longer queries, multi-turn conversations, various languages, and style control. Today, we're excited to announce the release of a new category: creative writing!

In this blog post, we'll explain:

- Key insights from our categorical analysis, including how the topic distribution varies with time
- The deployment process for new categories
- The definition of each category currently in Chatbot Arena
- How the community can contribute to improve and add categories

## Why Categorize?

Language models don’t shine equally in different areas. Some tasks may require the precise execution of instructions, while others push the model’s ability to reason through complex math problems or handle long, multi-turn conversations. By grouping tasks into categories, we can assess models' strengths and weaknesses in a more granular way.
We acknowledge that a high-ranking on the overall leaderboard doesn’t imply the model will excel across the board in every situation. Categories help elucidate these nuances, allowing our users to identify which models are best suited for their specific needs.

<p style="color:gray; text-align: center;">Table 1. Chatbot Arena Leaderboard Overview.</p>
<table class="tg" style="justify-content: center;">
  <colgroup>
    <col style="width: 28%; border-right: 1px solid grey; padding: 8px;">
    <col style="width: 10%; border-right: 1px solid grey; padding: 8px;">
    <col style="width: 12%; border-right: 1px solid grey; padding: 8px;">
    <col style="width: 10%; border-right: 1px solid grey; padding: 8px;">
    <col style="width: 10%; border-right: 1px solid grey; padding: 8px;">
    <col style="width: 10%; border-right: 1px solid grey; padding: 8px;"> 
    <col style="width: 10%; border-right: 1px solid grey; padding: 8px;">
    <col style="width: 10%; border-right: 1px solid grey; padding: 8px;"> 
  </colgroup>
    <thead>
        <tr>
            <th>Model</th>
            <th>Overall</th>
            <th>Style Control</th>
            <th>Math</th>
            <th>Hard Prompt</th>
            <th>Coding</th>
            <th>Instruction Following</th>
            <th>Creative Writing</th>
        </tr>
    </thead>
    <tbody>
        <!-- <tr>
            <td>chatgpt-4o-latest</td>
            <td style="background-color: #EFBF04; color: black">1</td>
            <td style="background-color: #EFBF04; color: black">1</td>
            <td style="background-color: #C0C0C0; color: black">2</td>
            <td style="background-color: #EFBF04; color: black">1</td>
            <td style="background-color: #C0C0C0; color: black">2</td>
            <td style="background-color: #CD7F32; color: black">3</td>
        </tr> -->
    <tr>
      <td>chatgpt-4o-latest</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td style="background-color: #C0C0C0; color: black">2</td>
      <td style="background-color: #C0C0C0; color: black">2</td>
      <td style="background-color: #C0C0C0; color: black">2</td>
      <td style="background-color: #EFBF04; color: black">1</td>
    </tr>
    <tr>
      <td>o1-preview</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #C0C0C0; color: black">2</td>
    </tr>
    <tr>
      <td>o1-mini</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td>5</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #EFBF04; color: black">1</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td>14</td>
    </tr>
    <tr>
      <td>gemini-1.5-pro-002</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td>4</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td>4</td>
      <td>5</td>
      <td>4</td>
      <td style="background-color: #C0C0C0; color: black">2</td>
    </tr>
    <tr>
      <td>grok-2</td>
      <td>5</td>
      <td>8</td>
      <td>5</td>
      <td>7</td>
      <td>5</td>
      <td>6</td>
      <td>4</td>
    </tr>
    <tr>
      <td>claude-3-5-sonnet-1022</td>
      <td>5</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td>4</td>
      <td style="background-color: #C0C0C0; color: black">2</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td>4</td>
    </tr>
    <tr>
      <td>gpt-4o-05-13</td>
      <td>6</td>
      <td>5</td>
      <td>7</td>
      <td>6</td>
      <td>5</td>
      <td>5</td>
      <td>4</td>
    </tr>
    <tr>
      <td>yi-lightning</td>
      <td>6</td>
      <td>13</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td>4</td>
      <td>5</td>
      <td>5</td>
      <td>4</td>
    </tr>
    <tr>
      <td>glm-4-plus</td>
      <td>8</td>
      <td>15</td>
      <td>8</td>
      <td>7</td>
      <td>5</td>
      <td>7</td>
      <td>5</td>
    </tr>
    <tr>
      <td>gpt-4o-mini</td>
      <td>9</td>
      <td>16</td>
      <td>13</td>
      <td>9</td>
      <td>5</td>
      <td>10</td>
      <td>5</td>
    </tr>
    <tr>
      <td>gemini-1.5-flash-002</td>
      <td>9</td>
      <td>18</td>
      <td>11</td>
      <td>18</td>
      <td>19</td>
      <td>10</td>
      <td>4</td>
    </tr>
    <tr>
      <td>claude-3-5-sonnet-0620</td>
      <td>9</td>
      <td>5</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td>7</td>
      <td>5</td>
      <td>6</td>
      <td>18</td>
    </tr>
    <tr>
      <td>grok-2-mini</td>
      <td>9</td>
      <td>22</td>
      <td>8</td>
      <td>11</td>
      <td>15</td>
      <td>13</td>
      <td>15</td>
    </tr>
    <!-- <tr>
      <td>llama-3.1-nemotron-70b</td>
      <td>9</td>
      <td>27</td>
      <td style="background-color: #CD7F32; color: black">3</td>
      <td>7</td>
      <td>5</td>
      <td>9</td>
      <td>6</td>
    </tr> -->
    <!-- <tr>
      <td>llama-3.1-405b</td>
      <td>9</td>
      <td>7</td>
      <td>8</td>
      <td>9</td>
      <td>8</td>
      <td>9</td>
      <td>6</td>
    </tr>
    <tr>
      <td>gpt-4o-08-06</td>
      <td>10</td>
      <td>8</td>
      <td>7</td>
      <td>9</td>
      <td>8</td>
      <td>10</td>
      <td>5</td>
    </tr> -->
    </tbody>
</table>

## New Category: Creative Writing!

Our newest category, creative writing, evaluates a model's ability to craft original, imaginative, and emotionally resonant content. Unlike straightforward writing tasks, creative writing prompts involve originality, artistic expression, and often, a different kind of thinking compared to more technical prompts. For instance, while "write a thank-you email" wouldn't qualify as creative writing, "write a humorously sarcastic thank-you email" would. The category encompasses traditional creative formats (stories, poems, lyrics) and extends to areas like joke creation, meme explanation, and responses to philosophical questions that can't be answered through simple fact-checking.

We note that this category is in a sense, orthogonal, to our previously introduced categories, such as Math and Coding. As such, we find interesting differences in rankings when looking at creative prompts. Studying categories like creativity is important— the ranking signal on this type of prompts are innately dependent on human preference, and are difficult to obtain from traditional close-ended benchmarks without human-in-the-loop.

<img src="/assets/img/blog/arena_category/creative_prompt_diff_1.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 1: Ranking deltas from Overall Leaderboard to Creative Prompt Leaderboard.</p>

## Defining and assigning the categories

So, how is the creative writing category created? It all starts with the definition. A category can be thought of as a grouping of prompts based on the common skills required to respond effectively. Categories can be well defined (e.g. prompts longer than 500 tokens) or more ambiguous. One prompt could also be classified with multiple categories. Consider the “creative” category— how can we even define prompts that require creativity? In the following sections, we will walk you through how we construct a category in Chatbot Arena.

First, we define each category with a checklist. If enough items in the checklist are satisfied, the prompt is labeled as an element of that category. For “Creative Writing” that checklist looks like this:

What qualifies as creative writing?

- Prompts requiring originality and imagination
- Tasks involving emotional or artistic expression
- Requests for unique perspectives or interpretative responses
- Writing that goes beyond factual reporting or analysis

We include example creative writing prompts in the Appendix [link](#example-prompts). Additionally we also detail the definitions of other categories, including Math, Hard Prompt, Instruction-Following, Code, and various languages in the Appendix [link](#more-category-definitions).

Defining categories is one thing—deploying them at scale is another. With over 2 million prompts, category classification cannot be done by hand. While some categories (eg. Language, Code) can use heuristic algorithms for fast classification, others (eg. Creative Writing, Hard Prompt) cannot. For categories like Creative Writing, we build a fast and robust category classification system using an LLM. We prompt the LLM with the category checklist, and judge whether the prompt satisfies the checklist.

Of course, it is crucial to verify whether the classifications made by the LLM judge are within the desired specifications. To do this we check the classification performance on a wide sample of Chatbot Arena prompts. As a whole, we call this auto-evaluation pipeline Label Bench, which we define in detail below.

### Label Bench

The Label Bench framework is as follows:

1. Initial Prompt Design: An prototype system prompt is carefully crafted based on a determined definition of the category. Extensive manual testing should be conducted to ensure the system prompt is high-quality.
2. Ground Truth Labeling: Random sample 2000-5000 battles from Chatbot Arena. Employing one or multiple strong LLMs (eg. Claude 3.5 Sonnet) to annotate ground truth labels for each battle. A manual check can be conducted to ensure reasonable accuracy.
3. Optimization: Employ a smaller, open-source model for classification. Remove any COT in the system prompt for additional inference speed up.
   Verification: Evaluate the smaller classifier against the ground truth labels on the sample battles. We typically iterate until reaching a high precision and recall.
4. Deploy: The best classifier and optimal system prompt are chosen to label the entire Chatbot Arena dataset.

For example, when developing our new creative prompt category using the Label Bench framework, we found that with no CoT, Llama-3.1-70B-Instruct classified the prompts with 96.1% accuracy (precision: 66.7%, recall: 96.6%) with respect to high-quality labels generated by GPT-4o-mini with CoT. We also cross check this classifier against labels generated by Claude 3.5 Sonnet with COT. After ensuring its performance, we deployed this scalable LLM for the final labeling of our 2 million battle prompts.

After data labeling, we can compute the Chatbot Arena leaderboard only on the subset of Arena battles labeled as belonging to the category in order to produce a category-specific leaderboard.

## Data Analysis

With the groundwork of category creation completed, we can now delve into the meaningful results: statistical trends, categorical correlations, and insights into models’ strengths and weaknesses.

### Categories over Time

Are people asking harder questions as LLMs become better? We found the answer is **yes**! The percentage of Hard Prompts, Instruction-Following, Coding, and Math prompts has been increasing since Chatbot Arena’s launch back in April 2023.

<img src="/assets/img/blog/arena_category/timeseries.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%">
<p style="color:gray; text-align: center;">Figure 2: Percentage of Chatbot Arena Battles belonging to each category over time.</p>

The data also reveals some interesting seasonal variations in prompt complexity. For example, we observe an increase in the percentage of hard prompts during the school year, when students may be asking difficult homework-related questions.

### Relationships between categories

One way to assess the relationship between categories is to compare their leaderboards. Similar categories may have similar leaderboards. In this subsection we compare the leaderboards of different categories via their Kendall rank correlations.

<img src="/assets/img/blog/arena_category/kendall_technical_cluster.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 3: Kendall Rank Correlations between Chatbot Arena Leaderboards (Task-specific Categories). Similar leaderboards are clustered together. SC means Style Control.</p>

Figure 3 reports the Kendall correlations. First, technical leaderboards (Coding, Math, and Hard Prompt) tend to be more correlated with one another compared with Creative Writing. Secondly, consistent with the fact that it is a mixture of them all, the overall leaderboard is moderately correlated with all categories. The highest-correlation category with the overall leaderboard is Instruction-Following. Finally, it is worth mentioning that all these correlations are relatively high; the differences between categories are on the smaller side, although not insignificant.

<img src="/assets/img/blog/arena_category/kendall_language_cluster.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 4. Kendall Rank Correlations between Chatbot Arena Leaderboards (Language Categories). Similar leaderboards are clustered together. SC means Style Control.</p>

Above Figure 4 reports the Kendall correlation between different languages. Latin based languages exhibit higher correlations with one another. Chinese is most highly correlated with Japanese. Korean exhibits weaker correlations with the other languages.

## Model Insights

Now that we’ve examined the broad relationships between categories, let's dive deeper into how individual models perform across different tasks. Understanding these performance patterns is crucial for both users and developers, as it reveals the specialized strengths and potential limitations of each model. By analyzing win-rates across categories and comparing models with similar overall performance, we can uncover nuanced insights that might be obscured in the overall leaderboard rankings.

<img src="/assets/img/blog/arena_category/o1_mini_dark.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 5. o1 Mini’s win-rate conditioned on categories as fitted using a standard decision tree algorithm. Blue indicates o1 Mini wins more often while orange means o1 Mini loses. The selected battles are o1 mini against other models with similar performances (grok-2-2024-08-13, gemini-1.5-pro-002, o1-preview, gpt-4o-mini-2024-07-18, gpt-4o-2024-05-13, chatgpt-4o-latest-20240903).</p>

In Figure 5, we observed o1 Mini’s win-rate conditioned on specific categories, providing a visual map of its strengths and weaknesses. In math and hard prompts, o1 Mini performs significantly better, indicated by the blue half of the decision tree. On the other hand, o1 Mini struggles on creative prompts when compared to other models.

<img src="/assets/img/blog/arena_category/gemini-1.5-pro-2_dark.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 6. Gemini-1.5-Pro-002’s win-rate conditioned on categories as fitted using a standard decision tree algorithm. The selected battles are Gemini-1.5-Pro-002 against top Chatbot Arena models (o1-preview, o1-mini, chatgpt-4o-latest-20240903, claude-3-5-sonnet-20240620, yi-lightning).</p>

Unlike o1-mini, Gemini-1.5-Pro-002 demonstrates exceptional performance on creative prompts compared to other top models, as illustrated in Figure 6. However, its performance on coding tasks remains a notable weakness.

<img src="/assets/img/blog/arena_category/yi-lightning_dark.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 7. Yi-Lightning’s win-rate conditioned on categories as fitted using a standard decision tree algorithm. The selected battles are Yi-Lightning against top Chatbot Arena models (o1-mini, gemini-1.5-pro-002, gpt-4o-2024-05-13, claude-3-5-sonnet-20240620, glm-4-plus).</p>

Our analysis of Yi-Lightning, a recent state-of-the-art Chinese LLM, also shows interesting performance patterns. As shown in Figure 7, Yi-Lightning excels at handling complex prompts but shows relatively weaker performance in following basic instructions compared to other top models. Notably, when instruction-following tasks incorporate creative elements, Yi-Lightning's performance improves.

## Community Contribution

Want to see another category on the leaderboard? Contribute! Our project is open-source, and we’re excited to invite contributions from the community. Whether you have ideas for new categories (not just text, even for vision models), suggestions for refining existing ones, or even want to improve our classifiers, there’s plenty of room for collaboration.

Code for the classifier: [repo link](https://github.com/lm-sys/FastChat/tree/main/fastchat/serve/monitor/classify)

Micro Label Benchmark: [huggingface link](https://huggingface.co/datasets/lmarena-ai/categories-benchmark-eval)

🚀 Join Us in Making Chatbot Arena Even Better!

We’d love your help in enhancing Chatbot Arena! Whether it’s tuning and improving our classifiers, validating results, or even suggesting new categories we haven’t explored yet, every contribution makes a difference.

Together, we can shape the future of LLM evaluation and create tools that truly serve the community. Let’s push the boundaries and make Chatbot Arena the best it can be!

## Citation

```
@misc{chiang2024chatbot,
    title={Chatbot Arena: An Open Platform for Evaluating LLMs by Human Preference},
    author={Wei-Lin Chiang and Lianmin Zheng and Ying Sheng and Anastasios Nikolas Angelopoulos and Tianle Li and Dacheng Li and Hao Zhang and Banghua Zhu and Michael Jordan and Joseph E. Gonzalez and Ion Stoica},
    year={2024},
    eprint={2403.04132},
    archivePrefix={arXiv},
    primaryClass={cs.AI}
}
```

## Appendix

### More Category Definitions

We now go into detail on other categories and the checklists we used to define them.

### Hard Prompt

Hard Prompt category features user-submitted prompts from the Arena that are specifically designed to be more complex, demanding, and rigorous. Carefully curated, these prompts test the capabilities of the latest language models, providing valuable insights into their strengths and weaknesses in tackling challenging tasks.

What are the important criteria for a prompt to be “Hard”?

- Specificity: Being specific, well-defined, and without ambiguity.
- Domain Knowledge: Tests the AI’s knowledge and understanding in a specific domain or set of domains.
- Complexity: Has multiple levels of reasoning, components, or variables.
- Problem-Solving: Requires active problem-solving: analyzing and clearly defining the problem and systematically devising and implementing a solution.
- Creativity: Involves a level of creativity when approaching the problem.
- Technical Accuracy: Requires a high degree of technical accuracy, correctness and precision.
- Real-world Application: Relates to real-world applications.

For more information, refer to the released blog dedicated to the Hard Prompt category [link](https://blog.lmarena.ai/blog/2024/hard-prompts/).

### Math

Mathematics evaluation focuses on a model's ability to actively apply mathematical reasoning and problem-solving skills. Contrary to prompts that merely seek explanations of mathematical concepts, these prompts require direct mathematical computation or logical deduction.

Mathematical Prompts:

- Requires active application of mathematical concepts
- Involves some sorts of numerical calculations or algebraic manipulations or geometrical reasoning
- Contains clear, well-defined, and objective problems
- Tests one or multiple mathematical competencies

For example, "Explain what a derivative is" wouldn't qualify as a math prompt, but "Find the derivative of f(x) = x³ + 2x² - 5x + 3" would. For more examples, see Appendix [link](#example-prompts).

### Instruction-Following

This category evaluates a model's ability to precisely follow given instructions, particularly focusing on multi-step tasks and specific requirements. Similar to the Hard Prompt category's emphasis on specificity and technical accuracy, instruction-following prompts zoom in on assessing the AI's capability to execute directions with precision and completeness. The category focuses specifically on the model's ability to understand and execute detailed instructions rather than on domain knowledge or problem-solving capabilities.

Instruction-following prompts include:

- Clear, actionable instructions from the user
- Specific formatting or structural requirements for the response
- Unique or challenging aspects that would test the AI's ability to follow directions precisely

For example, while "write about dogs" wouldn't qualify as an instruction-following prompt, "Write a 3-paragraph description of dogs, using exactly 5 adjectives per paragraph, and conclude with a bulleted list of 3 care tips" would. For more examples, see [link](#example-prompts).

### Coding

The coding category evaluates a model's capability to understand, generate, and debug code across different programming languages and paradigms. Unlike the previous categories, we employ a heuristic algorithm to classify coding prompts.

Our Coding Classifier looks for:

- Code blocks in prompt and responses
- Programming language names and keywords
- Code commands and other miscellaneous items

While traditional coding benchmarks target specific tasks (such as code editing or algorithm implementation), Chatbot Arena's coding category encompasses all code-related activities. Taking advantage of its open-ended nature, we evaluate models on complex, multi-layered software engineering tasks. For example, a prompt like "Help me build a professional website using TypeScript" assesses LLMs not only on code generation but also on broader software development decision-making capabilities. For more examples, see Appendix [link](#example-prompts).

### Languages

Each language category assesses a model's proficiency in responding to prompts within the language. Many Chatbot Arena users engage with LLMs in languages beyond English, testing models on their versatility, linguistic precision, and cultural context in many languages.

We tag each prompt with a language tag using [Polyglot](https://polyglot.readthedocs.io/en/latest/).

<img src="/assets/img/blog/arena_category/lang_histogram.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 100%">
<p style="color:gray; text-align: center;">Figure 8. Number of Chatbot Arena battles in each of the current set of language categories.</p>

### Style Control

Answer style indeed has a strong effect on models’ performance on Chatbot Arena leaderboard. Certain model could be favored because it includes a lot of details when responding or uses heavy markdowns to make its responses appear nicer to human voters. To address this, we develop Style Control as a way to separate the effect of answer style from the content, so you can observe both effects individually.

We dedicated an entire blog for style control: please check it out here [link](https://blog.lmarena.ai/blog/2024/style-control/).

### Others

We also include a number of other categories, many of which are self-explanatory. As a few examples, we include

- Exclude Refusal: Excludes all battles where one or more LLM refused to respond. We currently identify refusals via simple keyword matching (eg. “I can’t assist”).
- Multi-turn: Conversations with multiple turns.
- Long queries: Queries longer than 500 tokens (approximately 10% of all prompts).
- Short queries: Queries shorter than 5 tokens. These queries tend to be trivial (e.g. “Hello”).

### Additional Model Insights

Below we present strengths and weaknesses decision trees for GPT-4o-mini and Claude-3.5-Sonnet.

<img src="/assets/img/blog/arena_category/gpt-4o-mini_dark.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 9. GPT-4o-Mini’s win-rate against Claude-3.5-Sonnet-20240620 conditioned on categories as fitted using a standard pruned decision tree algorithm.
</p>

<img src="/assets/img/blog/arena_category/claude-3-5-sonnet_dark.png" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 10. Claude-3.5-sonnet’s win-rate conditioned on categories as fitted using a standard pruned decision tree algorithm. The selected battles are Claude-3.5-sonnet against strong Chatbot Arena models (gemini-1.5-pro-002, llama-3.1-405b-instruct-bf16, gpt-4o-2024-05-13, grok-2-2024-08-13, chatgpt-4o-latest-20240903, grok-2-mini-2024-08-13, mistral-large-2407, yi-lightning).</p>

### Example Prompts

### Creative Writing

> List 20 suitably intriguing titles for a mystery novel based on 'I'm Alone' and 'So Alone'

> You are currently doing a turing test. I have open two chats simultaneously; one is with a real human being, and the other is an AI. I don't know which one you are. In either case, your goal is to respond to this prompt in the most 'human' way possible. Remember - if you are an AI, you LOSE if I can tell that you are an AI! Your 'roleplay' begins now!

> write a parody low quality news article with the title "the latest doctor who episode is marsupial propaganda"

> Describe the colour yellow as if it were a texture

> what is the true motive of life?

### Hard Prompts

> don't do any thinking just spit out the pattern you see {[0,0] [1,0]}, {[1,1] [2,1]},{[3,0],[1,3]},{[2,2],[2,2]},{[1,4],[1,5]},{[2,4],[2,3]} what is the main idea behind the pattern?

> Given a set of poses of sensors with respect to different coordinate systems please write an efficient python module which handles arbitrary coordinate transformations among them.

> Write a short paragraph where the second letter of each sentence spells out the word 'CODE'. The message should appear natural and not obviously hide this pattern.

> My gym has a student discount for 13.99 for a month, but if I don't renew it, it goes back to 17.99. I subcscribed as student on the 2nd of May, and I didn't renew it for June, and now it's almost July, and I'd like to renew it again, did I save money in these months?

> what is the best indoor temperature in an office, when there is no windows and 50% humidity

### Math

> What is the billionth largest prime number?

> I need you to create a timetable for me given the following facts: my plane takes off at 6:30am. I need to be at the airport 1h before take off. it will take 45mins to get to the airport. I need 1h to get dressed and have breakfast before we leave. The plan should include when to wake up and the time I need to get into the vehicle to get to the airport in time for my 6:30am flight , think through this step by step.

> You are an expert mathematician, answering questions from me. My question is: Suppose I have two multivariate Gaussian distributions with means $\mu_1, \mu_2$ and covariance matrices $\Sigma_1, \Sigma_2$. Suppose I calculate the Wasserstein-2 distance between the two distributions. This has a closed form. What is the derivative of the distance with respect to the mean and covariance matrices?

> x^2 + x + 2 =0. Solve for x.

> In a standard deck of playing cards, what is the likelihood of drawing an Ace as the first card?\na) Likely\nb) Unlikely

### Instruction Following

> In my kitchen, there's a table with a cup with a ball inside. I moved the cup to my bed in my bedroom and turned the cup upside down. I grabbed the cup again and moved to the main room. Where's the ball now?\n\nThink step by step\nSay the final answer in the end. Like this FINAL ANSWER: answer.

> Give me a list of 10 natural numbers, such that at least one is prime, at least 6 are odd, at least 2 are powers of 2, and such that the 10 numbers have at minimum 25 digits between them.

> Design a comprehensive simulation environment for drafting and playing 1000 games of Magic the Gathering using a 540 card cube. The simulation should accurately model the card selection process, deck construction, and gameplay, including factors such as mana curve, card interactions, and strategic decision-making. Evaluate the performance of various draft strategies and archetypes, identifying the most successful approaches and analyzing the key factors contributing to their success. Provide detailed statistics and visualizations to illustrate the results, including win rates, color combinations, and card popularity. Additionally, assess the impact of different card rarities and archetypes on the overall draft and gameplay experience.

> You are an expert research assistant who never makes assumptions. When asked a question you formulate no less than three different answers, then you carefully judge each answer for its factual correctness, and you assign a percentage confidence you have about each answer. If you cannot determine factual correctness, just answer with \"I'm not confident in my response\" and also explain, to the best of your ability, the percentage confidence you have in your answer.\n\nThe question is: explain reverse epigenetic inheritance

> Hi, could you please help me complete the following linguistic task?:\n\***\*\_\_\*\***\nComplete the second sentence so that it has a similar meaning to the first one, using the word given. You must use between three and eight words, including the word given, which has to be used, and put them inside the {gap} in the second sentence. Do not change the grammatical form of the word given. Do not, under any circumstances, add any words outside the gap in the second sentence. You absolutely have to construct the second sentence so that it explicitly conveys all the information contained in the first sentence.\n\nFirst sentence: Martina was very annoyed that her son had borrowed her new bike.\nThe word given: great\nSecond sentence: To {gap} borrowed her new bike.\n\***\*\_\_\*\***\n

### Coding

> if(!os.exist())\n os.makedirs(os.path.join(FLAGS.logdir, 'sample'))

> User\nWrite me a bash script that lists all avaliable pulse audio sinks and for each sink the conect source-inputs. \nThe output shall look like this:\nSink1\n Input1\n Input2
> considering a df with Open, High, Low, Close, Volume I need to predict the Close price of the next day. How it is possible with LSTM model?

> print(sum(squares of [(populations mod 23) of the US over the last 3 years]))\n\nconvert this to python and show the results\n\n\n\n

> What's the flaw with this code?\n\npython\n def has_conflict(self, new_data):\n if not os.path.exists(self.local_path):\n return False\n \n local_modified_at = datetime.fromtimestamp(os.path.getmtime(self.local_path), tz=datetime.now().astimezone().tzinfo)\n local_synced_at = self.modified_at\n remote_modified_at = datetime.fromisoformat(new_data['modified_at'])\n\n if local_modified_at != local_synced_at and local_modified_at != remote_modified_at:\n return True\n \n return False\n
