---
layout: distill
title: "How Many User Prompts are New?"
description: Analysis of prompt freshness and benchmark contamination
giscus_comments: true
date: 2025-04-18
featured: true
thumbnail: assets/img/blog/freshness/thumbnail.png
authors:
  - name: Lisa Dunlap
    url: "https://www.lisabdunlap.com/"
    affiliations:
      name: UC Berkeley
  - name: Elva Lu
    url: "https://datascience.uchicago.edu/people/elva-lu/"
  - name: Joseph E. Gonzalez
    url: "https://people.eecs.berkeley.edu/~jegonzal/"
  - name: Anastasios N. Angelopoulos
    url: "https://angelopoulos.ai"
  - name: Wei-Lin Chiang
    url: "https://infwinston.github.io/"
  - name: Ion Stoica
    url: "https://people.eecs.berkeley.edu/~istoica/"
---

## Intro

One of the key reasons why Chatbot Arena is such an enticing benchmark is that it's live: thousands of new user conversations and votes are collected every day. This constant stream of new data helps prevent benchmark "gaming" - training on the benchmark to get a high score. But how fresh is this data really?

We investigate 355,575 LLM battles from May 2024 to Dec 2024 to answer the following questions:

1\. What proportion of prompts have never been seen before (aka "fresh")?  
2\. What are common duplicate prompts?  
3\. How many prompts appear in widely used benchmarks?

We find that:

1\. Roughly 75% of the prompts collected each day are significantly different from any prompt on a previous day.  
2\. Duplicate prompts are largely greetings (e.g., "hi" and "hello"), the same user submitting the same prompt on the same day to multiple models, or common tester prompts like "how many r's are in strawberry?"  
3\. Less than 1% of user prompts appear in popular benchmarks

## How do we measure prompt duplicates?

