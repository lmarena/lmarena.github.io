---
layout: distill
title: Code Editing in Copilot Arena
description: Copilot Arena's Code Editing Leaderboard and Insights
giscus_comments: true
date: 2025-01-23
featured: true
thumbnail: assets/img/blog/copilot_arena/leaderboard_pfp.png
authors:
  - name: Wayne Chi
    url: "https://waynchi.github.io"
    affiliations:
      name: CMU, UC Berkeley
  - name: Valerie Chen
    url: "https://valeriechen.github.io/"
  - name: Anastasios N. Angelopoulos
    url: "http://angelopoulos.ai"
  - name: Wei-Lin Chiang
    url: "https://infwinston.github.io/"
  - name: Naman Jain
    url: "https://naman-ntc.github.io/"
  - name: Tianjun Zhang
    url: "https://tianjunz.github.io/"
  - name: Ion Stoica
    url: "https://people.eecs.berkeley.edu/~istoica/"
  - name: Chris Donahue
    url: "https://chrisdonahue.com/"
  - name: Ameet Talwalkar
    url: "https://www.cs.cmu.edu/~atalwalk/"
---

## Introduction

AI coding assistants are no longer limited to providing simple code completions, frequently providing the ability to directly _edit_ code as well. Copilot Arena is no different: Copilot Arena enables not only paired [code completions](https://blog.lmarena.ai/blog/2024/copilot-arena/) but also paired code edits as well. Unlike code completions---which automatically appear after short pauses---code edits are manually triggered by highlighting a code snippet and then writing a short task description. In Copilot Arena specifically, two suggestions (presented as code diffs) are provided and the user is able to vote between them.

To date, Copilot Arena has been downloaded over 8.5k times on the VSCode Marketplace! We recently released the Copilot Arena live leaderboard for code completions on lmarena.ai and now the code edit leaderboard, which has 3K votes across 6 top models.

<img src="/assets/img/blog/copilot_arena_edits/demo.png" alt="Demo of Edits" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 1. Demo of Copilot Arena's edit functionality.</p>

In this blogpost we will cover:

- Initial leaderboard and results: Our preliminary results for the code edit leaderboard and analysis of model tiers.
- Code edit usage: Analysis of how users request code edits, including the distribution of prompt length and highlighted context length and an analysis of the types of prompts that users tend to write.

## Initial Leaderboard and Results

As an initial set of models, we selected 6 of the best models across multiple model providers that include both open, code-specific, and commercial models. To ensure a fair comparison between models, we do the following…

- We randomize whether models appear at the left or right panel along with which models are paired for each battle.
- We show both completions at the same time. This means that a faster model completion needs to wait for the slower model.
- We set the same max number of output tokens, input tokens, top-p, and temperature (unless specified by the model provider).

<div style="margin-left: auto; margin-right: auto; width: fit-content;">
  <table class="tg">
    <thead>
      <tr>
        <th>Model</th>
        <th style="text-align: center;">Arena Score</th>
        <th style="text-align: center;">Confidence Intervals</th>
      </tr>
    </thead>
    <tbody>
      <tr style="background-color: #EFBF04; color: black">
        <td>Claude 3.5 Sonnet (10/22)</td>
        <td style="text-align: center;">1058</td>
        <td style="text-align: center;">+13/-15</td>
      </tr>
      <tr style="background-color: #FFFFFF; color: black">
        <td>GPT-4o (08/06)</td>
        <td style="text-align: center;">1024</td>
        <td style="text-align: center;">+16/-20</td>
      </tr>
      <tr style="background-color: #FFFFFF; color: black">
        <td>GPT-4o-mini (07/18)</td>
        <td style="text-align: center;">1011</td>
        <td style="text-align: center;">+12/-15</td>
      </tr>
      <tr style="background-color: #FFFFFF; color: black">
        <td>Qwen2.5-Coder-32B-Instruct (07/18)</td>
        <td style="text-align: center;">1005</td>
        <td style="text-align: center;">+15/-12</td>
      </tr>
      <tr style="background-color: #FFFFFF; color: black">
        <td>Gemini-1.5-pro-002</td>
        <td style="text-align: center;">999</td>
        <td style="text-align: center;">+14/-14</td>
      </tr>
      <tr style="background-color: #FFFFFF; color: black">
        <td>Meta-Llama-3.1-405B-Instruct</td>
        <td style="text-align: center;">993</td>
        <td style="text-align: center;">+19/-14</td>
      </tr>
    </tbody>
  </table>
</div>
<p style="color:gray; text-align: center;">Table 1. Elo ratings and median latency of six popular models based on over 3K votes. We color rows based on tiers determined by confidence intervals. Each model has at least 1K votes.</p>

Table 1 presents the current code completion leaderboard and stratifies them into tiers. Here are our main takeaways:

- The clear winner is Claude 3.5 Sonnet in terms of Arena Score.
- While some of the models in the middle fluctuate, we have generally observed that Llama-3.1-405b is the least preferred by users by far of the models we evaluate, losing a majority of the time to all other models (see Figure 2).

<div class="l-page" id="model-comparison-chart" style="display: flex; justify-content: center;"></div>

<script src="https://d3js.org/d3.v7.min.js"></script>
<script>
// Data for the chart
const data = [
  { model: 'Gemini 1.5 Pro', length: 258.30 },
  { model: 'Qwen 2.5 Coder', length: 246.39 },
  { model: 'LLaMA 3.1 405B', length: 230.81 },
  { model: 'GPT-4-Mini', length: 223.71 },
  { model: 'Claude 3.5 Sonnet', length: 209.59 },
  { model: 'GPT-4', length: 200.73 }
];

// Set up the chart dimensions
const margin = {top: 40, right: 30, bottom: 90, left: 60};
const width = 800 - margin.left - margin.right;
const height = 400 - margin.top - margin.bottom;

// Create the SVG container
const svg = d3.select("#model-comparison-chart")
  .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", `translate(${margin.left},${margin.top})`);

// Create scales
const x = d3.scaleBand()
    .range([0, width])
    .padding(0.2);

const y = d3.scaleLinear()
    .range([height, 0]);

// Set domains
x.domain(data.map(d => d.model));
y.domain([0, d3.max(data, d => d.length)]);

// Add X axis
svg.append("g")
    .attr("transform", `translate(0,${height})`)
    .call(d3.axisBottom(x))
    .selectAll("text")
    .attr("transform", "translate(-10,0)rotate(-45)")
    .style("text-anchor", "end");

// Add Y axis
svg.append("g")
    .call(d3.axisLeft(y));

// Add Y axis label
svg.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 - margin.left)
    .attr("x", 0 - (height / 2))
    .attr("dy", "1em")
    .style("text-anchor", "middle")
    .text("Average Length");

