---
layout: distill
title: "How Many User Prompts are New?"
description: Analysis of prompt freshness and benchmark contamination
giscus_comments: true
date: 2025-02-11
featured: true
thumbnail: assets/img/blog/explorer/explorer.png
authors:
  - name: Lisa Dunlap
    url: "https://www.linkedin.com/in/kelly-yuguo-tang/"
    affiliations:
      name: UC Berkeley
  - name: Elva Lu
    url: "http://angelopoulos.ai"
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
One of the key reasons why Chatbot Arena is such an enticing benchmark is that it's live: thousands of new user conversations and votes are collected every day.s. This constant stream of new data helps prevent benchmark "gaming" - training on the benchmark to get a high score. But how fresh is this data really?

We investigate 355,575 LLM battles from May 2024 to Dec 2024 to answer the following questions:

1. What proportion of prompts have never been seen before (aka "fresh")?
2. What are common duplicate prompts?
3. How many prompts appear in widely used benchmarks?

We find that:

1. Roughly 75% of the prompts collected each day are significantly different from any prompt on a previous day.
2. Duplicate prompts are largely greetings (e.g., "hi" and "hello") the same user  submitting the same prompt on the same day to multiple models, or common tester prompts like "how many r's are in strawberry?"
3. Less than 1% of user prompts appear in popular benchmarks

## How do we measure prompt duplicates?