Prompt duplicates are measured by the cosine similarity of the text embeddings (OpenAI's text-embedding-3-small). If the similarity between the embeddings of prompt a and prompt b are greater than or equal to 0.7, we consider it a duplicate. This threshold is set by manually looking through examples to determine when two prompts are asking the same thing. A random sample of prompt pairs with their similarities are provided on our [Hugging Face](https://huggingface.co/lmarena-ai).

Given a prompt at submitted at time $$t$$, we examine the following:

- The largest similarity between the prompt submitted at time $$t$$ and any prompt submitted before time $$t$$
- The largest similarity between the prompt submitted at time $$t$$ and any prompt submitted at least one day before time $$t$$
- The largest similarity between the prompt submitted at time $$t$$ and any prompt submitted at least one week before time $$t$$
- The largest similarity between the prompt submitted at time $$t$$ and any prompt from an existing dataset (contamination analysis)

## How many duplicate prompts are there?

For roughly 75% of the prompts collected each day, there is not a similar prompt submitted on a previous day. This indicates that roughly 75% of the prompts submitted each day are fresh.

<div class="plot-container">
  <div class="plot-toggle">
    <button onclick="togglePlotView('daily')" class="toggle-btn active" id="daily-btn">Daily View</button>
    <button onclick="togglePlotView('weekly')" class="toggle-btn" id="weekly-btn">Weekly View</button>
  </div>
  
  <div class="plot-wrapper">
    <div class="plot-frame active" id="daily-plot">
      <iframe src="{{ '/assets/img/blog/freshness/daily_matches.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
      <p style="color:gray; text-align: center;">Prompt Freshness per Day.</p>
    </div>
    
    <div class="plot-frame" id="weekly-plot">
      <iframe src="{{ '/assets/img/blog/freshness/weekly_matches.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
      <p style="color:gray; text-align: center;">Prompt Freshness per Week.</p>
    </div>
  </div>
</div>

<style>
.plot-container {
  margin: 20px 0;
  width: 100%;
}
.plot-wrapper {
  position: relative;
  width: 100%;
}
.plot-frame {
  border: 1px solid var(--global-divider-color, #dee2e6);
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 15px;
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.3s ease;
}
.plot-frame.active {
  opacity: 1;
  visibility: visible;
  position: relative;
}
.plot-frame iframe {
  display: block;
  width: 100%;
}
.plot-toggle {
  margin-bottom: 15px;
  display: flex;
  gap: 10px;
}
.toggle-btn {
  padding: 8px 12px;
  background-color: var(--global-bg-color, #f0f0f0);
  border: 1px solid var(--global-divider-color, #ddd);
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
  color: var(--global-text-color, #000);
}
.toggle-btn:hover {
  background-color: var(--global-hover-color, #e0e0e0);
}
.toggle-btn.active {
  background-color: var(--global-theme-color, #4a6baf);
  color: white;
  border-color: var(--global-theme-color, #3a5a9f);
}
</style>

<script>
function togglePlotView(view) {
  // Hide all plots
  document.querySelectorAll('.plot-frame').forEach(function(plot) {
    plot.classList.remove('active');
  });
  
  // Remove active class from all buttons
  document.querySelectorAll('.toggle-btn').forEach(function(btn) {
    btn.classList.remove('active');
  });
  
  // Show selected plot and activate button
  document.getElementById(view + '-plot').classList.add('active');
  document.getElementById(view + '-btn').classList.add('active');
}
</script>

If you look at the above analysis, the proportion of fresh prompts decreases as a function of $$t$$. This is expected, since as $$t$$ grows, we are comparing new prompts with an ever-larger set of past prompts. For example, when $$t=1$$, there are no previos prompts, so of course, the proportion of unique prompts is $$1/1=100$$%.

However, as $$t$$ grows, this number stabilizes to around 70-80% fresh prompts at a similarity threshold of 0.7. This equilibrium represents the fraction of fresh prompts that we expect chatbot arena to generate in the long run.

Interestingly, we also see certain dates where prompt freshness is significantly lower than neighboring dates: we will get to why that is in the next section.

## What are the sources of duplicates?

We find that many of the duplicates can be attributed to 3 things: "tester"prompts, hi/hello's, and prompts asked multiple times by the same user back to back.

**Hi's and Hello's.** We see that 2.1% of our data is some variation of "hi" in various languages. As per our deduplication policy, these are deduplicated when calculating the final rankings.

**Tester prompts.** There are certain prompts that users have found to stump most LLM's, like "how many r's are in strawberry" or "what is bigger, 9.11 or 9.8". When a new model comes out, these prompts are commonly asked to gauge performance, which can be a source of days with a low proportion of fresh prompts. For instance, the week of August 8th saw a large decrease in prompt freshness, which coincides with a release of an update to GPT-4o. Looking at the top prompts on those days we see many of these prompts are a version of "how many r's are in strawberry".

<div>
  <iframe src="{{ '/assets/img/blog/freshness/strawberry_and_nn_match.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Strawberry and Nearest Neighbor Matches.</p>

<div>
  <iframe src="{{ '/assets/img/blog/freshness/most_common_prompt_per_week.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Most Common Prompts by 
Week (excluding "hi" prompts).</p>

**Repeated prompts by the same user.** Many duplicate prompts are submitted by the same person on the same day. Comparing prompts to every prompt seen at an previous timestep (rather than a previous day or week) 65% of prompts at a given time have been previously seen. However, most of these duplicates occur on the same day, with 60% of these prompts submitted by the same user. This indicates that users are asking a prompt, voting, then starting a new battle with two new models and asking the same prompt. This is encouraging because the models used in each conversation vary, which helps maintain diversity in prompts across different model pairs and results in more consistent voting from the same user. Removing duplicate prompts submitted by the same user on the same day raises the percentage of unique prompts from 65% to 80%.

<div>
  <iframe src="{{ '/assets/img/blog/freshness/days_before_nn_log.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Days before nearest neighbor is seen.</p>

## How many prompts are seen in existing datasets?

Lastly, we wanted to ensure that the prompts are not contained in commonly used benchmarks. Using the same similarity measure, we find a very low percentage of user prompts are seen in existing datasets, reducing the likelihood that models which overfit to these benchmarks are given an advantage in the arena.

<div>
  <iframe src="{{ '/assets/img/blog/freshness/contamination_summary.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Contamination of Prompts in Existing Datasets.</p>

## Conclusion

The majority of our user prompts are fresh (i.e., 75%), and the data is not contaminated by existing benchmarks. A sample of the data with their nearest neighbors to the original prompt can be found in this space. We are excited to see how this data evolves over time!

## Citation

```bibtex
@misc{dunlap2025freshness,
    title={How Many User Prompts are New?},
    author={Lisa Dunlap and Elva Lu and Joseph E. Gonzalez and Anastasios N. Angelopoulos and Wei-Lin Chiang and Ion Stoica},
    year={2025},
}
```

## Prompt Similarity Examples

To better understand how our similarity threshold works in practice, we've provided examples of prompt pairs at different similarity levels. Use the buttons below to explore prompt pairs within specific similarity ranges.

<div class="similarity-explorer">
  <div class="similarity-buttons">
    <button onclick="filterSimilarity('0.4-0.5')" class="sim-btn">0.4-0.5</button>
    <button onclick="filterSimilarity('0.5-0.6')" class="sim-btn">0.5-0.6</button>
    <button onclick="filterSimilarity('0.6-0.7')" class="sim-btn">0.6-0.7</button>
    <button onclick="filterSimilarity('0.7-0.8')" class="sim-btn">0.7-0.8</button>
    <button onclick="filterSimilarity('0.8-0.9')" class="sim-btn">0.8-0.9</button>
    <button onclick="filterSimilarity('0.9-1.0')" class="sim-btn">0.9-1.0</button>
  </div>
  <div id="similarity-table-container">
    <table id="similarity-table" class="similarity-table">
      <thead>
        <tr>
          <th>Prompt</th>
          <th>Nearest Neighbor</th>
          <th>Sim</th>
        </tr>
      </thead>
      <tbody id="similarity-table-body">
        <!-- Table content will be loaded here -->
      </tbody>
    </table>
  </div>
</div>

<style>
.similarity-explorer {
  margin: 20px 0;
  font-family: sans-serif;
}
.similarity-buttons {
  margin-bottom: 15px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.sim-btn {
  padding: 8px 12px;
  background-color: var(--global-bg-color, #f0f0f0);
  border: 1px solid var(--global-divider-color, #ddd);
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
  color: var(--global-text-color, #000);
}
.sim-btn:hover {
  background-color: var(--global-hover-color, #e0e0e0);
}
.sim-btn.active {
  background-color: var(--global-theme-color, #4a6baf);
  color: white;
  border-color: var(--global-theme-color, #3a5a9f);
}
.similarity-table {
  width: 100%;
  table-layout: fixed;
  border-collapse: collapse;
  margin-top: 10px;
  font-size: 0.95em;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  border-radius: 5px;
  overflow: hidden;
}
.similarity-table th, .similarity-table td {
  padding: 12px 15px;
  border: 1px solid var(--global-divider-color, #ddd);
  text-align: left;
  overflow-wrap: break-word;
  word-wrap: break-word;
}
.similarity-table th:nth-child(1), .similarity-table td:nth-child(1) {
  width: 45%;
}
.similarity-table th:nth-child(2), .similarity-table td:nth-child(2) {
  width: 45%;
}
.similarity-table th:nth-child(3), .similarity-table td:nth-child(3) {
  width: 10%;
  text-align: center;
}
.similarity-table th {
  background-color: var(--global-theme-color, #4a6baf);
  color: white;
  font-weight: bold;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-size: 0.9em;
  position: sticky;
  top: 0;
}
.similarity-table tr:nth-child(even) {
  background-color: var(--global-code-bg-color, #f8f9fa);
}
.similarity-table tr:hover {
  background-color: var(--global-hover-color, #e9ecef);
}
#similarity-table-container {
  max-height: 500px;
  overflow-y: auto;
  border-radius: 5px;
  border: 1px solid var(--global-divider-color, #ddd);
}
</style>

<script>
// Load data from JSON file
let similarityData = {
  '0.4-0.5': [],
  '0.5-0.6': [],
  '0.6-0.7': [],
  '0.7-0.8': [],
  '0.8-0.9': [],
  '0.9-1.0': []
};

// Fetch and process the JSON data
fetch('/assets/img/blog/freshness/blog_sample.json')
  .then(response => response.json())
  .then(data => {
    // Process the data and organize by similarity ranges
    data.forEach(item => {
      const sim = parseFloat(item.Similarity);
      if (sim >= 0.4 && sim < 0.5) similarityData['0.4-0.5'].push(item);
      else if (sim >= 0.5 && sim < 0.6) similarityData['0.5-0.6'].push(item);
      else if (sim >= 0.6 && sim < 0.7) similarityData['0.6-0.7'].push(item);
      else if (sim >= 0.7 && sim < 0.8) similarityData['0.7-0.8'].push(item);
      else if (sim >= 0.8 && sim < 0.9) similarityData['0.8-0.9'].push(item);
      else if (sim >= 0.9 && sim <= 1.0) similarityData['0.9-1.0'].push(item);
    });
    
    // Initialize with the threshold range
    filterSimilarity('0.7-0.8');
  })
  .catch(error => {
    console.error('Error loading similarity data:', error);
    document.getElementById('similarity-table-body').innerHTML = 
      '<tr><td colspan="3">Error loading data. Please try again later.</td></tr>';
  });

function filterSimilarity(range) {
  // Update active button
  document.querySelectorAll('.sim-btn').forEach(btn => {
    btn.classList.remove('active');
  });
  document.querySelector(`.sim-btn:nth-child(${Object.keys(similarityData).indexOf(range) + 1})`).classList.add('active');
  
  // Update table content
  const tableBody = document.getElementById('similarity-table-body');
  tableBody.innerHTML = '';
  
  if (similarityData[range].length === 0) {
    tableBody.innerHTML = '<tr><td colspan="3">No examples in this similarity range.</td></tr>';
    return;
  }
  
  similarityData[range].forEach(item => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${item.Prompt}</td>
      <td>${item["Nearest Neighbor"]}</td>
      <td><strong>${parseFloat(item.Similarity).toFixed(2)}</strong></td>
    `;
    tableBody.appendChild(row);
  });
}

// Initialize will happen after data is loaded
</script>