// Add title
svg.append("text")
    .attr("x", width / 2)
    .attr("y", 0 - (margin.top / 2))
    .attr("text-anchor", "middle")
    .style("font-size", "16px")
    .style("font-weight", "bold")
    .text("Average Response Length by Model");

// Add bars
svg.selectAll("bar")
    .data(data)
    .enter()
    .append("rect")
    .attr("x", d => x(d.model))
    .attr("y", d => y(d.length))
    .attr("width", x.bandwidth())
    .attr("height", d => height - y(d.length))
    .attr("fill", "#4f46e5");
</script>

<p style="color:gray; text-align: center;">Table 1. Average response lengths for each model</p>

- We inspect whether response token length per model is correlated with preferences. Interestingly, we tend to see that people tend to prefer shorter responses. This is the _opposite_ effect compared to what has been observed in prior work where people tend to prefer longer responses. This may however be correlated with model quality.

<img src="/assets/img/blog/copilot_arena_edits/winrate_matrix.png" alt="Model win rate matrix" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 2. Fraction of model A wins for all battles</p>

We follow the same leaderboard computation as the latest version of Chatbot Arena, which is based on learning Bradley-Terry coefficients that minimize loss when predicting whether one model will beat the other. Please check out this blog post for a more in-depth description.

## How do people use code edits?