Prompt duplicates are measured by the cosine similarity of the text embeddings (OpenAI's text-embedding-3-small). If the similarity between the embeddings of prompt a and prompt b are greater than or equal to 0.7, we consider it a duplicate. This threshold is set by manually looking through examples to determine when two prompts are asking the same thing. A random sample of prompt pairs with their similarities are provided on our hugging face. 

Given a prompt at submitted at time $$t$$, we examine the following:

- Nearest neighbor with all prompts submitted before time $$t$$
- Nearest neighbor with all prompts submitted at least a day before $$t$$
- Nearest neighbor with all prompts submitted at least a week before $$t$$ 
- Nearest neighbor with all prompts from existing datasets (contamination)

## How many duplicate prompts are there?
For roughly 75% of the prompts collected each day, there is not a similar prompt submitted on a previous day.  This indicates that roughly 75% of the prompts submitted each day are fresh.

<div class="plot-container">
  <div class="plot-buttons">
    <button onclick="togglePlot('daily')" class="plot-btn active" id="daily-btn">Daily View</button>
    <button onclick="togglePlot('weekly')" class="plot-btn" id="weekly-btn">Weekly View</button>
  </div>
  
  <div id="daily-plot" class="plot-frame">
    <iframe src="{{ '/assets/img/blog/freshness/daily_matches.html' }}" frameborder='0' scrolling='no' height="500px" width="100%" class="plot-iframe"></iframe>
  </div>
  
  <div id="weekly-plot" class="plot-frame" style="display: none;">
    <iframe src="{{ '/assets/img/blog/freshness/weekly_matches.html' }}" frameborder='0' scrolling='no' height="500px" width="100%" class="plot-iframe"></iframe>
  </div>
  
  <p style="color:gray; text-align: center;" id="plot-caption">Prompt Freshness per Day.</p>
</div>

<style>
.plot-container {
  margin: 20px 0;
}
.plot-buttons {
  margin-bottom: 15px;
  display: flex;
  gap: 10px;
}
.plot-btn {
  padding: 8px 16px;
  background-color: var(--global-bg-color, #f8f9fa);
  border: 1px solid var(--global-divider-color, #dee2e6);
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
  color: var(--global-text-color, #212529);
}
.plot-btn:hover {
  background-color: var(--global-hover-color, #e9ecef);
}
.plot-btn.active {
  background-color: var(--global-theme-color, #0076df);
  color: white;
  border-color: var(--global-theme-color, #0076df);
}
.plot-frame {
  border: 1px solid var(--global-divider-color, #dee2e6);
  border-radius: 4px;
  overflow: hidden;
}
</style>

<script>
function togglePlot(plotType) {
  // Hide all plots
  document.getElementById('daily-plot').style.display = 'none';
  document.getElementById('weekly-plot').style.display = 'none';
  
  // Remove active class from all buttons
  document.getElementById('daily-btn').classList.remove('active');
  document.getElementById('weekly-btn').classList.remove('active');
  
  // Show selected plot and activate button
  document.getElementById(`${plotType}-plot`).style.display = 'block';
  document.getElementById(`${plotType}-btn`).classList.add('active');
  
  // Update caption
  const caption = document.getElementById('plot-caption');
  if (plotType === 'daily') {
    caption.textContent = 'Prompt Freshness per Day.';
  } else {
    caption.textContent = 'Prompt Freshness per Week.';
  }
}
</script>

While we do see a downward trend in proportion of unique prompts over time, this decrease is plateauing. Interestingly, we also see certain dates where prompt freshness is significantly lower than neighboring dates: we will get to why that is in the next section. 


## What are the sources of duplicates?
We find that many of the duplicates can be attributed to 3 things: "tester"prompts, hi/hello's, and prompts asked multiple times by the same user back to back. 

**Hi's and Hello's**. We see that 2.1% of our data is some variation of "hi" in various languages. As per our deduplication policy, these are deduplicated when calculating the final rankings.  

**Tester prompts** There are certain prompts that users have found to stump most LLM's, like "how many r's are in strawberry" or "what is bigger, 9.11 or 9.8". When a new model comes out, these prompts are commonly asked to gauge performance, which can be a source of days with a low proportion of fresh prompts. For instance, the week of August 8th saw a large decrease in prompt freshness, which coincides with a release of an update to GPT-4o. Looking at the top prompts on those days we see many of these prompts are a version of "how many r's are in strawberry". [add in potential dedup policy?]

<div>
  <iframe src="{{ '/assets/img/blog/freshness/strawberry_and_nn_match.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Strawberry and Nearest Neighbor Matches.</p>

<div>
  <iframe src="{{ '/assets/img/blog/freshness/most_common_prompt_per_day.html' }}" frameborder='0' scrolling='no' height="500px" width="100%"></iframe>
</div>
<p style="color:gray; text-align: center;">Most Common Prompts by Day.</p>

**Repeated prompts by the Same user**: Many duplicate prompts are submitted by the same person on the same day. Comparing prompts to every prompt seen at an previous timestep (rather than a previous day or week) 65% of prompts at a given time have been previously seen. However, most of these duplicates occur on the same day, with 60% of these prompts submitted by the same user. This indicates that users are asking a prompt, voting, then starting a new battle with two new models and asking the same prompt. This is encouraging because the models used in each conversation vary, which helps maintain diversity in prompts across different model pairs and results in more consistent voting from the same user. Removing duplicate prompts submitted by the same user on the same day raises the percentage of unique prompts from 65% to 80%. 

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
          <th>Similarity</th>
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
  transition: background-color 0.2s;
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
  border-collapse: collapse;
  margin-top: 10px;
}
.similarity-table th, .similarity-table td {
  padding: 10px;
  border: 1px solid var(--global-divider-color, #ddd);
  text-align: left;
}
.similarity-table th {
  background-color: var(--global-bg-color, #f5f5f5);
  color: var(--global-text-color, #000);
  position: sticky;
  top: 0;
}
#similarity-table-container {
  max-height: 500px;
  overflow-y: auto;
  border: 1px solid var(--global-divider-color, #ddd);
}
</style>

<script>
// Sample data structure - replace with your actual data or API endpoint
const similarityData = {
  '0.4-0.5': [
    { prompt: "How do I make chocolate chip cookies?", nearestNeighbor: "What's a good recipe for brownies?", similarity: 0.45 },
    { prompt: "Explain quantum computing", nearestNeighbor: "How does a transistor work?", similarity: 0.48 }
    // Add more examples in this range
  ],
  '0.5-0.6': [
    { prompt: "What are the best places to visit in Japan?", nearestNeighbor: "Recommend tourist attractions in Tokyo", similarity: 0.55 },
    { prompt: "How to learn Python programming?", nearestNeighbor: "Best resources for learning coding", similarity: 0.58 }
    // Add more examples in this range
  ],
  '0.6-0.7': [
    { prompt: "Write a poem about autumn", nearestNeighbor: "Create a short poem about fall leaves", similarity: 0.65 },
    { prompt: "Explain how photosynthesis works", nearestNeighbor: "Describe the process of photosynthesis in plants", similarity: 0.68 }
    // Add more examples in this range
  ],
  '0.7-0.8': [
    { prompt: "What's the capital of France?", nearestNeighbor: "Tell me the capital city of France", similarity: 0.75 },
    { prompt: "How to make pasta carbonara", nearestNeighbor: "Recipe for spaghetti carbonara", similarity: 0.77 }
    // Add more examples in this range
  ],
  '0.8-0.9': [
    { prompt: "Who was Albert Einstein?", nearestNeighbor: "Tell me about Albert Einstein", similarity: 0.85 },
    { prompt: "How many r's are in strawberry?", nearestNeighbor: "Count the number of r's in strawberry", similarity: 0.88 }
    // Add more examples in this range
  ],
  '0.9-1.0': [
    { prompt: "Hello", nearestNeighbor: "Hi", similarity: 0.92 },
    { prompt: "What is 2+2?", nearestNeighbor: "Calculate 2+2", similarity: 0.95 }
    // Add more examples in this range
  ]
};

function filterSimilarity(range) {
  // Update active button
  document.querySelectorAll('.sim-btn').forEach(btn => {
    btn.classList.remove('active');
  });
  document.querySelector(`.sim-btn:nth-child(${Object.keys(similarityData).indexOf(range) + 1})`).classList.add('active');
  
  // Update table content
  const tableBody = document.getElementById('similarity-table-body');
  tableBody.innerHTML = '';
  
  similarityData[range].forEach(item => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${item.prompt}</td>
      <td>${item.nearestNeighbor}</td>
      <td>${item.similarity.toFixed(2)}</td>
    `;
    tableBody.appendChild(row);
  });
}

// Initialize with first range
document.addEventListener('DOMContentLoaded', () => {
  filterSimilarity('0.7-0.8'); // Start with our threshold range
});
</script>

## Conclusion
The majority of our user prompts are fresh (i.e., 75%), and the data is not contaminated by existing benchmarks. A sample of the data with their nearest neighbors to the original prompt can be found in this space. We are excited to see how this data evolves over time!


## Citation

```bibtex
@misc{dunlap2025freshness,
    title={How Many User Prompts Have Never Been Seen Before?},
    author={Lisa Dunlap and Elva Lu and Joseph E. Gonzalez and Anastasios N. Angelopoulos and Wei-Lin Chiang and Ion Stoica},
    year={2025},
}
```
