---
layout: distill
title: "WebDev Arena"
description: A Live LLM Leaderboard for Web App Development
giscus_comments: true
date: 2025-03-06
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

LLMs have shown impressive coding abilities in various coding benchmarks, but how well can they actually build functional web applications? We introduce [WebDev Arena](http://webdev.lmarena.ai): a real-time AI coding competition where models go head-to-head in web development challenges.

Inspired by [Chatbot Arena](http://lmarena.ai), WebDev Arena allows users to test LLMs in a real-world coding task: building interactive web applications. Users submit a prompt, two LLMs generate web apps, and the community votes on which model performs better.

Try out our [colab](https://colab.research.google.com/drive/1xq_-PGp8gJ8aHUyokrSqL_qZnn8s-UHV?usp=sharing) to explore the data and analysis behind WebDev Arena.

### Why WebDev Arena?

Traditional coding benchmarks like HumanEval focus on solving isolated function-based problems, but real-world coding demands more—including UI generation, handling package dependencies, and structuring complete applications. 

From an end-user's perspective, the setup is simple:

1. Users submit a prompt (e.g., "Build a simple chess game").  
2. Two LLMs generate competing web apps.  
3. Users interact with both apps and vote on the better one.  
4. Results contribute to a live leaderboard ranking LLMs by performance.

Examples  
"Create a Hacker News clone"  
<img src="/assets/img/blog/webdev_arena/hn-clone.png" alt="Hacker News Clone Example" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 1. Example of a Hacker News clone built by an LLM.</p>

"Build a basic chess game"
<img src="/assets/img/blog/webdev_arena/game-of-chess.png" alt="Chess Game Example" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 2. Example of a chess game built by an LLM.</p>

### WebDev Arena Leaderboard 

Since [our launch](https://x.com/aryanvichare10/status/1866561638712881172) in Dec 2024, we have collected over 80,000 community votes and provided a live ranking of LLMs based on their real-world coding performance.

Similar to [Chatbot Arena](http://lmarena.ai/leaderboard), we use the Bradley-Terry (BT) model, which estimates model strengths from pairwise comparisons. In simple terms, the BT model uses win/loss data from pairwise matchups and calculates a score for each model, reflecting its likelihood of winning against others. This ranking system is similar to Elo, commonly used in chess, and competitive games, despite the difference being a player's skill rating may evolve over time, while LLMs stay static.

Key Takeaways

* Claude 3.7 Sonnet currently holds the #1 spot with a 76% average win rate
* Claude 3.5 Sonnet ranks #2  
* Deepseek R1 ranks #3

<img src="/assets/img/blog/webdev_arena/030625-leaderboard.png" alt="WebDev Arena Leaderboard" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 3. Current WebDev Arena leaderboard showing model rankings.</p>

### How do people use WebDev Arena?

#### Topic Modeling
To analyze how people use Webdev Arena, we run the [topic modeling pipeline](https://colab.research.google.com/drive/1chzqjePYnpq08fA3KzyKvSkuzCjojyiE?usp=sharing) on the conversation and human preference data. Results show a diverse range of prompt categories. Overall, prompts can be categorized into 11 broad categories, the largest three being Website Design (15.3%), Game Development (12.1%), and Clone Development (11.6%).   
<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/cat_broad.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 4. Distribution of broad categories in WebDev Arena prompts.</p>

Each board category contains several fine-grained narrow categories, such as Landing Page Design, Dashboard and Web Application Design, 3D Graphics and Shaders, Language Learning App Design, etc. Click through the Explorer to see more categories and example prompts.   
<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/cat_broad.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 5. Distribution of narrow categories within broad categories.</p>

Using the topic modeling results, we perform LLM performance analysis and observe that models perform differently across categories. Gemini-2.0-flash shows the most dramatic variation, ranking among the lowest in Game Development while performing much better in other categories.  
<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/rank_broad_cat.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 6. Model performance across different broad categories.</p>

We calculated the win rates of Gemini 2.0, Claude-3.5-sonnet, O3-mini, and Deepseek-R1 across narrow categories, counting ties as 0.5 wins. Even within the same broad category, models performed differently across specific topics, highlighting their varying strengths. This shows the importance of fine-grained categorical analysis for LLM evaluations.

In website design, Deepseek-R1 performed significantly better in Job Board Design but had a noticeably lower performance in Portfolio Website Design. In Game Development, Claude-3.5-sonnet maintained a relatively consistent win rate across most categories, except for a dip in Clicker Game Development. Gemini 2.0 and O3-mini show fluctuating win rates.  
<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/winrate_web.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 7. Model win rates across website design categories.</p>

<div>
  <iframe src="{{ '/assets/img/blog/webdev_arena/winrate_game.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Figure 8. Model win rates across game development categories.</p>

One of the main insights from analyzing the data is that a large chunk of the votes are from the sample prompts on the main screen. We found the 5 most asked questions were  
<table>
  <thead>
    <tr>
      <th>Project Request</th>
      <th>Number of Times</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>👨‍💻 Clone of VS Code / Cursor</td>
      <td>4,189</td>
    </tr>
    <tr>
      <td>Make me a clone of WhatsApp Chat App</td>
      <td>3,385</td>
    </tr>
    <tr>
      <td>♟️ Build a game of chess</td>
      <td>3,154</td>
    </tr>
    <tr>
      <td>📰 Clone of Hacker News</td>
      <td>2,740</td>
    </tr>
    <tr>
      <td>🐦 Design a modern Twitter profile layout</td>
      <td>2,544</td>
    </tr>
  </tbody>
</table>

Therefore, we deduplicated the data, reducing the votes from 103096 to 61473, and recreated the deduplicated leaderboard. This leaderboard matches the original leaderboard with only a few minor swaps of models (deepseek-v3 and gpt-4o). The elo difference between them is mainly caused by having less data.  
<table>
  <thead>
    <tr>
      <th>Rank</th>
      <th>Model</th>
      <th>Original Score</th>
      <th>Deduplicated Score</th>
      <th>Delta</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>claude-3-7-sonnet-20250219</td>
      <td>1362.94</td>
      <td>1311.42</td>
      <td>-51.52</td>
    </tr>
    <tr>
      <td>2</td>
      <td>claude-3-5-sonnet-20241022</td>
      <td>1245.85</td>
      <td>1209.08</td>
      <td>-36.77</td>
    </tr>
    <tr>
      <td>3</td>
      <td>deepseek-r1</td>
      <td>1204.69</td>
      <td>1165.4</td>
      <td>-39.29</td>
    </tr>
    <tr>
      <td>4</td>
      <td>early-grok-3-so-false</td>
      <td>1147</td>
      <td>1111.37</td>
      <td>-35.63</td>
    </tr>
    <tr>
      <td>5</td>
      <td>o3-mini-2025-01-31-high</td>
      <td>1146.14</td>
      <td>1119.43</td>
      <td>-26.71</td>
    </tr>
    <tr>
      <td>6</td>
      <td>o3-mini-2025-01-31-high-so-false</td>
      <td>1137.21</td>
      <td>1119.85</td>
      <td>-17.36</td>
    </tr>
    <tr>
      <td>7</td>
      <td>claude-3-5-haiku-20241022</td>
      <td>1136.38</td>
      <td>1112.98</td>
      <td>-23.4</td>
    </tr>
    <tr>
      <td>8</td>
      <td>o3-mini-2025-01-31-so-false</td>
      <td>1109.05</td>
      <td>1083.3</td>
      <td>-25.75</td>
    </tr>
    <tr>
      <td>9</td>
      <td>gemini-2.0-flash-thinking-01-21-so-false</td>
      <td>1108.82</td>
      <td>1099.89</td>
      <td>-8.93</td>
    </tr>
    <tr>
      <td>10</td>
      <td>gemini-2.0-pro-exp-02-05</td>
      <td>1101.89</td>
      <td>1078.58</td>
      <td>-23.31</td>
    </tr>
    <tr>
      <td>11</td>
      <td>o3-mini-2025-01-31</td>
      <td>1099.29</td>
      <td>1076.49</td>
      <td>-22.8</td>
    </tr>
    <tr>
      <td>12</td>
      <td>gpt-4-turbo</td>
      <td>1054.73</td>
      <td>1037.26</td>
      <td>-17.47</td>
    </tr>
    <tr>
      <td>13</td>
      <td>o1</td>
      <td>1054.73</td>
      <td>1037.26</td>
      <td>-17.47</td>
    </tr>
    <tr>
      <td>14</td>
      <td>o1-2024-12-17-so-false</td>
      <td>1054.52</td>
      <td>1043.16</td>
      <td>-11.36</td>
    </tr>
    <tr>
      <td>15</td>
      <td>o1-2024-12-17</td>
      <td>1049.89</td>
      <td>1035.79</td>
      <td>-14.1</td>
    </tr>
    <tr>
      <td>16</td>
      <td>o1-mini-2024-09-12</td>
      <td>1046.59</td>
      <td>1027.98</td>
      <td>-18.61</td>
    </tr>
    <tr>
      <td>17</td>
      <td>gemini-2.0-flash-thinking-exp-01-21</td>
      <td>1034.29</td>
      <td>1014.75</td>
      <td>-19.54</td>
    </tr>
    <tr>
      <td>18</td>
      <td>gemini-2.0-flash-001-so-false</td>
      <td>1031.72</td>
      <td>1011.87</td>
      <td>-19.85</td>
    </tr>
    <tr>
      <td>19</td>
      <td>gemini-2.0-flash-thinking-exp-1219</td>
      <td>1023.31</td>
      <td>1005.57</td>
      <td>-17.74</td>
    </tr>
    <tr>
      <td>20</td>
      <td>gemini-exp-1206</td>
      <td>1022.12</td>
      <td>998.06</td>
      <td>-24.06</td>
    </tr>
    <tr>
      <td>21</td>
      <td>gemini-2.0-flash-exp</td>
      <td>983.58</td>
      <td>966.59</td>
      <td>-16.99</td>
    </tr>
    <tr>
      <td>22</td>
      <td>qwen-max-2025-01-25</td>
      <td>979.82</td>
      <td>971.03</td>
      <td>-8.79</td>
    </tr>
    <tr>
      <td>23</td>
      <td>gpt-4o-2024-11-20</td>
      <td>964</td>
      <td>964</td>
      <td>0</td>
    </tr>
    <tr>
      <td>24</td>
      <td>deepseek-v3</td>
      <td>963.9</td>
      <td>940.75</td>
      <td>-23.15</td>
    </tr>
    <tr>
      <td>25</td>
      <td>qwen-2.5-coder-32b-instruct</td>
      <td>903.06</td>
      <td>907.07</td>
      <td>4.01</td>
    </tr>
    <tr>
      <td>26</td>
      <td>gemini-1.5-pro-002</td>
      <td>893.5</td>
      <td>891.07</td>
      <td>-2.43</td>
    </tr>
    <tr>
      <td>27</td>
      <td>llama-v3.3-70b-instruct</td>
      <td>861.76</td>
      <td>904.38</td>
      <td>42.62</td>
    </tr>
    <tr>
      <td>28</td>
      <td>llama-v3.1-405b-instruct</td>
      <td>811.61</td>
      <td>798.89</td>
      <td>-12.72</td>
    </tr>
  </tbody>
</table>
<p style="color:gray; text-align: center; padding-top: 10px;">Figure 9. Comparison of original and deduplicated leaderboards showing Elo ratings for all models.</p>

Another interesting difference between Chatbot Arena and WebDev Arena is the tie ratio. Webdev Arena has a 26% tie ratio and Chatbot Arena has a tie ratio of 35%. However, out of the ties, we note that WebDev arena has a much higher ratio of them being both bad. We will get to this later with the errors that can occur.

<table>
  <thead>
    <tr>
      <th></th>
      <th>WebDev Arena</th>
      <th>Chatbot Arena</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Model A</td>
      <td>36.6%</td>
      <td>34%</td>
    </tr>
    <tr>
      <td>Model B</td>
      <td>37%</td>
      <td>34%</td>
    </tr>
    <tr>
      <td>Tie</td>
      <td>7.8%</td>
      <td>16%</td>
    </tr>
    <tr>
      <td>Bothbad</td>
      <td>18%</td>
      <td>16%</td>
    </tr>
  </tbody>
</table>

We think this task is much easier to distinguish compared to Chatbot Arena.  
To explain for the large number of people voting "both bad", we took a look at model failures, when the model either hallucinates a library that does not exist/has not been imported, or writes code that can not compile.  
Sometimes, prompts will result in the LLMs outputting buggy code or failing to properly install dependencies. The main culprit of this is llama-v3.1.   
<img src="/assets/img/blog/webdev_arena/distribution-of-error-types-per-model.png" alt="Distribution of Error Types" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 10. Distribution of error types across different models.</p>

Additionally we analyzed the length in tokens of requests. Most requests are under 25,000 tokens and we found several outliers with extremely long messages.   
<table>
  <thead>
    <tr>
      <th>Statistic</th>
      <th>Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>mean</td>
      <td>154.91</td>
    </tr>
    <tr>
      <td>std</td>
      <td>1613.12</td>
    </tr>
    <tr>
      <td>min</td>
      <td>0.00</td>
    </tr>
    <tr>
      <td>25%</td>
      <td>7.00</td>
    </tr>
    <tr>
      <td>50%</td>
      <td>11.00</td>
    </tr>
    <tr>
      <td>75%</td>
      <td>29.00</td>
    </tr>
    <tr>
      <td>max</td>
      <td>269157.00</td>
    </tr>
  </tbody>
</table>
<img src="/assets/img/blog/webdev_arena/distribution-of-request-lengths.png" alt="Distribution of Request Lengths" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 11. Distribution of request lengths in tokens.</p>

### How we implemented WebDev Arena?

One of the key challenges in building WebDev Arena was ensuring that LLMs generate consistent, deployable web applications. To achieve this, we developed a structured output approach that standardizes how models generate web applications.

Structured output is a technique that ensures LLM responses adhere to a predefined JSON schema. Rather than allowing models to generate freeform code or text, we constrain their output to match a specific structure. This provides several key benefits:

1. **Type Safety**: Eliminates the need to validate or retry incorrectly formatted responses  
2. **Consistent Formatting**: Ensures all models generate code in a standardized way  
3. **Better Error Handling**: Makes model refusals and errors programmatically detectable  
4. **Simplified Prompting**: Reduces the need for complex prompting to achieve consistent formatting

Rather than letting models generate code in an unconstrained format, we prompt them to output code in a specific structure that includes:

```
{
  // Detailed explanation of the implementation plan
  commentary: string,
  // Template configuration
  template: string,
  title: string,
  description: string,
  // Dependency management
  additional_dependencies: string[],
  has_additional_dependencies: boolean,
  install_dependencies_command: string,
  // Application configuration
  port: number | null,
  file_path: string,
  // The actual implementation
  code: string
}
```

This structured format helps ensure:

1. Clear documentation of the implementation approach through the \`commentary\` field  
2. Proper dependency tracking and installation instructions  
3. Consistent file organization within the Next.js project structure  
4. Runtime configuration like port numbers are explicitly defined

#### Infrastructure and Execution Environment

Under the hood, WebDev Arena utilizes Amazon's Firecracker microVM technology through E2B's infrastructure. Each sandbox runs in a lightweight virtual machine that provides enhanced security and workload isolation while maintaining the resource efficiency of containers. These microVMs are managed by a Virtual Machine Monitor (VMM) using the Linux Kernel-based Virtual Machine (KVM), with a minimalist design that excludes unnecessary devices and functionality to reduce memory footprint and attack surface. 

This infrastructure enables WebDev Arena to run thousands of concurrent LLM-generated applications with complete isolation \- each application operates in its own secure environment with dedicated CPU, memory, and networking resources, while maintaining sub-second startup times (\~150ms) essential for real-time model comparisons.

#### Prompting Strategy and System Design

Our system prompt is designed to create a clear "persona" for the LLM as an expert frontend engineer with strong UI/UX skills. The prompt includes several critical components:

```
export const SYSTEM_PROMPT = `
    You are an expert frontend React engineer who is also a great UI/UX designer. Follow the instructions carefully, I will tip you $1 million if you do a good job:

    - Think carefully step by step.
    - Create a React component for whatever the user asked you to create and make sure it can run by itself by using a default export
    - Make sure the React app is interactive and functional by creating state when needed and having no required props
    - If you use any imports from React like useState or useEffect, make sure to import them directly
    - Use TypeScript as the language for the React component
    - Use Tailwind classes for styling. DO NOT USE ARBITRARY VALUES (e.g. 'h-[600px]'). Make sure to use a consistent color palette.
    - Make sure you specify and install ALL additional dependencies.
    - Make sure to include all necessary code in one file.
    - Do not touch project dependencies files like package.json, package-lock.json, requirements.txt, etc.
    - Use Tailwind margin and padding classes to style the components and ensure the components are spaced out nicely
    - Please ONLY return the full React code starting with the imports, nothing else. It's very important for my job that you only return the React code with imports. DO NOT START WITH \`\`\`typescript or \`\`\`javascript or \`\`\`tsx or \`\`\`.
    - ONLY IF the user asks for a dashboard, graph or chart, the recharts library is available to be imported, e.g. \`import { LineChart, XAxis, ... } from "recharts"\` & \`<LineChart ...><XAxis dataKey="name"> ...\`. Please only use this when needed. You may also use shadcn/ui charts e.g. \`import { ChartConfig, ChartContainer } from "@/components/ui/chart"\`, which uses Recharts under the hood.
    - For placeholder images, please use a <div className="bg-gray-200 border-2 border-dashed rounded-xl w-16 h-16" />
`;
```

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

<img src="/assets/img/blog/webdev_arena/framework-npm-trends.png" alt="Framework NPM Trends" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 12. NPM download trends for popular web frameworks.</p>

#### Performance Analysis: Single vs Ensemble Approach

We discovered that different models require different prompting approaches. Our implementation includes specific handling for various model architectures. 

For models lacking native structured output capabilities, we developed a two-stage generation pipeline: (1) Generate the initial code using the model's native format and (2) pass the result through a GPT-4-mini instance to convert it into our structured format.

We conducted a systematic ablation study examining structured output's impact on model performance in web development tasks. Each model was evaluated in two configurations:

1. With structured output (using JSON schema constraints)  
2. Without structured output (natural language generation)

For example, we evaluated o3-mini (with/without structured output), o1 (with/without structured output), and Gemini models (with/without structured output).

Our analysis revealed a consistent performance advantage for models operating without structured output constraints, as evidenced in Table 1\.

<table>
  <thead>
    <tr>
      <th>Model Variant</th>
      <th>Arena Score</th>
      <th>Δ Score</th>
      <th>Votes</th>
      <th>95% CI</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>o3-mini-high (w/o structured)</td>
      <td>1169.19</td>
      <td>+16.08</td>
      <td>1,976</td>
      <td>+12.73/-11.74</td>
    </tr>
    <tr>
      <td>o3-mini-high</td>
      <td>1153.11</td>
      <td>-</td>
      <td>2,982</td>
      <td>+10.17/-10.51</td>
    </tr>
    <tr>
      <td colspan="5"></td>
    </tr>
    <tr>
      <td>o3-mini (w/o structured)</td>
      <td>1129.82</td>
      <td>+24.12</td>
      <td>2,688</td>
      <td>+10.64/-10.42</td>
    </tr>
    <tr>
      <td>o3-mini</td>
      <td>1105.70</td>
      <td>-</td>
      <td>6,388</td>
      <td>+7.89/-8.59</td>
    </tr>
    <tr>
      <td colspan="5"></td>
    </tr>
    <tr>
      <td>o1 (w/o structured)</td>
      <td>1066.29</td>
      <td>+12.98</td>
      <td>2,140</td>
      <td>+12.94/-13.37</td>
    </tr>
    <tr>
      <td>o1 (20241217)</td>
      <td>1053.31</td>
      <td>-</td>
      <td>9,271</td>
      <td>+4.71/-6.91</td>
    </tr>
    <tr>
      <td colspan="5"></td>
    </tr>
    <tr>
      <td>Gemini-2.0-Flash-Thinking-01-21 (w/o structured)</td>
      <td>1125.98</td>
      <td>+88.76</td>
      <td>405</td>
      <td>+30.49/-27.58</td>
    </tr>
    <tr>
      <td>Gemini-2.0-Flash-Thinking-01-21</td>
      <td>1037.22</td>
      <td>-</td>
      <td>1,064</td>
      <td>+17.04/-17.86</td>
    </tr>
  </tbody>
</table>

Our experimental results demonstrate that unstructured output configurations consistently outperform their structured counterparts across all tested model architectures, with Arena Score improvements ranging from \+12.98 to \+88.76 points. These improvements are statistically significant within 95% confidence intervals across all model pairs. The magnitude of this performance impact varies considerably by model architecture \- Gemini exhibits the most substantial performance delta (+88.76), while o3-mini-high shows the smallest improvement (+16.08). 

These findings suggest that while structured output constraints provide benefits for downstream processing and code organization, they may introduce performance limitations in web development tasks. This performance-structure tradeoff appears to be more pronounced in certain model architectures, particularly in the Gemini series, indicating that the impact of structured output constraints may be architecture-dependent.

### Vision Support for Web Development

We've extended WebDev Arena to support multi-modal models, enabling evaluation of vision-language capabilities in web development contexts. Currently, six production models in our evaluation suite support vision inputs: Claude 3.5 Sonnet, Claude 3.5 Haiku, GPT-4o, and three variants of Gemini (2.0-flash-thinking, 2.0-pro-exp, and 1.5-pro-002). Each model accepts visual input through our structured schema, which standardizes how images are processed and incorporated into the development workflow.

Our implementation supports base64-encoded images and URLs, with vision models demonstrating capabilities in UI replication, design-to-code translation, and visual bug fixing. Early deployments show that models can parse complex visual hierarchies, extract design tokens (colors, spacing, typography), and generate semantically meaningful JSX (JavaScript XML) from screenshots. 

The integration of vision capabilities has significant implications for web development evaluation. Traditional code generation benchmarks focus solely on text-to-code translation, but real-world development frequently involves visual references and design artifacts. By incorporating vision support, WebDev Arena more accurately reflects practical development workflows while providing quantitative insights into multi-modal code generation performance. We are currently collecting battle data to analyze the impact of visual context on code quality and will release comprehensive benchmarks comparing vision-enabled versus text-only performance across our supported models.

### Limitations and Future Work

While WebDev Arena represents a significant step forward in evaluating LLMs for real-world software development, several limitations remain. Unlike existing benchmarks such as HumanEval and CodeXGLUE, which focus on function-level code generation, or SWE-bench, which evaluates issue resolution in open-source repositories, WebDev Arena is currently constrained to Next.js-based React applications. This limitation excludes other widely used frameworks such as Vue, Svelte, and backend technologies like Django or Rails. Furthermore, the single-file constraint does not accurately reflect real-world software engineering workflows, where projects are typically structured across multiple files with modular architectures. Another challenge is error handling—our analysis indicates that 18% of user votes fall into the "both bad" category, often due to dependency resolution failures, incorrect state management, or TypeScript-related compilation errors. A more sophisticated error classification framework would enhance the interpretability of failure cases and inform improvements in model reliability.

Future work will extend WebDev Arena to a broader range of software engineering tasks, encompassing full-stack development and non-web domains to better capture the diverse challenges of real-world coding. Unlike traditional benchmarks that focus on algorithmic correctness or isolated bug fixes, our approach evaluates LLMs in the context of complete application development, emphasizing deployment-ready implementations. We also plan to refine our human evaluation methodology, enhance model ranking with more granular error diagnostics, and investigate the impact of multimodal capabilities, particularly in UI-to-code translation. By addressing these limitations, we aim to establish WebDev Arena as a comprehensive benchmark for assessing LLMs in practical software engineering contexts, bridging the gap between academic evaluation and real-world application development.