For general information about how people use Copilot Arena, check out the [first blogpost](https://blog.lmarena.ai/blog/2024/copilot-arena/). Here, we will focus on code edit usage.

**How long are the prompts that people write?** We find that the median prompt length is 34 characters and mean is 139 characters. Most are fairly short and thus depend on the context that is highlighted. In comparison to the chat messages sent by users in Chatbot Arena, user prompts for inline edits tend to be much shorter. The model must instead mostly focus on test the model's ability to infer user goals based on the context (e.g., the highlighted code snippet).

<img src="/assets/img/blog/copilot_arena_edits/prompt_char_length.png" alt="Copilot Arena prompt length distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 3. Distribution of prompt character lengths.</p>

**What context lengths are we looking at?** We look at the distribution of code-to-edit token lengths, as computed by the number of highlighted tokens. The median is 138 tokens and the mean is 647 tokens. While there are some outliers, this indicates that most people are highlighting targeted portions of code for edits as this is much shorter than the full file length which is typically closer to 4.5k tokens on average.

<img src="/assets/img/blog/copilot_arena_edits/code_to_edit_token.png" alt="Copilot Arena highlighted length distribution" style="display:block; margin-top: auto; margin-left: auto; margin-right: auto; margin-bottom: auto; width: 90%">
<p style="color:gray; text-align: center;">Figure 4. Number of highlighted tokens</p>

**What kind of edits are people trying to make?** We find users write prompts for code edits in multiple languages, predominantly English but also in Russian, Chinese, and Spanish. Users typically write prompts using informal language and the prompts are typically directed towards addressing a specific goal. The distribution can be found in Figure 5.

The main categories include:

1. Resolve errors
   - E.g., "fix the syntax please", "Cannot read properties of null (reading 'image')"
2. Optimize code
   - E.g., "create a function to validate emailid and phone using regular expression", "add style to pokemon-image"
3. Write code or build on existing code
   - E.g., "create a node api to send an email", "create a function to validate emailid and phone using regular expression"
4. Code translation
   - E.g., "change this to react compound", "convert this to oops"
5. Test code
   - E.g., "create test cases", "validate the input"
6. Styling and formatting
   - E.g., "make this code beautiful", "format that to be compatible with .md"
7. Documentation and explanation
   - E.g., "explain this code", "add docstring"

<!-- prettier-ignore-start -->
<div class="l-page">
  <div id="waffle-container" style="width: 100%; height: 700px; display: flex; justify-content: center;">
    <svg id="waffle-chart"></svg>
  </div>
</div>
<d-figure>
<script src="https://d3js.org/d3.v7.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
  const data = [
    { category: 'Write/build code', count: 3564, percentage: 47.0, color: '#4f46e5' },
    { category: 'Resolve errors', count: 3330, percentage: 43.9, color: '#7c3aed' },
    { category: 'Optimize code', count: 399, percentage: 5.3, color: '#a855f7' },
    { category: 'Documentation', count: 99, percentage: 1.3, color: '#d946ef' },
    { category: 'Styling/formatting', count: 98, percentage: 1.3, color: '#ec4899' },
    { category: 'Code translation', count: 72, percentage: 0.9, color: '#f43f5e' },
    { category: 'Test code', count: 16, percentage: 0.2, color: '#fb7185' }
  ];

  // Basic setup
  const svg = d3.select("#waffle-chart");
  const margin = { top: 50, right: 50, bottom: 150, left: 50 };
  const width = 700;  // Increased overall width
  const height = 500;
  const chartWidth = 400;  // Fixed chart width
  
  svg.attr("width", width)
     .attr("height", height + margin.top + margin.bottom);

  const g = svg.append("g")
     .attr("transform", `translate(${(width - chartWidth) / 2},${margin.top})`);

  // Create 10x10 grid
  const squareSize = chartWidth / 10;
  const squarePadding = 2;
  let currentSquare = 0;
  const squares = [];

  for (let row = 0; row < 10; row++) {
    for (let col = 0; col < 10; col++) {
      let currentPercentage = 0;
      let currentCategory = null;
      
      for (const item of data) {
        currentPercentage += item.percentage;
        if (currentSquare < currentPercentage) {
          currentCategory = item;
          break;
        }
      }
      
      squares.push({
        row,
        col,
        category: currentCategory.category,
        color: currentCategory.color,
        count: currentCategory.count,
        percentage: currentCategory.percentage
      });
      
      currentSquare++;
    }
  }

  // Create tooltip div
  const tooltip = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style("opacity", 0)
    .style("position", "absolute")
    .style("background-color", "white")
    .style("border", "1px solid #ddd")
    .style("border-radius", "3px")
    .style("padding", "10px")
    .style("pointer-events", "none");

  // Add squares for each data point
  g.selectAll(".square")
    .data(squares)
    .join("rect")
    .attr("class", "square")
    .attr("x", d => d.col * (squareSize + squarePadding))
    .attr("y", d => d.row * (squareSize + squarePadding))
    .attr("width", squareSize - 2)
    .attr("height", squareSize - 2)
    .attr("fill", d => d.color)
    .on("mouseover", (event, d) => {
      tooltip.transition()
        .duration(200)
        .style("opacity", .9);
      tooltip.html(`${d.category}: ${d.count}`)
        .style("left", (event.pageX + 10) + "px")
        .style("top", (event.pageY - 28) + "px");
    })
    .on("mouseout", () => {
      tooltip.transition()
        .duration(500)
        .style("opacity", 0);
    });

  // Add title
  svg.append("text")
     .attr("x", width / 2)
     .attr("y", 30)
     .attr("text-anchor", "middle")
     .style("font-size", "16px")
     .style("font-weight", "bold")
     .text("Code Activities Distribution");

  // Add legend below the chart
  const legendItemWidth = 220;  // Increased width for legend items
  const legendItems = 2;
  const legendSpacing = 25;
  
  const legend = g.append("g")
     .attr("transform", `translate(${(chartWidth - (legendItemWidth * legendItems)) / 2}, ${height - 60})`);  // Centered legend

  // Calculate total width of all legend items
  const totalLegendWidth = data.length * legendItemWidth / 2;  // Divide by 2 since we have 2 columns

  data.forEach((d, i) => {
    const row = Math.floor(i / legendItems);
    const col = i % legendItems;
    
    const lg = legend.append("g")
                    .attr("transform", `translate(${col * legendItemWidth}, ${row * legendSpacing})`);
    
    lg.append("rect")
      .attr("width", 15)
      .attr("height", 15)
      .attr("fill", d.color)
      .attr("rx", 2);
    
    lg.append("text")
      .attr("x", 25)
      .attr("y", 12)
      .style("font-size", "14px")
      .text(`${d.category} (${d.percentage}%)`);
  });

  // Add hover interactivity to legend
  legend.selectAll(".legend-item")
    .on("mouseover", (event, d) => {
      tooltip.transition()
        .duration(200)
        .style("opacity", .9);
      tooltip.html(`${d.category}: ${d.count}`)
        .style("left", (event.pageX + 10) + "px")
        .style("top", (event.pageY - 28) + "px");
    })
    .on("mouseout", () => {
      tooltip.transition()
        .duration(500)
        .style("opacity", 0);
    });
});
</script>
</d-figure>

<!-- prettier-ignore-end -->

<p style="color:gray; text-align: center;">Figure 5. Distribution of code edit activities based on user prompts. Each square represents 1% of the total activities.</p>

## What's next?

We're still actively collecting votes for code edits and will continue with deeper analysis in the future. We're also looking into evaluating methods other than code completions and code edits.

In general, we are always looking to improve Copilot Arena. Ping us to get involved!

## Citation

```bibtex
@misc{chi2024copilot,
    title={Copilot Arena},
    author={Wayne Chi and Valerie Chen and Wei-Lin Chiang and Anastasios N. Angelopoulos and Naman Jain and Tianjun Zhang and Ion Stoica and Chris Donahue and Ameet Talwalkar}
    year={2024},
}
```
