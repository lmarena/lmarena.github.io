---
layout: distill
title: "WebDev Arena"
description: A Live LLM Leaderboard for Web App Development
giscus_comments: true
date: 2025-02-11
featured: true
thumbnail: assets/img/blog/explorer/explorer.png
authors:
  - name: Aryan Vichare
    url: "https://www.aryanvichare.dev"
    affiliations:
      name: UC Berkeley
  - name: Anastasios N. Angelopoulos
    url: "http://angelopoulos.ai"
  - name: Wei-Lin Chiang
    url: "https://infwinston.github.io"
  - name: Kelly Tang
    url: "https://www.linkedin.com/in/kelly-yuguo-tang"
  - name: Luca Manolache
    url: "https://www.linkedin.com/in/luca-manolache-53569b220"
---

## WebDev Arena: A Live LLM Leaderboard for Web App Development

LLMs have shown impressive coding abilities in various coding benchmarks, but how well can they actually build functional web applications? We introduce WebDev Arena: a real-time AI coding competition where models go head-to-head in web development challenges.

Inspired by [Chatbot Arena](http://lmarena.ai), WebDev Arena allows users to test LLMs in a real-world coding task: building interactive web applications. Users submit a prompt, two LLMs generate web apps, and the community votes on which model performs better.

Try out our [colab](https://colab.research.google.com/drive/1xq_-PGp8gJ8aHUyokrSqL_qZnn8s-UHV?usp=sharing) to explore the data and analysis behind WebDev Arena.

#### Why WebDev Arena?

Traditional coding benchmarks like HumanEval focus on solving isolated function-based problems, but real-world coding demands more—including UI generation, handling package dependencies, and structuring complete applications. 

From an end-user's perspective, the setup is simple:

1. Users submit a prompt (e.g., "Build a simple chess game").  
2. Two LLMs generate competing web apps.  
3. Users interact with both apps and vote on the better one.  
4. Results contribute to a live leaderboard ranking LLMs by performance.

Examples  
"Create a Hacker News clone"  
![][image1]  
"Build a basic chess game"

![][image2]


#### WebDev Arena Leaderboard 

Since [our launch](https://x.com/aryanvichare10/status/1866561638712881172) in Dec 2024, we have collected over 80,000 community votes and provided a live ranking of LLMs based on their real-world coding performance.

Similar to [Chatbot Arena](http://lmarena.ai/leaderboard), we use the Bradley-Terry (BT) model, which estimates model strengths from pairwise comparisons. In simple terms, the BT model uses win/loss data from pairwise matchups and calculates a score for each model, reflecting its likelihood of winning against others. This ranking system is similar to Elo, commonly used in chess, and competitive games, despite the difference being a player's skill rating may evolve over time, while LLMs stay static.

Key Takeaways

* Claude 3.5 Sonnet currently holds the \#1 spot with a 68% average win rate.  
* DeepSeek-R1 ranks \#2  
* OpenAI o3-mini (high reasoning effort) ranks \#3

![][image3]

#### How do people use WebDev Arena?

***Topic Modeling***  
To analyze how people use Webdev Arena, we run the [topic modeling pipeline](https://colab.research.google.com/drive/1chzqjePYnpq08fA3KzyKvSkuzCjojyiE?usp=sharing) on the conversation and human preference data. Results show a diverse range of prompt categories. Overall, prompts can be categorized into 11 broad categories, the largest three being Website Design (15.3%), Game Development (12.1%), and Clone Development (11.6).   
<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/cat_broad.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 1. Distribution of broad categories in WebDev Arena prompts.</p>

Each board category contains several fine-grained narrow categories, such as Landing Page Design, Dashboard and Web Application Design, 3D Graphics and Shaders, Language Learning App Design, etc. Click through the Explorer to see more categories and example prompts.   
<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/cat_broad.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 2. Distribution of narrow categories within broad categories.</p>

Using the topic modeling results, we perform LLM performance analysis and observe that models perform differently across categories. Gemini-2.0-flash shows the most dramatic variation, ranking among the lowest in Game Development while performing much better in other categories.  
<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/rank_broad_cat.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 3. Model performance across different broad categories.</p>

We calculated the win rates of Gemini 2.0, Claude-3.5-sonnet, O3-mini, and Deepseek-R1 across narrow categories, counting ties as 0.5 wins. Even within the same broad category, models performed differently across specific topics, highlighting their varying strengths. This shows the importance of fine-grained categorical analysis for LLM evaluations.

In website design, Deepseek-R1 performed significantly better in Job Board Design but had a noticeably lower performance in Portfolio Website Design. In Game Development, Claude-3.5-sonnet maintained a relatively consistent win rate across most categories, except for a dip in Clicker Game Development. Gemini 2.0 and O3-mini show fluctuating win rates.  
<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/winrate_web.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 4. Model win rates across website design categories.</p>

<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/winrate_game.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 5. Model win rates across game development categories.</p>

One of the main insights from analyzing the data is that a large chunk of the votes are from the sample prompts on the main screen. We found the 5 most asked questions were  
| Project Request | Number of Times |  
|----------------|----------------|  
| 👨‍💻 Clone of VS Code / Cursor | 4,189 |  
| Make me a clone of WhatsApp Chat App | 3,385 |  
| ♟️ Build a game of chess | 3,154 |  
| 📰 Clone of Hacker News | 2,740 |  
| 🐦 Design a modern Twitter profile layout | 2,544 |

Therefore, we deduplicated the data, reducing the votes from 103096 to 61473, and recreated the deduplicated leaderboard. This leaderboard matches the original leaderboard with only a few minor swaps of models (deepseek-v3 and gpt-4o). The elo difference between them is mainly caused by having less data.  
![][image9] ![][image10]  
| Rank | Model                                    | Original Elo Rating | Deduplicated Elo Rating | Delta  |  
|------|------------------------------------------|---------------------|-------------------------|--------|  
| 1    | claude-3-7-sonnet-20250219               | 1362.94             | 1311.42                 | \-51.52 |  
| 2    | claude-3-5-sonnet-20241022               | 1245.85             | 1209.08                 | \-36.77 |  
| 3    | deepseek-r1                              | 1204.69             | 1165.4                  | \-39.29 |  
| 4    | early-grok-3-so-false                    | 1147                | 1111.37                 | \-35.63 |  
| 5    | o3-mini-2025-01-31-high                  | 1146.14             | 1119.43                 | \-26.71 |  
| 6    | o3-mini-2025-01-31-high-so-false         | 1137.21             | 1119.85                 | \-17.36 |  
| 7    | claude-3-5-haiku-20241022                | 1136.38             | 1112.98                 | \-23.4  |  
| 8    | o3-mini-2025-01-31-so-false              | 1109.05             | 1083.3                  | \-25.75 |  
| 9    | gemini-2.0-flash-thinking-01-21-so-false | 1108.82             | 1099.89                 | \-8.93  |  
| 10   | gemini-2.0-pro-exp-02-05                 | 1101.89             | 1078.58                 | \-23.31 |  
| 11   | o3-mini-2025-01-31                       | 1099.29             | 1076.49                 | \-22.8  |  
| 12   | gpt-4-turbo                              | 1054.73             | 1037.26                 | \-17.47 |  
| 13   | o1                                       | 1054.73             | 1037.26                 | \-17.47 |  
| 14   | o1-2024-12-17-so-false                   | 1054.52             | 1043.16                 | \-11.36 |  
| 15   | o1-2024-12-17                            | 1049.89             | 1035.79                 | \-14.1  |  
| 16   | o1-mini-2024-09-12                       | 1046.59             | 1027.98                 | \-18.61 |  
| 17   | gemini-2.0-flash-thinking-exp-01-21      | 1034.29             | 1014.75                 | \-19.54 |  
| 18   | gemini-2.0-flash-001-so-false            | 1031.72             | 1011.87                 | \-19.85 |  
| 19   | gemini-2.0-flash-thinking-exp-1219       | 1023.31             | 1005.57                 | \-17.74 |  
| 20   | gemini-exp-1206                          | 1022.12             | 998.06                  | \-24.06 |  
| 21   | gemini-2.0-flash-exp                     | 983.58              | 966.59                  | \-16.99 |  
| 22   | qwen-max-2025-01-25                      | 979.82              | 971.03                  | \-8.79  |  
| 23   | gpt-4o-2024-11-20                        | 964                 | 964                     | 0      |  
| 24   | deepseek-v3                              | 963.9               | 940.75                  | \-23.15 |  
| 25   | qwen-2.5-coder-32b-instruct              | 903.06              | 907.07                  | 4.01   |  
| 26   | gemini-1.5-pro-002                       | 893.5               | 891.07                  | \-2.43  |  
| 27   | llama-v3.3-70b-instruct                  | 861.76              | 904.38                  | 42.62  |  
| 28   | llama-v3.1-405b-instruct                 | 811.61              | 798.89                  | \-12.72 |

Another interesting difference between Chatbot Arena and WebDev Arena is the tie ratio. Webdev Arena has a 26% tie ratio and Chatbot Arena has a tie ratio of 35%. However, out of the ties, we note that WebDev arena has a much higher ratio of them being both bad. We will get to this later with the errors that can occur.

|  | WebDev Arena | Chatbot Arena |
| :---- | :---- | :---- |
| Model A | 36.6% | 34% |
| Model B | 37% | 34% |
| Tie | 7.8% | 16% |
| Bothbad | 18% | 16% |

We think this task is much easier to distinguish compared to Chatbot Arena.  
To explain for the large number of people voting "both bad", we took a look at model failures, when the model either hallucinates a library that does not exist/has not been imported, or writes code that can not compile.  
Sometimes, prompts will result in the LLMs outputting buggy code or failing to properly install dependencies. The main culprit of this is llama-v3.1.   
![][image11]  
Additionally we analyzed the length in tokens of requests. Most requests are under 25,000 tokens and we found several outliers with extremely long messages.   
mean       154.91  
std       1613.12  
min          0.00  
25%          7.00  
50%         11.00  
75%         29.00  
max     269157.00  
![][image12]

#### How we implemented WebDev Arena?

One of the key challenges in building WebDev Arena was ensuring that LLMs generate consistent, deployable web applications. To achieve this, we developed a structured output approach that standardizes how models generate web applications.

Structured output is a technique that ensures LLM responses adhere to a predefined JSON schema. Rather than allowing models to generate freeform code or text, we constrain their output to match a specific structure. This provides several key benefits:

1. **Type Safety**: Eliminates the need to validate or retry incorrectly formatted responses  
2. **Consistent Formatting**: Ensures all models generate code in a standardized way  
3. **Better Error Handling**: Makes model refusals and errors programmatically detectable  
4. **Simplified Prompting**: Reduces the need for complex prompting to achieve consistent formatting

Rather than letting models generate code in an unconstrained format, we prompt them to output code in a specific structure that includes:

\`\`\`ts

{

  // Detailed explanation of the implementation plan

  commentary: string,

  // Template configuration

  template: string,

  title: string,

  description: string,

  // Dependency management

  additional\_dependencies: string\[\],

  has\_additional\_dependencies: boolean,

  install\_dependencies\_command: string,

  // Application configuration

  port: number | null,

  file\_path: string,

  // The actual implementation

  code: string

}

\`\`\`

This structured format helps ensure:

1. Clear documentation of the implementation approach through the \`commentary\` field  
2. Proper dependency tracking and installation instructions  
3. Consistent file organization within the Next.js project structure  
4. Runtime configuration like port numbers are explicitly defined

***Infrastructure and Execution Environment***

Under the hood, WebDev Arena utilizes Amazon's Firecracker microVM technology through E2B's infrastructure. Each sandbox runs in a lightweight virtual machine that provides enhanced security and workload isolation while maintaining the resource efficiency of containers. These microVMs are managed by a Virtual Machine Monitor (VMM) using the Linux Kernel-based Virtual Machine (KVM), with a minimalist design that excludes unnecessary devices and functionality to reduce memory footprint and attack surface. 

This infrastructure enables WebDev Arena to run thousands of concurrent LLM-generated applications with complete isolation \- each application operates in its own secure environment with dedicated CPU, memory, and networking resources, while maintaining sub-second startup times (\~150ms) essential for real-time model comparisons.

***Prompting Strategy and System Design***

Our system prompt is designed to create a clear "persona" for the LLM as an expert frontend engineer with strong UI/UX skills. The prompt includes several critical components:

\`\`\`ts  
const SYSTEM\_PROMPT \= \`  
    You are an expert frontend React engineer who is also a great UI/UX designer...  
    \- Think carefully step by step.  
    \- Create a React component for whatever the user asked to create  
    \- Make sure the React app is interactive and functional  
    \- Use TypeScript and Tailwind classes for styling  
    ...  
\`;  
\`\`\`

Our prompting strategy involved a few key aspects:

1. **Clear Role Definition**: We establish the model as an expert frontend engineer, which helps frame its responses appropriately  
2. **Explicit Constraints**: We specify important limitations upfront:  
* Use of TypeScript  
* Tailwind for styling (with explicit prohibition of arbitrary values)  
* Single-file components  
* No modification of project dependencies  
3. **Quality Guidelines**: We include specific quality requirements:  
* Interactive and functional components  
* Proper state management  
* Consistent color palette  
* Appropriate spacing using Tailwind classes

Our system prompt also includes information pertaining to a predefined framework to provide the LLM a consistent starting point for generated applications. WebDev Arena currently supports Next.js by Vercel, which is a powerful React framework that enables developers to build high-performance web applications with features like hybrid rendering (SSR, SSG, and ISR), React Server Components, and API routes. Next.js is one of the leading web frameworks with 7.2 million weekly npm downloads and \~130,000 Github Stars, which is why we are providing first-class support for it through WebDev Arena.

![][image13]

***Performance Analysis: Single vs Ensemble Approach***

We discovered that different models require different prompting approaches. Our implementation includes specific handling for various model architectures. 

For models lacking native structured output capabilities, we developed a two-stage generation pipeline: (1) Generate the initial code using the model's native format and (2) pass the result through a GPT-4-mini instance to convert it into our structured format.

We conducted a systematic ablation study examining structured output's impact on model performance in web development tasks. Each model was evaluated in two configurations:

1. With structured output (using JSON schema constraints)  
2. Without structured output (natural language generation)

For example, we evaluated o3-mini (with/without structured output), o1 (with/without structured output), and Gemini models (with/without structured output).

Our analysis revealed a consistent performance advantage for models operating without structured output constraints, as evidenced in Table 1\.

Table 1: Comparison of Model Performance With and Without Structured Output

| Model Variant | Arena Score | Δ Score | Votes | 95% CI |

|--------------|-------------|----------|--------|---------|

| o3-mini-high (w/o structured) | 1169.19 | \+16.08 | 1,976 | \+12.73/-11.74 |

| o3-mini-high | 1153.11 | \- | 2,982 | \+10.17/-10.51 |

|--------------|-------------|----------|--------|---------|

| o3-mini (w/o structured) | 1129.82 | \+24.12 | 2,688 | \+10.64/-10.42 |

| o3-mini | 1105.70 | \- | 6,388 | \+7.89/-8.59 |

|--------------|-------------|----------|--------|---------|

| o1 (w/o structured) | 1066.29 | \+12.98 | 2,140 | \+12.94/-13.37 |

| o1 (20241217) | 1053.31 | \- | 9,271 | \+4.71/-6.91 |

|--------------|-------------|----------|--------|---------|

| Gemini-2.0-Flash-Thinking-01-21 (w/o structured) | 1125.98 | \+88.76 | 405 | \+30.49/-27.58 |

| Gemini-2.0-Flash-Thinking-01-21 | 1037.22 | \- | 1,064 | \+17.04/-17.86 |

Our experimental results demonstrate that unstructured output configurations consistently outperform their structured counterparts across all tested model architectures, with Arena Score improvements ranging from \+12.98 to \+88.76 points. These improvements are statistically significant within 95% confidence intervals across all model pairs. The magnitude of this performance impact varies considerably by model architecture \- Gemini exhibits the most substantial performance delta (+88.76), while o3-mini-high shows the smallest improvement (+16.08). 

These findings suggest that while structured output constraints provide benefits for downstream processing and code organization, they may introduce performance limitations in web development tasks. This performance-structure tradeoff appears to be more pronounced in certain model architectures, particularly in the Gemini series, indicating that the impact of structured output constraints may be architecture-dependent.

### Vision Support for Web Development

We've extended WebDev Arena to support multi-modal models, enabling evaluation of vision-language capabilities in web development contexts. Currently, six production models in our evaluation suite support vision inputs: Claude 3.5 Sonnet, Claude 3.5 Haiku, GPT-4o, and three variants of Gemini (2.0-flash-thinking, 2.0-pro-exp, and 1.5-pro-002). Each model accepts visual input through our structured schema, which standardizes how images are processed and incorporated into the development workflow.

Our implementation supports base64-encoded images and URLs, with vision models demonstrating capabilities in UI replication, design-to-code translation, and visual bug fixing. Early deployments show that models can parse complex visual hierarchies, extract design tokens (colors, spacing, typography), and generate semantically meaningful JSX (JavaScript XML) from screenshots. 

The integration of vision capabilities has significant implications for web development evaluation. Traditional code generation benchmarks focus solely on text-to-code translation, but real-world development frequently involves visual references and design artifacts. By incorporating vision support, WebDev Arena more accurately reflects practical development workflows while providing quantitative insights into multi-modal code generation performance. We are currently collecting battle data to analyze the impact of visual context on code quality and will release comprehensive benchmarks comparing vision-enabled versus text-only performance across our supported models.

### Limitations and Future Work

While WebDev Arena represents a significant step forward in evaluating LLMs for real-world software development, several limitations remain. Unlike existing benchmarks such as HumanEval and CodeXGLUE, which focus on function-level code generation, or SWE-bench, which evaluates issue resolution in open-source repositories, WebDev Arena is currently constrained to Next.js-based React applications. This limitation excludes other widely used frameworks such as Vue, Svelte, and backend technologies like Django or Rails. Furthermore, the single-file constraint does not accurately reflect real-world software engineering workflows, where projects are typically structured across multiple files with modular architectures. Another challenge is error handling—our analysis indicates that 18% of user votes fall into the "both bad" category, often due to dependency resolution failures, incorrect state management, or TypeScript-related compilation errors. A more sophisticated error classification framework would enhance the interpretability of failure cases and inform improvements in model reliability.

Future work will extend WebDev Arena to a broader range of software engineering tasks, encompassing full-stack development and non-web domains to better capture the diverse challenges of real-world coding. Unlike traditional benchmarks that focus on algorithmic correctness or isolated bug fixes, our approach evaluates LLMs in the context of complete application development, emphasizing deployment-ready implementations. We also plan to refine our human evaluation methodology, enhance model ranking with more granular error diagnostics, and investigate the impact of multimodal capabilities, particularly in UI-to-code translation. By addressing these limitations, we aim to establish WebDev Arena as a comprehensive benchmark for assessing LLMs in practical software engineering contexts, bridging the gap between academic evaluation and real-world application development.

[image1]: /assets/img/blog/webdev_arena/hn-clone.png
[image2]: /assets/img/blog/webdev_arena/game-of-chess.png
[image3]: /assets/img/blog/webdev_arena/030625-leaderboard.png
[image9]: /assets/img/blog/webdev_arena/base-leaderboard.png
[image10]: /assets/img/blog/webdev_arena/base-leaderboard-deduplicated.png
[image11]: /assets/img/blog/webdev_arena/distribution-of-error-types-per-model.png
[image12]: /assets/img/blog/webdev_arena/distribution-of-request-lengths.png
[image13]: /assets/img/blog/webdev_arena/framework-npm-trends.png